import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_1/models/dhikr_item.dart';

// تخزين محلي على الهاتف باستخدام SharedPreferences.
class AppStore extends ChangeNotifier {
  Set<String> favorites = {};
  Map<String, int> dhikrCounts = {};
  int tasbeehCount = 0;
  int dailyCompleted = 0;
  bool ready = false;
  ThemeMode themeMode = ThemeMode.system;
  bool hapticEnabled = true;
  double fontSizeDelta = 0.0; // زيادة أو تقليل حجم الخط (-2 إلى +6)

  static const _favoritesKey = 'favorites_v1';
  static const _countsKey = 'dhikr_counts_v1';
  static const _tasbeehKey = 'tasbeeh_count_v1';
  static const _dailyKey = 'daily_completed_v1';
  static const _dateKey = 'daily_date_v1';
  static const _themeModeKey = 'theme_mode_v1';
  static const _hapticKey = 'haptic_enabled_v1';
  static const _fontSizeKey = 'font_size_v1';

  String get todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    favorites = (prefs.getStringList(_favoritesKey) ?? []).toSet();
    tasbeehCount = prefs.getInt(_tasbeehKey) ?? 0;
    hapticEnabled = prefs.getBool(_hapticKey) ?? true;
    fontSizeDelta = prefs.getDouble(_fontSizeKey) ?? 0.0;

    final themeStr = prefs.getString(_themeModeKey);
    if (themeStr == 'dark') {
      themeMode = ThemeMode.dark;
    } else if (themeStr == 'light') {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.system;
    }

    final savedDate = prefs.getString(_dateKey);
    if (savedDate == todayKey) {
      dailyCompleted = prefs.getInt(_dailyKey) ?? 0;
      final rawCounts = prefs.getString(_countsKey);
      if (rawCounts != null) {
        try {
          final decoded = jsonDecode(rawCounts) as Map<String, dynamic>;
          dhikrCounts = decoded.map(
            (key, value) => MapEntry(key, (value as num).toInt()),
          );
        } catch (_) {
          dhikrCounts = {};
        }
      }
    } else {
      dailyCompleted = 0;
      dhikrCounts = {};
      await prefs.setString(_dateKey, todayKey);
      await prefs.setInt(_dailyKey, 0);
      await prefs.setString(_countsKey, '{}');
    }

    ready = true;
    notifyListeners();
  }

  /// التحقق التلقائي عند استئناف التطبيق من تغير اليوم وتصفير إنجاز اليوم
  Future<void> checkDateRollover() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString(_dateKey);
    if (savedDate != todayKey) {
      dailyCompleted = 0;
      dhikrCounts = {};
      await prefs.setString(_dateKey, todayKey);
      await prefs.setInt(_dailyKey, 0);
      await prefs.setString(_countsKey, '{}');
      notifyListeners();
    }
  }

  void _triggerHaptic({bool heavy = false}) {
    if (!hapticEnabled) return;
    try {
      if (heavy) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    } catch (_) {}
  }

  bool isFavorite(String id) => favorites.contains(id);
  int countFor(String id) => dhikrCounts[id] ?? 0;

  Future<void> toggleFavorite(String id) async {
    _triggerHaptic();
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, favorites.toList());
    notifyListeners();
  }

  Future<void> incrementDhikr(DhikrItem item) async {
    final current = countFor(item.id);
    if (current >= item.target) return;
    final next = current + 1;
    dhikrCounts[item.id] = next;
    dailyCompleted++;

    final isCompleted = next >= item.target;
    _triggerHaptic(heavy: isCompleted);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_countsKey, jsonEncode(dhikrCounts));
    await prefs.setInt(_dailyKey, dailyCompleted);
    await prefs.setString(_dateKey, todayKey);
    notifyListeners();
  }

  Future<void> resetDhikr(DhikrItem item) async {
    _triggerHaptic(heavy: true);
    dhikrCounts[item.id] = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_countsKey, jsonEncode(dhikrCounts));
    notifyListeners();
  }

  Future<void> incrementTasbeeh() async {
    _triggerHaptic();
    tasbeehCount++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tasbeehKey, tasbeehCount);
    notifyListeners();
  }

  Future<void> resetTasbeeh() async {
    _triggerHaptic(heavy: true);
    tasbeehCount = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tasbeehKey, 0);
    notifyListeners();
  }

  Future<void> toggleThemeMode() async {
    _triggerHaptic();
    if (themeMode == ThemeMode.light) {
      themeMode = ThemeMode.dark;
    } else if (themeMode == ThemeMode.dark) {
      themeMode = ThemeMode.system;
    } else {
      themeMode = ThemeMode.light;
    }
    final prefs = await SharedPreferences.getInstance();
    final str = themeMode == ThemeMode.dark
        ? 'dark'
        : (themeMode == ThemeMode.light ? 'light' : 'system');
    await prefs.setString(_themeModeKey, str);
    notifyListeners();
  }

  Future<void> toggleHaptic() async {
    hapticEnabled = !hapticEnabled;
    _triggerHaptic();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticKey, hapticEnabled);
    notifyListeners();
  }

  Future<void> changeFontSize(double delta) async {
    fontSizeDelta = (fontSizeDelta + delta).clamp(-2.0, 6.0);
    _triggerHaptic();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, fontSizeDelta);
    notifyListeners();
  }
}

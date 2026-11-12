import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_1/models/dhikr_item.dart';

// تخزين محلي على الهاتف باستخدام SharedPreferences.
class AppStore extends ChangeNotifier {
  Set<String> favorites = {};
  Map<String, int> dhikrCounts = {};
  int tasbeehCount = 0;
  int dailyCompleted = 0;
  bool ready = false;

  static const _favoritesKey = 'favorites_v1';
  static const _countsKey = 'dhikr_counts_v1';
  static const _tasbeehKey = 'tasbeeh_count_v1';
  static const _dailyKey = 'daily_completed_v1';
  static const _dateKey = 'daily_date_v1';

  String get todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    favorites = (prefs.getStringList(_favoritesKey) ?? []).toSet();
    tasbeehCount = prefs.getInt(_tasbeehKey) ?? 0;

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

  bool isFavorite(String id) => favorites.contains(id);
  int countFor(String id) => dhikrCounts[id] ?? 0;

  Future<void> toggleFavorite(String id) async {
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
    dhikrCounts[item.id] = current + 1;
    dailyCompleted++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_countsKey, jsonEncode(dhikrCounts));
    await prefs.setInt(_dailyKey, dailyCompleted);
    await prefs.setString(_dateKey, todayKey);
    notifyListeners();
  }

  Future<void> resetDhikr(DhikrItem item) async {
    dhikrCounts[item.id] = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_countsKey, jsonEncode(dhikrCounts));
    notifyListeners();
  }

  Future<void> incrementTasbeeh() async {
    tasbeehCount++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tasbeehKey, tasbeehCount);
    notifyListeners();
  }

  Future<void> resetTasbeeh() async {
    tasbeehCount = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tasbeehKey, 0);
    notifyListeners();
  }
}

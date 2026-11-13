import 'package:flutter/material.dart';
import 'package:app_1/core/theme/app_theme.dart';
import 'package:app_1/core/utils/hijri_date.dart';
import 'package:app_1/core/utils/prayer_times.dart';
import 'package:app_1/data/adhkar_data.dart';
import 'package:app_1/screens/custom_adhkar_screen.dart';
import 'package:app_1/screens/dhikr_list_screen.dart';
import 'package:app_1/screens/favorites_screen.dart';
import 'package:app_1/screens/prayer_times_screen.dart';
import 'package:app_1/screens/progress_screen.dart';
import 'package:app_1/screens/qibla_screen.dart';
import 'package:app_1/screens/tasbeeh_screen.dart';
import 'package:app_1/services/app_store.dart';
import 'package:app_1/widgets/dhikr_search_delegate.dart';

class HomePage extends StatelessWidget {
  final AppStore store;
  const HomePage({super.key, required this.store});

  void open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AnimatedBuilder(
            animation: store,
            builder: (context, _) => SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tune, color: brandGreen),
                      const SizedBox(width: 10),
                      const Text(
                        'إعدادات التطبيق',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.palette_outlined, color: brandGreen),
                    title: const Text('المظهر (الوضع الليلي)'),
                    subtitle: Text(
                      store.themeMode == ThemeMode.dark
                          ? 'الوضع الداكن'
                          : (store.themeMode == ThemeMode.light
                              ? 'الوضع الفاتح'
                              : 'تلقائي (حسب النظام)'),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        store.themeMode == ThemeMode.dark
                            ? Icons.dark_mode
                            : (store.themeMode == ThemeMode.light
                                ? Icons.light_mode
                                : Icons.brightness_auto),
                        color: brandGreen,
                      ),
                      onPressed: store.toggleThemeMode,
                    ),
                  ),
                  SwitchListTile(
                    secondary:
                        const Icon(Icons.vibration, color: brandGreen),
                    title: const Text('الاهتزاز التفاعلي'),
                    subtitle: const Text('اهتزاز خفيف عند التسبيح والعد'),
                    value: store.hapticEnabled,
                    activeThumbColor: brandGreen,
                    onChanged: (_) => store.toggleHaptic(),
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.format_size, color: brandGreen),
                    title: const Text('حجم خط الأذكار'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: store.fontSizeDelta <= -2.0
                              ? null
                              : () => store.changeFontSize(-1.0),
                        ),
                        Text(
                          '${(store.fontSizeDelta + 21).toInt()}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: store.fontSizeDelta >= 6.0
                              ? null
                              : () => store.changeFontSize(1.0),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_active_outlined,
                        color: brandGreen),
                    title: const Text('تنبيهات الأذكار اليومية'),
                    subtitle: const Text('تذكير بأذكار الصباح والمساء'),
                    value: store.remindersEnabled,
                    activeThumbColor: brandGreen,
                    onChanged: (_) => store.toggleReminders(),
                  ),
                  if (store.remindersEnabled) ...[
                    ListTile(
                      leading: const Icon(Icons.wb_sunny_outlined,
                          color: brandGreen),
                      title: const Text('موعد تذكير أذكار الصباح'),
                      subtitle: Text(
                          '${store.morningReminderHour.toString().padLeft(2, '0')}:${store.morningReminderMinute.toString().padLeft(2, '0')} صباحاً'),
                      trailing: const Icon(Icons.edit_outlined, size: 20),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: store.morningReminderHour,
                            minute: store.morningReminderMinute,
                          ),
                        );
                        if (picked != null) {
                          store.setMorningReminder(picked.hour, picked.minute);
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.nights_stay_outlined,
                          color: brandGreen),
                      title: const Text('موعد تذكير أذكار المساء'),
                      subtitle: Text(
                          '${(store.eveningReminderHour > 12 ? store.eveningReminderHour - 12 : store.eveningReminderHour).toString().padLeft(2, '0')}:${store.eveningReminderMinute.toString().padLeft(2, '0')} مساءً'),
                      trailing: const Icon(Icons.edit_outlined, size: 20),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: store.eveningReminderHour,
                            minute: store.eveningReminderMinute,
                          ),
                        );
                        if (picked != null) {
                          store.setEveningReminder(picked.hour, picked.minute);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Card(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF1E2E28)
                          : const Color(0xFFEAF2EE),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: brandGreen, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'يصدر التنبيه بنغمة إشعارات هاتفك الافتراضية مع الاهتزاز.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hijriDate = HijriDate.fromDate(DateTime.now()).formatFull();

    final sections = [
      _Section(
        'أذكار الصباح',
        Icons.wb_sunny_outlined,
        () => open(
          context,
          DhikrListScreen(
            title: 'أذكار الصباح',
            items: morningAdhkar,
            store: store,
          ),
        ),
      ),
      _Section(
        'أذكار المساء',
        Icons.nights_stay_outlined,
        () => open(
          context,
          DhikrListScreen(
            title: 'أذكار المساء',
            items: eveningAdhkar,
            store: store,
          ),
        ),
      ),
      _Section(
        'السبحة الإلكترونية',
        Icons.fingerprint,
        () => open(context, TasbeehScreen(store: store)),
      ),
      _Section(
        'أذكار النوم',
        Icons.bedtime_outlined,
        () => open(
          context,
          DhikrListScreen(
            title: 'أذكار النوم',
            items: sleepAdhkar,
            store: store,
          ),
        ),
      ),
      _Section(
        'أذكار الاستيقاظ',
        Icons.alarm,
        () => open(
          context,
          DhikrListScreen(
            title: 'أذكار الاستيقاظ',
            items: wakeUpAdhkar,
            store: store,
          ),
        ),
      ),
      _Section(
        'أذكار بعد الصلاة',
        Icons.mosque_outlined,
        () => open(
          context,
          DhikrListScreen(
            title: 'أذكار بعد الصلاة',
            items: prayerAdhkar,
            store: store,
          ),
        ),
      ),
      _Section(
        'الرقية الشرعية',
        Icons.health_and_safety_outlined,
        () => open(
          context,
          DhikrListScreen(
            title: 'الرقية الشرعية',
            items: ruqyahAdhkar,
            store: store,
          ),
        ),
      ),
      _Section(
        'تفريج الكرب والهم',
        Icons.shield_outlined,
        () => open(
          context,
          DhikrListScreen(
            title: 'أدعية تفريج الكرب والهم',
            items: distressAdhkar,
            store: store,
          ),
        ),
      ),
      _Section(
        'أذكار المسجد',
        Icons.door_front_door_outlined,
        () => open(
          context,
          DhikrListScreen(
            title: 'أذكار المسجد',
            items: mosqueAdhkar,
            store: store,
          ),
        ),
      ),
      _Section(
        'مواقيت الصلاة',
        Icons.access_time_filled,
        () => open(context, PrayerTimesScreen(store: store)),
      ),
      _Section(
        'اتجاه القبلة',
        Icons.explore,
        () => open(context, QiblaScreen(store: store)),
      ),
      _Section(
        'أذكاري الخاصة',
        Icons.edit_note,
        () => open(context, CustomAdhkarScreen(store: store)),
      ),
      _Section(
        'المفضلة',
        Icons.favorite_border,
        () => open(context, FavoritesScreen(store: store)),
      ),
      _Section(
        'إنجازاتي',
        Icons.bar_chart,
        () => open(context, ProgressScreen(store: store)),
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'رفيق الأذكار',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              tooltip: 'بحث في الأذكار',
              icon: const Icon(Icons.search),
              onPressed: () => showSearch(
                context: context,
                delegate: DhikrSearchDelegate(store: store),
              ),
            ),
            IconButton(
              tooltip: 'المظهر',
              icon: Icon(
                store.themeMode == ThemeMode.dark
                    ? Icons.dark_mode
                    : (store.themeMode == ThemeMode.light
                        ? Icons.light_mode
                        : Icons.brightness_auto),
              ),
              onPressed: store.toggleThemeMode,
            ),
            IconButton(
              tooltip: 'الإعدادات',
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => _showSettingsModal(context),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Text(
                'السلام عليكم ورحمة الله',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 16, color: brandGold),
                  const SizedBox(width: 6),
                  Text(
                    hijriDate,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? brandGold : const Color(0xFF997519),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF14473C), const Color(0xFF1A5A4D)]
                        : [brandGreen, const Color(0xFF238875)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Color(0xFFFFD76A),
                      size: 30,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'ألا بذكر الله تطمئن القلوب',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'أذكار وأدعية مأثورة موثقة بالسند، وعدادات تعينك على الذكر',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              AnimatedBuilder(
                animation: store,
                builder: (context, _) {
                  final now = DateTime.now();
                  final prayers =
                      PrayerTimesCalculator.calculate(now, store.selectedCity);
                  PrayerTime nextPrayer = prayers.first;
                  for (final p in prayers) {
                    if (p.time.isAfter(now)) {
                      nextPrayer = p;
                      break;
                    }
                  }
                  final diff = nextPrayer.time.difference(now);
                  final hours = diff.inHours;
                  final minutes = diff.inMinutes % 60;
                  final remainingText = diff.isNegative
                      ? 'حان وقتها'
                      : (hours > 0
                          ? 'متبقي $hours س و $minutes د'
                          : 'متبقي $minutes دقيقة');

                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: brandGreen.withValues(alpha: 0.18),
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () =>
                          open(context, PrayerTimesScreen(store: store)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: brandGreen.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.schedule,
                                  color: brandGreen, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'الصلاة القادمة: ${nextPrayer.arabicName}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '(${store.selectedCity.name})',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${nextPrayer.format12Hour()} • $remainingText',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: brandGold,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_back_ios_new,
                                size: 14, color: brandGreen),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'أقسام الأذكار',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '${sections.length} أقسام',
                    style: TextStyle(
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sections.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.35,
                ),
                itemBuilder: (context, index) {
                  final section = sections[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: section.onTap,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(section.icon, size: 34, color: brandGreen),
                            const SizedBox(height: 10),
                            Text(
                              section.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Icon(
                              Icons.arrow_back_ios_new,
                              size: 12,
                              color: brandGold,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              AnimatedBuilder(
                animation: store,
                builder: (context, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.today, color: brandGreen, size: 28),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'إنجازات اليوم',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '${store.dailyCompleted} تكرار',
                          style: const TextStyle(
                            color: brandGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  _Section(this.title, this.icon, this.onTap);
}

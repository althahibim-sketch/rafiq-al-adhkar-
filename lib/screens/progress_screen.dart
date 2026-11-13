import 'package:flutter/material.dart';
import 'package:app_1/core/theme/app_theme.dart';
import 'package:app_1/services/app_store.dart';
import 'package:app_1/widgets/stat_card.dart';

class ProgressScreen extends StatelessWidget {
  final AppStore store;
  const ProgressScreen({super.key, required this.store});

  static const List<String> weekDays = [
    'السبت',
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final now = DateTime.now();
    // In DateTime, Monday is 1, Sunday is 7.
    // In Arabic week: Saturday is 6, Sunday is 7, Monday is 1...
    // Let's compute Arabic weekday index: Saturday = 0, Sunday = 1, ... Friday = 6
    final int todayIndex = (now.weekday + 1) % 7;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إنجازاتي وسلسلة الالتزام'),
        ),
        body: AnimatedBuilder(
          animation: store,
          builder: (context, _) {
            final finished = store.allUserAdhkar
                .where((item) => store.countFor(item.id) >= item.target)
                .length;

            return ListView(
              padding: const EdgeInsets.all(18),
              children: [
                // كارت سلسلة الأيام المتواصلة
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF2C2413), const Color(0xFF453612)]
                          : [const Color(0xFFFFF3D6), const Color(0xFFFFE7AA)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: brandGold.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_fire_department,
                              color: Color(0xFFE65100), size: 38),
                          const SizedBox(width: 8),
                          Text(
                            '${store.streakDays}',
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE65100),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            store.streakDays == 1
                                ? 'يوم متواصل'
                                : (store.streakDays == 2
                                    ? 'يومان متواصلان'
                                    : 'أيام متواصلة'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '«أَحَبُّ الأَعْمَالِ إِلَى اللَّهِ أَدْوَمُهَا وَإِنْ قَلَّ»',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: isDark ? brandGold : const Color(0xFF7A5800),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // شريط أيام الأسبوع
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (index) {
                          final isToday = index == todayIndex;
                          final isPast = index <= todayIndex;
                          return Column(
                            children: [
                              Text(
                                weekDays[index].substring(0, 2),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isToday
                                      ? brandGreen
                                      : (isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isToday
                                      ? brandGreen
                                      : (isPast && store.dailyCompleted > 0
                                          ? brandGold.withValues(alpha: 0.7)
                                          : (isDark
                                              ? Colors.black26
                                              : Colors.grey.shade300)),
                                ),
                                child: Center(
                                  child: isToday
                                      ? const Icon(Icons.check,
                                          size: 16, color: Colors.white)
                                      : (isPast && store.dailyCompleted > 0
                                          ? const Icon(Icons.star,
                                              size: 14, color: Colors.white)
                                          : null),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // بطاقات الإحصائيات
                StatCard(
                  title: 'تكرارات الأذكار اليوم',
                  value: '${store.dailyCompleted}',
                  icon: Icons.repeat,
                ),
                const SizedBox(height: 12),
                StatCard(
                  title: 'الأذكار المكتملة اليوم',
                  value: '$finished',
                  icon: Icons.task_alt,
                ),
                const SizedBox(height: 12),
                StatCard(
                  title: 'إجمالي السبحة الإلكترونية',
                  value: '${store.tasbeehCount}',
                  icon: Icons.fingerprint,
                ),
                const SizedBox(height: 12),
                StatCard(
                  title: 'عدد الأذكار في المفضلة',
                  value: '${store.favorites.length}',
                  icon: Icons.favorite,
                ),
                const SizedBox(height: 12),
                StatCard(
                  title: 'أذكاري الخاصة المضافة',
                  value: '${store.customAdhkar.length}',
                  icon: Icons.edit_note,
                ),

                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            color: brandGreen, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'يبدأ عداد إنجاز اليوم من جديد تلقائياً عند حلول منتصف الليل مع الاحتفاظ بسلسلة التزامك وأذكارك المفضلة والمخصصة في هاتفك.',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade700,
                              height: 1.6,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

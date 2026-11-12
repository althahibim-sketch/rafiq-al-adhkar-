import 'package:flutter/material.dart';
import 'package:app_1/core/theme/app_theme.dart';
import 'package:app_1/data/adhkar_data.dart';
import 'package:app_1/screens/dhikr_list_screen.dart';
import 'package:app_1/screens/favorites_screen.dart';
import 'package:app_1/screens/progress_screen.dart';
import 'package:app_1/screens/tasbeeh_screen.dart';
import 'package:app_1/services/app_store.dart';

class HomePage extends StatelessWidget {
  final AppStore store;
  const HomePage({super.key, required this.store});

  void open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
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
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Text(
                'السلام عليكم ورحمة الله',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF20352F),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'اجعل لسانك عامراً بذكر الله',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [brandGreen, Color(0xFF238875)],
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
                      'ابدأ يومك بذكر الله',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'أذكار موثقة، وعدادات تساعدك على المتابعة',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'أقسام التطبيق',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '٧ أقسام',
                    style: TextStyle(color: Colors.grey.shade600),
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

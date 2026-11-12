import 'package:flutter/material.dart';
import 'package:app_1/data/adhkar_data.dart';
import 'package:app_1/services/app_store.dart';
import 'package:app_1/widgets/stat_card.dart';

class ProgressScreen extends StatelessWidget {
  final AppStore store;
  const ProgressScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('إنجازاتي')),
        body: AnimatedBuilder(
          animation: store,
          builder: (context, _) {
            final finished = allAdhkar
                .where((item) => store.countFor(item.id) >= item.target)
                .length;
            return ListView(
              padding: const EdgeInsets.all(18),
              children: [
                StatCard(
                  title: 'تكرارات الأذكار اليوم',
                  value: '${store.dailyCompleted}',
                  icon: Icons.repeat,
                ),
                const SizedBox(height: 12),
                StatCard(
                  title: 'الأذكار المكتملة',
                  value: '$finished',
                  icon: Icons.task_alt,
                ),
                const SizedBox(height: 12),
                StatCard(
                  title: 'عدد الأذكار في المفضلة',
                  value: '${store.favorites.length}',
                  icon: Icons.favorite,
                ),
                const SizedBox(height: 18),
                const Text(
                  'يبدأ عداد إنجاز اليوم من جديد تلقائياً عند حلول يوم جديد. تبقى المفضلة محفوظة على الهاتف.',
                  style: TextStyle(color: Colors.grey, height: 1.7),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

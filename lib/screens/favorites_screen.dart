import 'package:flutter/material.dart';
import 'package:app_1/data/adhkar_data.dart';
import 'package:app_1/services/app_store.dart';
import 'package:app_1/widgets/dhikr_card.dart';
import 'package:app_1/widgets/empty_state.dart';

class FavoritesScreen extends StatelessWidget {
  final AppStore store;
  const FavoritesScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المفضلة'),
          actions: [
            IconButton(
              tooltip: 'تصغير الخط',
              icon: const Icon(Icons.text_decrease),
              onPressed: () => store.changeFontSize(-1.0),
            ),
            IconButton(
              tooltip: 'تكبير الخط',
              icon: const Icon(Icons.text_increase),
              onPressed: () => store.changeFontSize(1.0),
            ),
          ],
        ),
        body: AnimatedBuilder(
          animation: store,
          builder: (context, _) {
            final items =
                allAdhkar.where((item) => store.isFavorite(item.id)).toList();
            if (items.isEmpty) {
              return const EmptyState(
                icon: Icons.favorite_border,
                message: 'لم تضف أذكاراً إلى المفضلة بعد',
                detail: 'اضغط على علامة القلب في بطاقة الذكر لإضافته هنا.',
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  DhikrCard(item: items[index], store: store),
            );
          },
        ),
      ),
    );
  }
}

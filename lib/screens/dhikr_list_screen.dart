import 'package:flutter/material.dart';
import 'package:app_1/models/dhikr_item.dart';
import 'package:app_1/services/app_store.dart';
import 'package:app_1/widgets/dhikr_card.dart';

class DhikrListScreen extends StatelessWidget {
  final String title;
  final List<DhikrItem> items;
  final AppStore store;

  const DhikrListScreen({
    super.key,
    required this.title,
    required this.items,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
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
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              DhikrCard(item: items[index], store: store),
        ),
      ),
    );
  }
}

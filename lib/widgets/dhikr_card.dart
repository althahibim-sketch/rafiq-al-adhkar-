import 'package:flutter/material.dart';
import 'package:app_1/core/theme/app_theme.dart';
import 'package:app_1/models/dhikr_item.dart';
import 'package:app_1/services/app_store.dart';

class DhikrCard extends StatelessWidget {
  final DhikrItem item;
  final AppStore store;

  const DhikrCard({super.key, required this.item, required this.store});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final count = store.countFor(item.id);
        final completed = count >= item.target;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'إضافة إلى المفضلة',
                      onPressed: () => store.toggleFavorite(item.id),
                      icon: Icon(
                        store.isFavorite(item.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: store.isFavorite(item.id)
                            ? Colors.red
                            : brandGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 21,
                    height: 1.9,
                    color: Color(0xFF20352F),
                  ),
                ),
                const SizedBox(height: 12),
                if (item.note.isNotEmpty)
                  Text(
                    item.note,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                const SizedBox(height: 5),
                Text(
                  'المصدر: ${item.source}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const Divider(height: 25),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'عدد التكرارات',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      '$count / ${item.target}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: brandGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: item.target == 0
                        ? 0
                        : (count / item.target).clamp(0.0, 1.0).toDouble(),
                    minHeight: 7,
                    backgroundColor: const Color(0xFFE8EEE9),
                    color: completed ? Colors.green : brandGreen,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            completed ? null : () => store.incrementDhikr(item),
                        icon: Icon(completed ? Icons.check : Icons.add),
                        label: Text(completed ? 'اكتمل الذكر' : 'تسجيل تكرار'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandGreen,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 48),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: 'إعادة العداد',
                      onPressed:
                          count == 0 ? null : () => store.resetDhikr(item),
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

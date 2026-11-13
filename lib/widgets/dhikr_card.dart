import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_1/core/theme/app_theme.dart';
import 'package:app_1/models/dhikr_item.dart';
import 'package:app_1/services/app_store.dart';

class DhikrCard extends StatelessWidget {
  final DhikrItem item;
  final AppStore store;

  const DhikrCard({super.key, required this.item, required this.store});

  void _copyToClipboard(BuildContext context) {
    final formatted =
        '${item.title}\n\n${item.text}\n\nالمصدر: ${item.source}\n(عبر تطبيق رفيق الأذكار)';
    Clipboard.setData(ClipboardData(text: formatted));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ الذكر إلى الحافظة بنجاح'),
        duration: Duration(seconds: 2),
        backgroundColor: brandGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showVirtueDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.auto_awesome, color: brandGold),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'فضل وثواب هذا الذكر:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: brandGreen),
              ),
              const SizedBox(height: 8),
              Text(
                item.virtue,
                style: const TextStyle(height: 1.6, fontSize: 15),
              ),
              if (item.source.isNotEmpty) ...[
                const Divider(height: 24),
                Text(
                  'المصدر والتخريج:\n${item.source}',
                  style:
                      TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إغلاق',
                  style: TextStyle(
                      color: brandGreen, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('حذف الذكر المخصص'),
          content: Text('هل أنت متأكد من حذف "${item.title}" من أذكارك؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                store.deleteCustomDhikr(item.id);
              },
              child: const Text('حذف', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

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
                    if (item.virtue.isNotEmpty)
                      IconButton(
                        tooltip: 'فضل وثواب الذكر',
                        onPressed: () => _showVirtueDialog(context),
                        icon: const Icon(Icons.info_outline,
                            size: 21, color: brandGold),
                      ),
                    IconButton(
                      tooltip: 'مشاركة ونسخ الذكر',
                      onPressed: () => _copyToClipboard(context),
                      icon: const Icon(Icons.share_outlined, size: 21),
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
                    if (item.isCustom)
                      IconButton(
                        tooltip: 'حذف الذكر',
                        onPressed: () => _confirmDelete(context),
                        icon: const Icon(Icons.delete_outline,
                            size: 21, color: Colors.red),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21 + store.fontSizeDelta,
                    height: 1.9,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                if (item.note.isNotEmpty)
                  Text(
                    item.note,
                    style: TextStyle(
                      color: theme.brightness == Brightness.dark
                          ? Colors.grey.shade400
                          : Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                const SizedBox(height: 5),
                Text(
                  'المصدر: ${item.source}',
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                    fontSize: 12,
                  ),
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
                    backgroundColor: theme.brightness == Brightness.dark
                        ? const Color(0xFF2A3D36)
                        : const Color(0xFFE8EEE9),
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

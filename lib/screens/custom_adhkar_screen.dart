import 'package:flutter/material.dart';
import 'package:app_1/core/theme/app_theme.dart';
import 'package:app_1/models/dhikr_item.dart';
import 'package:app_1/services/app_store.dart';
import 'package:app_1/widgets/dhikr_card.dart';
import 'package:app_1/widgets/empty_state.dart';

class CustomAdhkarScreen extends StatelessWidget {
  final AppStore store;
  const CustomAdhkarScreen({super.key, required this.store});

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final textController = TextEditingController();
    final targetController = TextEditingController(text: '1');
    final noteController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.add_circle_outline, color: brandGreen),
              SizedBox(width: 8),
              Text('إضافة ذكر أو دعاء مخصص'),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'عنوان الذكر *',
                      hintText: 'مثلاً: دعاء تفريج الهم، صلاة على النبي...',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'العنوان مطلوب' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: textController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'نص الذكر أو الدعاء *',
                      hintText: 'اكتب نص الذكر هنا...',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'النص مطلوب' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: targetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'عدد التكرار (الهدف) *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      if (n == null || n < 1) return 'أدخل عدداً صحيحاً أكبر من 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: noteController,
                    decoration: const InputDecoration(
                      labelText: 'ملاحظة أو وقت القراءة (اختياري)',
                      hintText: 'مثلاً: بعد قيام الليل',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: brandGreen,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final newDhikr = DhikrItem(
                    id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                    title: titleController.text.trim(),
                    text: textController.text.trim(),
                    target: int.parse(targetController.text.trim()),
                    source: 'ذكر مخصص من إضافتك',
                    note: noteController.text.trim(),
                    isCustom: true,
                    category: 'custom',
                  );
                  store.addCustomDhikr(newDhikr);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('حفظ الذكر'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('أذكاري الخاصة'),
          actions: [
            IconButton(
              tooltip: 'إضافة ذكر جديد',
              icon: const Icon(Icons.add),
              onPressed: () => _showAddDialog(context),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: brandGreen,
          foregroundColor: Colors.white,
          onPressed: () => _showAddDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('إضافة ذكر'),
        ),
        body: AnimatedBuilder(
          animation: store,
          builder: (context, _) {
            if (store.customAdhkar.isEmpty) {
              return const EmptyState(
                icon: Icons.edit_note,
                message: 'لم تضف أي ذكر مخصص بعد',
                detail:
                    'يمكنك إضافة أي أدعية أو أذكار شخصية وتحديد عدد تكرارها لمتابعتها يومياً.',
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: store.customAdhkar.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  DhikrCard(item: store.customAdhkar[index], store: store),
            );
          },
        ),
      ),
    );
  }
}

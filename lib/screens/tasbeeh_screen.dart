import 'package:flutter/material.dart';
import 'package:app_1/core/theme/app_theme.dart';
import 'package:app_1/services/app_store.dart';

class TasbeehScreen extends StatefulWidget {
  final AppStore store;
  const TasbeehScreen({super.key, required this.store});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  bool _isFullScreen = false;

  void _showPhrasePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                children: [
                  Icon(Icons.format_quote, color: brandGreen),
                  SizedBox(width: 8),
                  Text(
                    'اختر صيغة الذكر',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: AppStore.defaultTasbeehPhrases.length,
                  itemBuilder: (context, index) {
                    final phrase = AppStore.defaultTasbeehPhrases[index];
                    final isSelected =
                        widget.store.currentTasbeehPhrase == phrase;
                    return ListTile(
                      title: Text(
                        phrase,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? brandGreen : null,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: brandGreen)
                          : null,
                      onTap: () {
                        widget.store.setTasbeehPhrase(phrase);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final target = store.tasbeehTarget;
          final count = store.tasbeehCount;
          final progress = target > 0
              ? (count % target) / target.toDouble()
              : 0.0;

          if (_isFullScreen) {
            return Scaffold(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : brandGreen,
              body: InkWell(
                onTap: store.incrementTasbeeh,
                child: SafeArea(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 16,
                        left: 16,
                        child: IconButton(
                          tooltip: 'الخروج من وضع الشاشة الكاملة',
                          icon: const Icon(Icons.fullscreen_exit,
                              color: Colors.white, size: 32),
                          onPressed: () =>
                              setState(() => _isFullScreen = false),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                store.currentTasbeehPhrase,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              '$count',
                              style: const TextStyle(
                                fontSize: 96,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (target > 0) ...[
                              const SizedBox(height: 10),
                              Text(
                                'الهدف: $target | الدورة: ${(count / target).floor() + 1}',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 16),
                              ),
                            ],
                            const SizedBox(height: 40),
                            const Text(
                              'المس أي مكان للتسبيح',
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('السبحة الإلكترونية'),
              actions: [
                IconButton(
                  tooltip: 'وضع ملء الشاشة',
                  icon: const Icon(Icons.fullscreen),
                  onPressed: () => setState(() => _isFullScreen = true),
                ),
                IconButton(
                  tooltip: store.hapticEnabled
                      ? 'الاهتزاز مفعل'
                      : 'الاهتزاز معطل',
                  icon: Icon(
                    store.hapticEnabled ? Icons.vibration : Icons.mobile_off,
                  ),
                  onPressed: store.toggleHaptic,
                ),
              ],
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // بطاقة اختيار صيغة الذكر
                    Card(
                      child: InkWell(
                        onTap: () => _showPhrasePicker(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              const Icon(Icons.format_quote,
                                  color: brandGreen, size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  store.currentTasbeehPhrase,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down,
                                  color: brandGreen),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // اختيار الهدف
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('الهدف: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('٣٣'),
                          selected: target == 33,
                          onSelected: (_) => store.setTasbeehTarget(33),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('١٠٠'),
                          selected: target == 100,
                          onSelected: (_) => store.setTasbeehTarget(100),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('حر ∞'),
                          selected: target == 0,
                          onSelected: (_) => store.setTasbeehTarget(0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // العداد الدائري وزر التسبيح
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: CircularProgressIndicator(
                            value: target == 0 ? 0.0 : progress,
                            strokeWidth: 9,
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF233630)
                                    : const Color(0xFFE2ECE7),
                            color: brandGreen,
                          ),
                        ),
                        SizedBox(
                          width: 185,
                          height: 185,
                          child: ElevatedButton(
                            onPressed: store.incrementTasbeeh,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: brandGreen,
                              foregroundColor: Colors.white,
                              elevation: 5,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$count',
                                  style: const TextStyle(
                                    fontSize: 46,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'تسبيح',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),

                    // أزرار التحكم
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed:
                              count == 0 ? null : store.resetTasbeeh,
                          icon: const Icon(Icons.refresh),
                          label: const Text('إعادة العداد'),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.tonalIcon(
                          onPressed: () =>
                              setState(() => _isFullScreen = true),
                          icon: const Icon(Icons.fullscreen),
                          label: const Text('شاشة كاملة'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

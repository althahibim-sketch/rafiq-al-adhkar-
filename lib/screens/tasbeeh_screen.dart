import 'package:flutter/material.dart';
import 'package:app_1/core/theme/app_theme.dart';
import 'package:app_1/services/app_store.dart';

class TasbeehScreen extends StatelessWidget {
  final AppStore store;
  const TasbeehScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedBuilder(
        animation: store,
        builder: (context, _) => Scaffold(
          appBar: AppBar(
            title: const Text('السبحة الإلكترونية'),
            actions: [
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
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.fingerprint, size: 64, color: brandGreen),
                  const SizedBox(height: 18),
                  const Text(
                    'سبحان الله',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '${store.tasbeehCount}',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: brandGreen,
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: 190,
                    height: 190,
                    child: ElevatedButton(
                      onPressed: store.incrementTasbeeh,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: brandGreen,
                        foregroundColor: Colors.white,
                        elevation: 5,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.touch_app, size: 42),
                          SizedBox(height: 8),
                          Text(
                            'تسبيح',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  OutlinedButton.icon(
                    onPressed:
                        store.tasbeehCount == 0 ? null : store.resetTasbeeh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة العداد'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

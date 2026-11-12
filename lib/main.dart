import 'package:flutter/material.dart';
import 'package:app_1/core/theme/app_theme.dart';
import 'package:app_1/screens/home_screen.dart';
import 'package:app_1/services/app_store.dart';

export 'package:app_1/core/theme/app_theme.dart';
export 'package:app_1/data/adhkar_data.dart';
export 'package:app_1/models/dhikr_item.dart';
export 'package:app_1/services/app_store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RafiqApp());
}

class RafiqApp extends StatefulWidget {
  const RafiqApp({super.key});

  @override
  State<RafiqApp> createState() => _RafiqAppState();
}

class _RafiqAppState extends State<RafiqApp> {
  final AppStore store = AppStore();

  @override
  void initState() {
    super.initState();
    store.load();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        if (!store.ready) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator(color: brandGreen)),
            ),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'رفيق الأذكار',
          theme: appTheme,
          home: HomePage(store: store),
        );
      },
    );
  }
}

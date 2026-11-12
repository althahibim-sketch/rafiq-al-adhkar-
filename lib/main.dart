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

class _RafiqAppState extends State<RafiqApp> with WidgetsBindingObserver {
  final AppStore store = AppStore();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    store.load();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      store.checkDateRollover();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
            darkTheme: appDarkTheme,
            themeMode: store.themeMode,
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator(color: brandGreen)),
            ),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'رفيق الأذكار',
          theme: appTheme,
          darkTheme: appDarkTheme,
          themeMode: store.themeMode,
          home: HomePage(store: store),
        );
      },
    );
  }
}

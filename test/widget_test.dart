import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_1/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('RafiqApp loads and displays home title and sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RafiqApp());
    await tester.pumpAndSettle();

    expect(find.text('رفيق الأذكار'), findsWidgets);
    expect(find.text('السلام عليكم ورحمة الله'), findsOneWidget);
    expect(find.text('أذكار الصباح'), findsOneWidget);
    expect(find.text('أذكار المساء'), findsOneWidget);
    expect(find.text('السبحة الإلكترونية'), findsOneWidget);
  });

  testWidgets('Tasbeeh screen increments count when button is tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RafiqApp());
    await tester.pumpAndSettle();

    // Ensure Tasbeeh section is visible and tap it
    final tasbeehSection = find.text('السبحة الإلكترونية');
    await tester.ensureVisible(tasbeehSection);
    await tester.pumpAndSettle();
    await tester.tap(tasbeehSection);
    await tester.pumpAndSettle();

    expect(find.text('0'), findsOneWidget);

    // Tap tasbeeh button
    await tester.tap(find.text('تسبيح'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Settings modal can be opened from home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RafiqApp());
    await tester.pumpAndSettle();

    // Tap settings icon in AppBar
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('إعدادات التطبيق'), findsOneWidget);
    expect(find.text('الاهتزاز التفاعلي'), findsOneWidget);
    expect(find.text('حجم خط الأذكار'), findsOneWidget);
  });
}

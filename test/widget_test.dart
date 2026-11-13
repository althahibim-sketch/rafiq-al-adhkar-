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
    expect(find.text('تنبيهات الأذكار اليومية'), findsOneWidget);
  });

  testWidgets('Search button opens search and filters adhkar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RafiqApp());
    await tester.pumpAndSettle();

    // Tap search icon
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    // Enter search query
    await tester.enterText(find.byType(TextField), 'سيد الاستغفار');
    await tester.pumpAndSettle();

    expect(find.text('سيد الاستغفار'), findsWidgets);
  });

  testWidgets('Can add custom dhikr in CustomAdhkarScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RafiqApp());
    await tester.pumpAndSettle();

    // Scroll to Custom Adhkar
    final customSection = find.text('أذكاري الخاصة');
    await tester.ensureVisible(customSection);
    await tester.pumpAndSettle();
    await tester.tap(customSection);
    await tester.pumpAndSettle();

    expect(find.text('لم تضف أي ذكر مخصص بعد'), findsOneWidget);

    // Tap FAB to add
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Fill form
    final titleField = find.byWidgetPredicate((w) =>
        w is TextField && w.decoration?.labelText == 'عنوان الذكر *');
    final textField = find.byWidgetPredicate((w) =>
        w is TextField && w.decoration?.labelText == 'نص الذكر أو الدعاء *');

    await tester.enterText(titleField, 'دعاء خاص');
    await tester.enterText(textField, 'اللهم وفقني لما تحب وترضى');
    await tester.tap(find.text('حفظ الذكر'));
    await tester.pumpAndSettle();

    expect(find.text('دعاء خاص'), findsOneWidget);
  });
}

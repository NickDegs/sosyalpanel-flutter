import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sosyalpanel/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('screenshot_01_dashboard', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await _screenshot(binding, tester, '01_dashboard');
  });

  testWidgets('screenshot_02_composer', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));
    // Composer tab
    final composerTab = find.byIcon(Icons.edit_outlined);
    if (composerTab.evaluate().isNotEmpty) {
      await tester.tap(composerTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }
    await _screenshot(binding, tester, '02_composer');
  });

  testWidgets('screenshot_03_analytics', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final analyticsTab = find.byIcon(Icons.bar_chart_outlined);
    if (analyticsTab.evaluate().isNotEmpty) {
      await tester.tap(analyticsTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }
    await _screenshot(binding, tester, '03_analytics');
  });

  testWidgets('screenshot_04_platforms', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final settingsTab = find.byIcon(Icons.settings_outlined);
    if (settingsTab.evaluate().isNotEmpty) {
      await tester.tap(settingsTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }
    await _screenshot(binding, tester, '04_settings');
  });

  testWidgets('screenshot_05_actions', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final actionsTab = find.byIcon(Icons.bolt_outlined);
    if (actionsTab.evaluate().isNotEmpty) {
      await tester.tap(actionsTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }
    await _screenshot(binding, tester, '05_actions');
  });
}

Future<void> _screenshot(
  IntegrationTestWidgetsFlutterBinding binding,
  WidgetTester tester,
  String name,
) async {
  await binding.convertFlutterSurfaceToImage();
  await tester.pumpAndSettle();
  await binding.takeScreenshot(name);
}

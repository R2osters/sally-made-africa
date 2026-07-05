import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelconnect/main.dart';

/// Boots the app and navigates Home → Mes forfaits → active plan (Sénégal).
Future<void> openActivePlan(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: TravelConnectApp()));
  await tester.pumpAndSettle();

  // Bottom pill-nav tab.
  await tester.tap(find.text('Mes forfaits').last, warnIfMissed: false);
  await tester.pumpAndSettle();

  // First (active) plan card opens /active-plan.
  await tester.tap(find.text('Sénégal'), warnIfMissed: false);
  await tester.pumpAndSettle();

  expect(find.text('Forfait actif'), findsOneWidget);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('install eSIM popup: spinner → success → OK closes dialog',
      (tester) async {
    await openActivePlan(tester);

    // The install button sits below the fold on the 600 px test surface.
    final installBtn = find.text("Installer l'eSIM");
    await tester.dragUntilVisible(
        installBtn, find.byType(ListView).last, const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.tap(installBtn, warnIfMissed: false);

    // Dialog appears with the provisioning spinner.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Installation de votre eSIM…'), findsOneWidget);

    // Mock installer = 600 ms (order) + 1400 ms (install).
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('eSIM installée'), findsOneWidget);

    // OK closes the dialog.
    await tester.tap(find.text('OK'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('eSIM installée'), findsNothing);
    expect(find.text('Installation de votre eSIM…'), findsNothing);
  });

  testWidgets('top-up adds data and days to the usage ring', (tester) async {
    await openActivePlan(tester);

    // Seed: 6 Go total, 2,3 Go used → 3,7 Go left, 5 days.
    expect(find.text('3,7 Go'), findsOneWidget);

    final topupBtn = find.text('Recharger');
    await tester.dragUntilVisible(
        topupBtn, find.byType(ListView).last, const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.tap(topupBtn, warnIfMissed: false);
    await tester.pumpAndSettle();

    // Top-up sheet — pick the 6 Go tier (+7 days).
    await tester.tap(find.text('6 Go').last, warnIfMissed: false);
    await tester.pumpAndSettle();

    // Ring updated: 3,7 + 6 = 9,7 Go left, 5 + 7 = 12 days.
    expect(find.text('9,7 Go'), findsOneWidget);
    expect(find.text('12 jours restants'), findsOneWidget);

    // Confirmation snackbar.
    expect(find.textContaining('Recharge réussie'), findsOneWidget);
  });

  testWidgets('bell badge shows unread count and clears after visiting notifs',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TravelConnectApp()));
    await tester.pumpAndSettle();

    // Mock seed contains 2 unread notifications → badge on the bell.
    expect(find.text('2'), findsOneWidget);

    // Open the notifications screen from the bell.
    await tester.tap(find.byIcon(Icons.notifications_none_rounded).first,
        warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('Forfait activé'), findsOneWidget);

    // Back to home — everything was marked read on open.
    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first,
        warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('2'), findsNothing);
  });
}

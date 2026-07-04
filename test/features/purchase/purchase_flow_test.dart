import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelconnect/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
      'country card → operators sheet → plans sheet → detail → checkout → success',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TravelConnectApp()));
    await tester.pumpAndSettle();

    // Popular-destinations grid (the globe also shows country labels, so
    // target the card inside the GridView explicitly).
    final target =
        find.descendant(of: find.byType(GridView), matching: find.text('Sénégal'));
    await tester.dragUntilVisible(
        target, find.byType(ListView).first, const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.tap(target, warnIfMissed: false);
    await tester.pumpAndSettle();

    // Operators sheet.
    expect(find.text('Choisissez un opérateur'.toUpperCase()), findsOneWidget);
    await tester.tap(find.text('Orange'));
    await tester.pumpAndSettle();

    // Plans sheet — pick the hot 6 Go tier.
    await tester.tap(find.text('6 Go'));
    await tester.pumpAndSettle();

    // Plan detail.
    expect(find.text('Détail du forfait'), findsOneWidget);
    expect(find.text('3 500 FCFA'), findsWidgets);
    await tester.dragUntilVisible(find.text('Acheter ce forfait'),
        find.byType(ListView).last, const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Acheter ce forfait'));
    await tester.pumpAndSettle();

    // Checkout — select Wave, then pay.
    expect(find.text('Paiement'), findsOneWidget);
    await tester.tap(find.text('Wave'));
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(find.textContaining('Payer maintenant'),
        find.byType(ListView).last, const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Payer maintenant'));
    await tester.pumpAndSettle();

    // Success.
    expect(find.text('Forfait activé !'), findsOneWidget);
    await tester.tap(find.text('Voir mes forfaits'));
    await tester.pumpAndSettle();
    expect(find.text('Mes forfaits'), findsWidgets);

    // The purchase landed in My plans (a second Sénégal card on top).
    expect(find.text('Sénégal'), findsNWidgets(2));

    // …and in History (2 seeded 3 500 FCFA + the new one).
    await tester.tap(find.text('Historique').last);
    await tester.pumpAndSettle();
    expect(find.text('3 500 FCFA'), findsNWidgets(3));
  });
}

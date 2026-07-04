import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelconnect/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('sign out leads to welcome, then login and signup (fr)',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TravelConnectApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Se déconnecter'), 200);
    await tester.tap(find.text('Se déconnecter'));
    await tester.pumpAndSettle();

    // Welcome screen.
    expect(find.text('Créer un compte'), findsOneWidget);

    await tester.tap(find.text("J'ai déjà un compte"));
    await tester.pumpAndSettle();
    expect(find.text('Bon retour'), findsOneWidget);

    await tester.tap(find.text("S'inscrire"));
    await tester.pumpAndSettle();
    expect(
        find.text('Rejoignez TravelConnect en 30 secondes.'), findsOneWidget);
  });
}

// test/widget_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelconnect/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('app boots on Explore and switches tabs (fr default)',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: TravelConnectApp()),
    );
    await tester.pumpAndSettle();

    // Home greeting from the showcase profile.
    expect(find.textContaining('Aïssatou'), findsWidgets);

    await tester.tap(find.text('Mes forfaits').last);
    await tester.pumpAndSettle();
    expect(find.text('Mes forfaits'), findsWidgets);

    await tester.tap(find.text('Historique').last);
    await tester.pumpAndSettle();
    expect(find.text('Historique'), findsWidgets);

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    expect(find.text('Profil'), findsWidgets);
  });
}

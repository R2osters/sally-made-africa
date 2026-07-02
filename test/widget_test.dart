import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelconnect/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('app boots on splash then advances to onboarding',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: TravelConnectApp()),
    );
    await tester.pump();

    // Splash tagline visible first.
    expect(find.text('Stay connected, anywhere.'), findsOneWidget);

    // Advance past the 2s splash timer → onboarding.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('Stay connected, anywhere.'), findsNothing);
    expect(find.text('Global Connectivity'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/shared/widgets/app_button.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  testWidgets('fires onPressed when tapped', (tester) async {
    var pressed = false;
    await tester.pumpWidget(_wrap(
      AppButton(label: 'Go', onPressed: () => pressed = true),
    ));
    await tester.tap(find.text('Go'));
    expect(pressed, isTrue);
  });

  testWidgets('loading shows spinner and blocks taps', (tester) async {
    var pressed = false;
    await tester.pumpWidget(_wrap(
      AppButton(label: 'Go', loading: true, onPressed: () => pressed = true),
    ));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Go'), findsNothing);
    await tester.tap(find.byType(AppButton));
    expect(pressed, isFalse);
  });
}

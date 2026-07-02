// test/shared/widgets/shared_widgets_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/theme/app_theme.dart';
import 'package:travelconnect/shared/widgets/pill_button.dart';
import 'package:travelconnect/shared/widgets/step_dots.dart';

Widget _wrap(Widget child) =>
    MaterialApp(theme: AppTheme.light(), home: Scaffold(body: child));

void main() {
  testWidgets('PillButton shows label and fires onPressed', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(
      PillButton(label: 'Get Started', onPressed: () => tapped = true),
    ));
    expect(find.text('Get Started'), findsOneWidget);
    await tester.tap(find.byType(PillButton));
    expect(tapped, isTrue);
  });

  testWidgets('StepDots renders one dot per count', (tester) async {
    await tester.pumpWidget(_wrap(const StepDots(count: 3, activeIndex: 1)));
    expect(find.byType(AnimatedContainer), findsNWidgets(3));
  });
}

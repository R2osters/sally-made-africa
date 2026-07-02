import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/theme/app_theme.dart';
import 'package:travelconnect/features/auth/presentation/signup_screen.dart';
import 'package:travelconnect/shared/widgets/pill_button.dart';

void main() {
  testWidgets('SignupScreen shows title and full name field', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SignupScreen(),
    ));
    expect(find.text('Create Account'), findsWidgets);
    expect(find.text('Full Name'), findsWidgets);
  });

  testWidgets('Create Account is gated by the terms checkbox',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SignupScreen(),
    ));

    final buttonFinder = find.descendant(
      of: find.byType(PillButton),
      matching: find.byType(FilledButton),
    );
    expect(tester.widget<FilledButton>(buttonFinder).onPressed, isNull);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    expect(tester.widget<FilledButton>(buttonFinder).onPressed, isNotNull);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/theme/app_theme.dart';
import 'package:travelconnect/features/auth/presentation/signup_screen.dart';

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
}

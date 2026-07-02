// test/features/purchase/payment_method_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/theme/app_theme.dart';
import 'package:travelconnect/features/purchase/presentation/payment_method_screen.dart';

void main() {
  testWidgets('PaymentMethodScreen shows methods and confirm', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const PaymentMethodScreen(),
    ));
    expect(find.text('Payment Method'), findsWidgets);
    expect(find.text('Confirm Payment'), findsOneWidget);
    expect(find.text('Credit or Debit Card'), findsOneWidget);
  });
}

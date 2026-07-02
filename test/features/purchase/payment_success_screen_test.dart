import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/theme/app_theme.dart';
import 'package:travelconnect/features/purchase/presentation/payment_success_screen.dart';

void main() {
  testWidgets('PaymentSuccessScreen shows success and actions', (tester) async {
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const PaymentSuccessScreen(),
      ),
    ));
    expect(find.text('Purchase Successful!'), findsOneWidget);
    expect(find.text('Go to My Plans'), findsOneWidget);
  });
}

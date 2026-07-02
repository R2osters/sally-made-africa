// test/features/purchase/payment_processing_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:travelconnect/core/theme/app_theme.dart';
import 'package:travelconnect/features/purchase/presentation/payment_processing_screen.dart';

void main() {
  testWidgets('PaymentProcessingScreen shows processing message',
      (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
            path: '/',
            builder: (c, s) => const PaymentProcessingScreen()),
        GoRoute(
            path: '/payment-success',
            builder: (c, s) => const Scaffold(body: SizedBox())),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(
      theme: AppTheme.light(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ));
    await tester.pump();
    expect(find.textContaining('Processing'), findsOneWidget);
    // Drain the pending navigation timer.
    await tester.pump(const Duration(seconds: 3));
  });
}

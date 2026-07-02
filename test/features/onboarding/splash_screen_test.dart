import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:travelconnect/core/theme/app_theme.dart';
import 'package:travelconnect/features/onboarding/presentation/splash_screen.dart';

void main() {
  testWidgets('SplashScreen shows brand name and tagline', (tester) async {
    final router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (c, s) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (c, s) => const Scaffold(body: SizedBox()),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.light(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    ));
    await tester.pump();
    expect(find.text('TravelConnect'), findsOneWidget);
    expect(find.text('Stay connected, anywhere.'), findsOneWidget);
    // Drain the pending 2s timer so the test doesn't fail on a live timer.
    await tester.pump(const Duration(seconds: 3));
  });
}

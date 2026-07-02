import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/router/app_router.dart';
import 'package:travelconnect/core/theme/app_theme.dart';

void main() {
  testWidgets('router starts at /splash', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();

    expect(
      router.routerDelegate.currentConfiguration.uri.toString(),
      '/splash',
    );

    // Drain the splash timer so it doesn't fire after the test ends.
    await tester.pump(const Duration(seconds: 3));
  });
}

// test/shared/widgets/app_scaffold_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:travelconnect/shared/widgets/app_scaffold.dart';

void main() {
  testWidgets('AppScaffold shows 4 nav destinations', (tester) async {
    final router = GoRouter(
      initialLocation: '/a',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) =>
              AppScaffold(navigationShell: shell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(path: '/a', builder: (c, s) => const Text('A')),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(path: '/b', builder: (c, s) => const Text('B')),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(path: '/c', builder: (c, s) => const Text('C')),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(path: '/d', builder: (c, s) => const Text('D')),
            ]),
          ],
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationDestination), findsNWidgets(4));
    expect(find.text('A'), findsOneWidget);
  });
}

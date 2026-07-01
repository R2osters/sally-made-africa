// test/core/router/app_router_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/router/app_router.dart';

void main() {
  testWidgets('router starts at /home', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);

    // go_router only parses its initial route during a real build cycle;
    // currentConfiguration stays empty until the router is pumped into a
    // widget tree. Pump it, then assert the resolved initial location.
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      router.routerDelegate.currentConfiguration.uri.toString(),
      '/home',
    );
  });
}

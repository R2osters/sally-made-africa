// lib/shared/widgets/app_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home), label: l10n.homeTab),
          NavigationDestination(
              icon: const Icon(Icons.sim_card), label: l10n.myPlansTab),
          NavigationDestination(
              icon: const Icon(Icons.receipt_long), label: l10n.historyTab),
          NavigationDestination(icon: const Icon(Icons.person), label: l10n.profileTab),
        ],
      ),
    );
  }
}

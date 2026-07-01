// lib/shared/widgets/app_scaffold.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.sim_card), label: 'My Plans'),
          NavigationDestination(
              icon: Icon(Icons.receipt_long), label: 'History'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

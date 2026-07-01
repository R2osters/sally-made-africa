// lib/features/my_plans/presentation/my_plans_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyPlansScreen extends StatelessWidget {
  const MyPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.myPlansTab)),
      body: Center(child: Text(l10n.myPlansTab)),
    );
  }
}

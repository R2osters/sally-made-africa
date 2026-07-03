// lib/features/home/presentation/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(t.stackMd),
          children: [
            Text('Hello, Alex',
                style: t.headlineLgMobile.copyWith(color: t.primary)),
            SizedBox(height: t.stackMd),
            GestureDetector(
              onTap: () => context.push('/country-select'),
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l10n.searchCountriesHint,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(t.radiusXl),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: t.stackLg),
            Text(l10n.popularDestinations,
                style: t.titleMd.copyWith(color: t.onSurface)),
            SizedBox(height: t.stackSm),
            Wrap(
              spacing: t.gutter,
              runSpacing: t.gutter,
              children: [
                _dest(context, t, 'Japan', 'JP'),
                _dest(context, t, 'United Kingdom', 'GB'),
                _dest(context, t, 'France', 'FR'),
                _dest(context, t, 'Italy', 'IT'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dest(BuildContext context, AppTokens t, String name, String code) {
    return ActionChip(
      label: Text(name, style: t.bodyMd),
      onPressed: () => context.push('/country/$code/plans'),
    );
  }
}

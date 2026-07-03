import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/plan_card.dart';
import '../data/home_mock.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 120),
          children: [
            Text(l10n.homeGreeting,
                style: textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800))
                .animate()
                .fadeIn(duration: 300.ms)
                .moveY(begin: 12, curve: Curves.easeOutCubic),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              decoration: InputDecoration(
                hintText: l10n.homeSearchHint,
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ).animate(delay: 80.ms).fadeIn(duration: 300.ms).moveY(begin: 12),
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.homePopularCountries,
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700))
                .animate(delay: 160.ms)
                .fadeIn(duration: 300.ms),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: mockPopularCountries.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, i) {
                  final c = mockPopularCountries[i];
                  return Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerLow,
                          shape: BoxShape.circle,
                        ),
                        child: Text(c.flagEmoji,
                            style: const TextStyle(fontSize: 30)),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(c.name, style: textTheme.labelSmall),
                    ],
                  )
                      .animate(delay: (200 + 60 * i).ms)
                      .fadeIn(duration: 300.ms)
                      .moveX(begin: 16, curve: Curves.easeOutCubic);
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.homePopularPlans,
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700))
                .animate(delay: 240.ms)
                .fadeIn(duration: 300.ms),
            const SizedBox(height: AppSpacing.md),
            for (var i = 0; i < mockPopularPlans.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: PlanCard(plan: mockPopularPlans[i], onBuy: () {})
                    .animate(delay: (300 + 80 * i).ms)
                    .fadeIn(duration: 300.ms)
                    .moveY(begin: 16, curve: Curves.easeOutCubic),
              ),
          ],
        ),
      ),
    );
  }
}

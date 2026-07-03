// lib/features/my_plans/presentation/my_plans_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../data/my_plans_mock.dart';
import '../domain/purchased_plan.dart';

class MyPlansScreen extends StatelessWidget {
  const MyPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myPlansTab)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 120),
        children: [
          Text(l10n.myPlansActive,
              style: textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.md),
          const _ActivePlanCard(plan: mockActivePlan)
              .animate()
              .fadeIn(duration: 300.ms)
              .moveY(begin: 16, curve: Curves.easeOutCubic),
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.myPlansPast,
              style: textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < mockPastPlans.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _PastPlanTile(plan: mockPastPlans[i])
                  .animate(delay: (100 + 80 * i).ms)
                  .fadeIn(duration: 300.ms)
                  .moveY(begin: 16),
            ),
        ],
      ),
    );
  }
}

class _ActivePlanCard extends StatelessWidget {
  final PurchasedPlan plan;

  const _ActivePlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ratio =
        (plan.usedGigabytes / plan.plan.gigabytes).clamp(0.0, 1.0);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(plan.plan.flagEmoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  '${plan.plan.countryName} · ${plan.plan.operatorName}',
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              Chip(
                label: Text(l10n.myPlansDaysLeft(plan.daysLeft)),
                backgroundColor: scheme.primaryContainer,
                labelStyle: textTheme.labelMedium
                    ?.copyWith(color: scheme.onPrimaryContainer),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: ratio),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: scheme.surfaceContainerHigh,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.myPlansRemaining(
                plan.usedGigabytes.toStringAsFixed(1), plan.plan.gigabytes),
            style: textTheme.bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _PastPlanTile extends StatelessWidget {
  final PurchasedPlan plan;

  const _PastPlanTile({required this.plan});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AppCard(
      child: Row(
        children: [
          Text(plan.plan.flagEmoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              '${plan.plan.countryName} · ${plan.plan.operatorName} · '
              '${plan.plan.gigabytes} GB',
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Text(plan.plan.priceLabel,
              style: textTheme.bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

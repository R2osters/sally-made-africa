// lib/features/my_plans/presentation/my_plans_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/status_chip.dart';
import '../data/my_plans_mock.dart';
import '../domain/purchased_plan.dart';

class MyPlansScreen extends StatelessWidget {
  const MyPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.md,
            AppSpacing.gutter,
            AppSpacing.navClearance,
          ),
          children: [
            Text(l10n.myPlans,
                style: AppTheme.display(size: 30, color: c.text)),
            const SizedBox(height: AppSpacing.xl),
            for (final plan in MyPlansMock.plans) ...[
              _PlanCard(
                plan: plan,
                onTap: plan.status == PlanStatus.active
                    ? () => context.push('/active-plan')
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ]
              .animate(interval: 60.ms)
              .fadeIn(duration: 500.ms, curve: const Cubic(.2, .8, .2, 1))
              .moveY(begin: 8, end: 0, duration: 500.ms),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final PurchasedPlan plan;
  final VoidCallback? onTap;

  const _PlanCard({required this.plan, this.onTap});

  (String, Color) _statusMeta(AppLocalizations l10n) => switch (plan.status) {
        PlanStatus.active => (l10n.active, AppColors.success),
        PlanStatus.expired => (l10n.expired, const Color(0xFFFF7A86)),
        PlanStatus.pending => (l10n.pending, AppColors.warn),
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);
    final (statusLabel, statusColor) = _statusMeta(l10n);
    final expired = plan.status == PlanStatus.expired;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(plan.flagEmoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.countryName,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 1),
                      Text(
                        '${plan.operatorName} · ${plan.dataLabel}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: c.dim),
                      ),
                    ],
                  ),
                ),
                StatusChip(label: statusLabel, color: statusColor),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(
                value: plan.usedPct / 100,
                minHeight: 6,
                backgroundColor: c.surface2,
                valueColor: AlwaysStoppedAnimation(
                  expired ? c.faint : AppColors.accent,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.dataLeft(plan.leftLabel),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: c.dim),
                ),
                Text(
                  expired ? l10n.expired : l10n.daysLeft(plan.daysLeft),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: expired ? c.faint : c.dim),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/flag_image.dart';
import '../../auth/presentation/auth_shell.dart' show BackChip;
import '../../catalog/domain/catalog_models.dart';
import '../../catalog/presentation/catalog_sheets.dart' show OperatorBadge;

class PlanDetailScreen extends StatelessWidget {
  final SelectedPlan plan;

  const PlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          children: [
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                BackChip(
                    onTap: () =>
                        context.canPop() ? context.pop() : context.go('/home')),
                const SizedBox(width: AppSpacing.md),
                Text(l10n.planDetail,
                    style: AppTheme.display(size: 22, color: c.text)),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                OperatorBadge(operator: plan.operator, size: 52),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.operator.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          FlagImage(
                              countryId: plan.country.id,
                              flagEmoji: plan.country.flagEmoji,
                              width: 18),
                          const SizedBox(width: 6),
                          Text(
                            plan.country.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: c.dim),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            // Key figure — data volume, Clash, huge.
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: c.border),
              ),
              child: Column(
                children: [
                  Text(plan.spec.dataLabel,
                      style: AppTheme.display(size: 52, color: c.text)),
                  const SizedBox(height: 4),
                  Text(plan.durationLabel,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: c.dim)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: c.border),
              ),
              child: Column(
                children: [
                  _SpecRow(label: l10n.coverage, value: plan.country.name),
                  Divider(height: 1, color: c.border),
                  _SpecRow(label: l10n.validity, value: plan.durationLabel),
                  Divider(height: 1, color: c.border),
                  _SpecRow(label: l10n.speed, value: '4G / 5G LTE'),
                  Divider(height: 1, color: c.border),
                  _SpecRow(label: 'eSIM', value: l10n.esim),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.total.toUpperCase(),
                    style: AppTheme.sectionLabel(context)),
                Text(
                  plan.priceLabel,
                  style: const TextStyle(
                    fontFamily: AppTheme.textFamily,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: l10n.buy,
              onPressed: () => context.push('/checkout', extra: plan),
            ),
            const SizedBox(height: AppSpacing.xl),
          ]
              .animate(interval: 60.ms)
              .fadeIn(duration: 500.ms, curve: const Cubic(.2, .8, .2, 1))
              .moveY(begin: 8, end: 0, duration: 500.ms),
        ),
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;

  const _SpecRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: c.dim)),
          ),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}

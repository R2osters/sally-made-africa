import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/theme/app_spacing.dart';
import '../../features/home/domain/data_plan.dart';
import 'app_card.dart';

/// Data-plan offer card: flag, operator, volume, validity, price, buy CTA.
class PlanCard extends StatelessWidget {
  final DataPlan plan;
  final VoidCallback? onBuy;

  const PlanCard({super.key, required this.plan, this.onBuy});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Text(plan.flagEmoji, style: const TextStyle(fontSize: 26)),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${plan.countryName} · ${plan.operatorName}',
                    style: textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${l10n.planData(plan.gigabytes)} · '
                  '${l10n.planValidity(plan.validityDays)}',
                  style: textTheme.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(plan.priceLabel,
                  style: textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.xs),
              SizedBox(
                height: 32,
                child: FilledButton.tonal(
                  onPressed: onBuy,
                  style: FilledButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg),
                  ),
                  child: Text(l10n.planBuy),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

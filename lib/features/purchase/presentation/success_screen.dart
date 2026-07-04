import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../catalog/presentation/catalog_sheets.dart' show OperatorBadge;

class SuccessScreen extends StatelessWidget {
  final SelectedPlan plan;

  const SuccessScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.14),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.success.withOpacity(0.4)),
                  ),
                  child: const Icon(Icons.check_rounded,
                      size: 46, color: AppColors.success),
                ),
              ).animate().scale(
                    begin: const Offset(0.7, 0.7),
                    end: const Offset(1, 1),
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.successTitle,
                textAlign: TextAlign.center,
                style: AppTheme.display(size: 30, color: c.text),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.successSub,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: c.dim),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: c.border),
                ),
                child: Row(
                  children: [
                    OperatorBadge(operator: plan.operator),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${plan.spec.dataLabel} · ${plan.durationLabel}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${plan.country.flagEmoji} ${plan.country.name}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: c.dim),
                          ),
                        ],
                      ),
                    ),
                    StatusChip(label: l10n.active, color: AppColors.success),
                  ],
                ),
              ),
              const Spacer(),
              AppButton(
                label: l10n.viewPlans,
                onPressed: () => context.go('/my-plans'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: l10n.backHome,
                variant: AppButtonVariant.ghost,
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../auth/presentation/auth_shell.dart' show BackChip;
import '../../catalog/data/catalog_mock.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../catalog/presentation/catalog_sheets.dart' show OperatorBadge;

class CheckoutScreen extends StatefulWidget {
  final SelectedPlan plan;

  const CheckoutScreen({super.key, required this.plan});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selected = 'momo';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);
    final plan = widget.plan;

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
                Text(l10n.checkout,
                    style: AppTheme.display(size: 22, color: c.text)),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            // Order summary.
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
                          '${plan.operator.name} · ${plan.country.flagEmoji} '
                          '${plan.country.name}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: c.dim),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    plan.priceLabel,
                    style: const TextStyle(
                      fontFamily: AppTheme.textFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.payMethod.toUpperCase(),
                style: AppTheme.sectionLabel(context)),
            const SizedBox(height: AppSpacing.md),
            for (final method in CatalogMock.paymentMethods) ...[
              _PaymentTile(
                method: method,
                selected: _selected == method.id,
                onTap: () => setState(() => _selected = method.id),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            const SizedBox(height: AppSpacing.sm),
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
              label: '${l10n.payNow} · ${plan.priceLabel}',
              onPressed: () =>
                  context.pushReplacement('/success', extra: plan),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_rounded, size: 13, color: c.faint),
                const SizedBox(width: 6),
                Text(l10n.secure,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: c.faint)),
              ],
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

class _PaymentTile extends StatelessWidget {
  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: selected ? c.surface2 : c.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: selected ? AppColors.accent : c.border,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: method.brandColor,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                method.name[0],
                style: TextStyle(
                  fontFamily: AppTheme.textFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: method.onBrandColor,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method.name,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 1),
                  Text(method.tag,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: c.dim)),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.accent : c.border2,
                  width: selected ? 6 : 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

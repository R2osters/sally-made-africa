import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/flag_image.dart';
import '../../../shared/widgets/glass.dart' show liquidBlur;
import '../data/catalog_mock.dart';
import '../domain/catalog_models.dart';

/// "See all" — every served destination, tap → operators sheet.
void showAllDestinationsSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.55),
    builder: (sheetContext) => const _SheetChrome(
      child: _AllDestinationsSheet(),
    ),
  );
}

/// Country → operators sheet → plans sheet → /plan-detail.
void showOperatorsSheet(BuildContext context, Country country) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.55),
    builder: (sheetContext) => _SheetChrome(
      child: _OperatorsSheet(country: country),
    ),
  );
}

void showPlansSheet(BuildContext context, Country country, OperatorInfo op) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.55),
    builder: (sheetContext) => _SheetChrome(
      child: _PlansSheet(country: country, operator: op),
    ),
  );
}

/// Glass sheet chrome: handle, radius 34, dark translucent body.
class _SheetChrome extends StatelessWidget {
  final Widget child;

  const _SheetChrome({required this.child});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      child: BackdropFilter(
        // Spec: floating sheets = blur(40) saturate(200%).
        filter: liquidBlur(40, 2.0),
        child: Container(
          decoration: BoxDecoration(
            // Specular top highlight over the translucent body.
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: const Alignment(0, -0.55),
              colors: isDark
                  ? [const Color(0xD90B1322), const Color(0xEB16233C)]
                  : [c.bg2.withOpacity(0.88), c.bg2],
            ),
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.sheet)),
            border: Border(top: BorderSide(color: c.border2)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: AppSpacing.md),
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: c.border2,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                Flexible(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AllDestinationsSheet extends StatelessWidget {
  const _AllDestinationsSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter, AppSpacing.lg, AppSpacing.gutter, AppSpacing.xl),
      children: [
        Text(l10n.popular.toUpperCase(),
            style: AppTheme.sectionLabel(context)),
        const SizedBox(height: AppSpacing.md),
        for (final country in CatalogMock.countries) ...[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              showOperatorsSheet(context, country);
            },
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: c.border),
              ),
              child: Row(
                children: [
                  FlagImage(
                      countryId: country.id,
                      flagEmoji: country.flagEmoji,
                      width: 40),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(country.name,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(
                          '${l10n.opCount(country.operatorIds.length)} · '
                          '${l10n.fromPrice(CatalogMock.fromPriceLabel(country))}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: c.dim),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: c.faint),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _OperatorsSheet extends StatelessWidget {
  final Country country;

  const _OperatorsSheet({required this.country});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter, AppSpacing.lg, AppSpacing.gutter, AppSpacing.xl),
      children: [
        Row(
          children: [
            FlagImage(
                countryId: country.id,
                flagEmoji: country.flagEmoji,
                width: 48),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(country.name,
                      style: AppTheme.display(size: 24, color: c.text)),
                  const SizedBox(height: 2),
                  Text(
                    '${l10n.opCount(country.operatorIds.length)} · '
                    '${l10n.fromPrice(CatalogMock.fromPriceLabel(country))}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: c.dim),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(l10n.chooseOp.toUpperCase(),
            style: AppTheme.sectionLabel(context)),
        const SizedBox(height: AppSpacing.md),
        for (final op in CatalogMock.operatorsOf(country)) ...[
          _OperatorTile(
            operator: op,
            subtitle:
                l10n.plansFrom(CatalogMock.fromPriceLabel(country)),
            onTap: () {
              Navigator.of(context).pop();
              showPlansSheet(context, country, op);
            },
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _OperatorTile extends StatelessWidget {
  final OperatorInfo operator;
  final String subtitle;
  final VoidCallback onTap;

  const _OperatorTile({
    required this.operator,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            OperatorBadge(operator: operator),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(operator.name,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: c.dim)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: c.faint),
          ],
        ),
      ),
    );
  }
}

/// Brand-coloured operator initial badge.
class OperatorBadge extends StatelessWidget {
  final OperatorInfo operator;
  final double size;

  const OperatorBadge({super.key, required this.operator, this.size = 46});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: operator.brandColor,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Text(
        operator.name[0],
        style: TextStyle(
          fontFamily: AppTheme.textFamily,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w900,
          color: operator.onBrandColor,
        ),
      ),
    );
  }
}

class _PlansSheet extends StatelessWidget {
  final Country country;
  final OperatorInfo operator;

  const _PlansSheet({required this.country, required this.operator});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter, AppSpacing.lg, AppSpacing.gutter, AppSpacing.xl),
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                showOperatorsSheet(context, country);
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: c.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.border),
                ),
                child:
                    Icon(Icons.chevron_left_rounded, color: c.text, size: 22),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            OperatorBadge(operator: operator),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(operator.name,
                      style: AppTheme.display(size: 22, color: c.text)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      FlagImage(
                          countryId: country.id,
                          flagEmoji: country.flagEmoji,
                          width: 18),
                      const SizedBox(width: 6),
                      Text(
                        country.name,
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
        Text(l10n.plansOf.toUpperCase(),
            style: AppTheme.sectionLabel(context)),
        const SizedBox(height: AppSpacing.md),
        for (final spec in CatalogMock.planSpecs) ...[
          _PlanTile(
            country: country,
            operator: operator,
            spec: spec,
            onTap: () {
              final plan = SelectedPlan(
                country: country,
                operator: operator,
                spec: spec,
                priceLabel: CatalogMock.priceLabelFor(country, spec),
                durationLabel: _durationLabel(context, spec),
              );
              Navigator.of(context).pop();
              context.push('/plan-detail', extra: plan);
            },
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

String _durationLabel(BuildContext context, PlanSpec spec) {
  final fr = Localizations.localeOf(context).languageCode == 'fr';
  if (spec.validityDays == 1) return fr ? '24 heures' : '24 hours';
  return fr ? '${spec.validityDays} jours' : '${spec.validityDays} days';
}

class _PlanTile extends StatelessWidget {
  final Country country;
  final OperatorInfo operator;
  final PlanSpec spec;
  final VoidCallback onTap;

  const _PlanTile({
    required this.country,
    required this.operator,
    required this.spec,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: spec.hot ? c.surface2 : c.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: spec.hot
                ? AppColors.accent.withOpacity(0.45)
                : c.border,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Data volume in Clash (key figure), price in cyan (spec).
                  Text(spec.dataLabel,
                      style: AppTheme.display(size: 24, color: c.text)),
                  const SizedBox(height: 2),
                  Text(
                    _durationLabel(context, spec),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: c.dim),
                  ),
                ],
              ),
            ),
            Text(
              CatalogMock.priceLabelFor(country, spec),
              style: const TextStyle(
                fontFamily: AppTheme.textFamily,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

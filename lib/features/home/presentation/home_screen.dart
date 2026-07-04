import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/flag_image.dart';
import '../../../shared/widgets/glass.dart';
import '../../../shared/widgets/globe_view.dart';
import '../../catalog/data/catalog_mock.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../catalog/presentation/catalog_sheets.dart';
import '../../profile/data/profile_mock.dart';

/// Explore — the globe is the hero and the primary navigation: tap a served
/// country (globe label or popular card) to open its operators sheet.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _openCountry(BuildContext context, Country country) {
    showOperatorsSheet(context, country);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);
    final locale = ref.watch(localeProvider);

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
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.greeting,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: c.faint)),
                      Text(
                        '${ProfileMock.firstName} 👋',
                        style: AppTheme.display(size: 30, color: c.text),
                      ),
                    ],
                  ),
                ),
                _RoundIconButton(
                  child: Text(
                    locale.languageCode.toUpperCase(),
                    style: TextStyle(
                      fontFamily: AppTheme.textFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: c.text,
                    ),
                  ),
                  onTap: () => ref.read(localeProvider.notifier).toggle(),
                ),
                const SizedBox(width: AppSpacing.sm),
                _RoundIconButton(
                  child: Icon(Icons.notifications_none_rounded,
                      size: 20, color: c.text),
                  onTap: () => context.push('/notifications'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.homePrompt,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: c.dim),
            ),
            const SizedBox(height: AppSpacing.md),
            // The globe keeps its dark casing in both themes (spec).
            Container(
              height: 340,
              decoration: BoxDecoration(
                color: AppColors.dark.bg,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: c.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  GlobeView(
                    countries: CatalogMock.countries,
                    onCountryTap: (country) => _openCountry(context, country),
                  ),
                  Positioned(
                    bottom: AppSpacing.md,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xB80C1220),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          l10n.globeHint,
                          style: TextStyle(
                            fontFamily: AppTheme.textFamily,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark.dim,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.popular.toUpperCase(),
                    style: AppTheme.sectionLabel(context)),
                Text(
                  l10n.seeAll,
                  style: const TextStyle(
                    fontFamily: AppTheme.textFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.12,
              children: [
                for (final country in CatalogMock.countries.take(6))
                  _CountryCard(
                    country: country,
                    onTap: () => _openCountry(context, country),
                  ),
              ],
            ),
          ]
              .animate(interval: 60.ms)
              .fadeIn(duration: 500.ms, curve: const Cubic(.2, .8, .2, 1))
              .moveY(begin: 8, end: 0, duration: 500.ms),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _RoundIconButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: c.surface,
          shape: BoxShape.circle,
          border: Border.all(color: c.border),
        ),
        child: child,
      ),
    );
  }
}

class _CountryCard extends StatelessWidget {
  final Country country;
  final VoidCallback onTap;

  const _CountryCard({required this.country, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);
    return GlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlagImage(
              countryId: country.id, flagEmoji: country.flagEmoji, width: 38),
          const SizedBox(height: AppSpacing.sm),
          Text(
            country.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 2),
          Text(
            '${l10n.opCount(country.operatorIds.length)} · '
            '${l10n.fromPrice(CatalogMock.fromPriceLabel(country))}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: c.dim, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

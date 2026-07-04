import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/globe_view.dart';
import '../../catalog/data/catalog_mock.dart';

/// Welcome — starlit globe hero, badge, display-XL title, three actions.
/// Auth is still UI-only: every path leads to /home.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      // The globe keeps its dark casing in both themes (spec).
      backgroundColor: AppColors.dark.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: _LangPill(
                  label: locale.languageCode.toUpperCase(),
                  onTap: () => ref.read(localeProvider.notifier).toggle(),
                ),
              ),
              const Expanded(
                child: GlobeView(
                  countries: CatalogMock.countries,
                  showLabels: false,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        l10n.welcomeBadge,
                        style: const TextStyle(
                          fontFamily: AppTheme.textFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.96,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.welcomeTitle,
                style: AppTheme.display(
                    size: 38, height: 1.02, color: AppColors.dark.text),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.welcomeSub,
                style: TextStyle(
                  fontFamily: AppTheme.textFamily,
                  fontSize: 15,
                  height: 1.5,
                  color: AppColors.dark.dim,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                label: l10n.createAccount,
                onPressed: () => context.go('/auth/signup'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: l10n.haveAccount,
                variant: AppButtonVariant.secondary,
                onPressed: () => context.go('/auth/login'),
              ),
              const SizedBox(height: AppSpacing.xs),
              AppButton(
                label: '${l10n.continueGuest} →',
                variant: AppButtonVariant.ghost,
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: AppSpacing.md),
            ]
                .animate(interval: 60.ms)
                .fadeIn(duration: 500.ms, curve: const Cubic(.2, .8, .2, 1))
                .moveY(begin: 8, end: 0, duration: 500.ms),
          ),
        ),
      ),
    );
  }
}

class _LangPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _LangPill({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.dark.surface2,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColors.dark.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language_rounded, size: 15, color: AppColors.dark.dim),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTheme.textFamily,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.dark.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

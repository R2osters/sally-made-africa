import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(AppRadius.lg + 4),
                ),
                child: Icon(Icons.travel_explore_rounded,
                    size: 44, color: scheme.onPrimary),
              )
                  .animate()
                  .scale(
                      begin: const Offset(0.8, 0.8),
                      duration: 400.ms,
                      curve: Curves.easeOutBack)
                  .fadeIn(duration: 300.ms),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.appTitle,
                  style: textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w800))
                  .animate(delay: 100.ms)
                  .fadeIn(duration: 300.ms),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.authTagline,
                  style: textTheme.bodyMedium
                      ?.copyWith(color: scheme.onSurfaceVariant),
                  textAlign: TextAlign.center)
                  .animate(delay: 180.ms)
                  .fadeIn(duration: 300.ms),
              const Spacer(),
              for (final (i, item) in <({String label, IconData icon, VoidCallback onTap, AppButtonVariant variant})>[
                (
                  label: l10n.authContinueEmail,
                  icon: Icons.mail_outline_rounded,
                  onTap: () => context.go('/auth/login'),
                  variant: AppButtonVariant.primary
                ),
                (
                  label: l10n.authContinuePhone,
                  icon: Icons.phone_iphone_rounded,
                  onTap: () => context.go('/auth/signup'),
                  variant: AppButtonVariant.secondary
                ),
                (
                  label: l10n.authContinueGoogle,
                  icon: Icons.g_mobiledata_rounded,
                  onTap: () => context.go('/home'),
                  variant: AppButtonVariant.secondary
                ),
                (
                  label: l10n.authContinueApple,
                  icon: Icons.apple_rounded,
                  onTap: () => context.go('/home'),
                  variant: AppButtonVariant.secondary
                ),
              ].indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: item.label,
                      icon: Icon(item.icon, size: 20),
                      variant: item.variant,
                      onPressed: item.onTap,
                    ),
                  )
                      .animate(delay: (250 + 70 * i).ms)
                      .fadeIn(duration: 300.ms)
                      .moveY(begin: 16, curve: Curves.easeOutCubic),
                ),
              AppButton(
                label: l10n.authContinueGuest,
                variant: AppButtonVariant.ghost,
                onPressed: () => context.go('/home'),
              ).animate(delay: 550.ms).fadeIn(duration: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}

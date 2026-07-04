import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';

/// Shared scaffold for the auth flow: back chip, Clash title, Satoshi
/// subtitle, then the form. Lives outside the tab shell.
class AuthShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const AuthShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerLeft,
                child: BackChip(
                  onTap: () => context.canPop()
                      ? context.pop()
                      : context.go('/auth'),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(title,
                  style: AppTheme.display(size: 32, color: c.text)),
              const SizedBox(height: AppSpacing.sm),
              Text(subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: c.dim)),
              const SizedBox(height: AppSpacing.xxl),
              ...children,
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class BackChip extends StatelessWidget {
  final VoidCallback onTap;

  const BackChip({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: c.surface,
          shape: BoxShape.circle,
          border: Border.all(color: c.border),
        ),
        child: Icon(Icons.chevron_left_rounded, color: c.text, size: 24),
      ),
    );
  }
}

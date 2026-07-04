import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_provider.dart';
import '../data/profile_mock.dart';
import '../data/user_profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // UI-only toggles until the Notifications/Auth sub-projects land.
  bool _notifications = true;
  bool _biometric = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final profile = ref.watch(userProfileProvider);
    final isDark = switch (themeMode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system =>
        MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };

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
            Text(l10n.profile,
                style: AppTheme.display(size: 30, color: c.text)),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    profile.initials,
                    style: const TextStyle(
                      fontFamily: AppTheme.textFamily,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 2),
                      Text(profile.email,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: c.dim)),
                    ],
                  ),
                ),
                Text(
                  l10n.edit,
                  style: const TextStyle(
                    fontFamily: AppTheme.textFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Group(
              label: l10n.account,
              children: [
                _InfoRow(label: l10n.email, value: profile.email),
                _InfoRow(label: l10n.phoneLbl, value: ProfileMock.phone),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _Group(
              label: l10n.settings,
              children: [
                _ActionRow(
                  icon: Icons.language_rounded,
                  label: l10n.language,
                  trailing: Text(
                    locale.languageCode.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: AppTheme.textFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                  onTap: () => ref.read(localeProvider.notifier).toggle(),
                ),
                _SwitchRow(
                  icon: Icons.dark_mode_rounded,
                  label: l10n.darkMode,
                  value: isDark,
                  onChanged: (v) => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
                ),
                _SwitchRow(
                  icon: Icons.notifications_none_rounded,
                  label: l10n.notifications,
                  value: _notifications,
                  onChanged: (v) => setState(() => _notifications = v),
                ),
                _SwitchRow(
                  icon: Icons.fingerprint_rounded,
                  label: l10n.biometric,
                  value: _biometric,
                  onChanged: (v) => setState(() => _biometric = v),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _Group(
              label: l10n.support,
              children: [
                _ActionRow(
                  icon: Icons.help_outline_rounded,
                  label: l10n.helpCenter,
                  onTap: () {},
                ),
                _ActionRow(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: l10n.contactUs,
                  onTap: () {},
                ),
                _ActionRow(
                  icon: Icons.description_outlined,
                  label: l10n.terms,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _Group(
              children: [
                _ActionRow(
                  icon: Icons.logout_rounded,
                  label: l10n.signOut,
                  labelColor: AppColors.danger,
                  onTap: () => context.go('/auth'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: Text(
                'TravelConnect · v1.0 · '
                '${l10n.memberSince(ProfileMock.sinceYear)}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: c.faint),
              ),
            ),
          ]
              .animate(interval: 50.ms)
              .fadeIn(duration: 450.ms, curve: const Cubic(.2, .8, .2, 1))
              .moveY(begin: 8, end: 0, duration: 450.ms),
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  final String? label;
  final List<Widget> children;

  const _Group({this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!.toUpperCase(), style: AppTheme.sectionLabel(context)),
          const SizedBox(height: AppSpacing.md),
        ],
        Container(
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: c.border),
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) Divider(height: 1, color: c.border),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
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

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? labelColor;
  final Widget? trailing;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.label,
    this.labelColor,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Icon(icon, size: 20, color: labelColor ?? c.dim),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: labelColor),
              ),
            ),
            trailing ?? Icon(Icons.chevron_right_rounded, color: c.faint),
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: c.dim),
          const SizedBox(width: AppSpacing.md),
          Expanded(
              child:
                  Text(label, style: Theme.of(context).textTheme.titleSmall)),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/auth_shell.dart' show BackChip;
import '../data/notifications_mock.dart';
import '../domain/app_notification.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);
    final fr = Localizations.localeOf(context).languageCode == 'fr';

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
                Text(l10n.notifications,
                    style: AppTheme.display(size: 22, color: c.text)),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            for (final n in NotificationsMock.items) ...[
              _NotificationTile(notification: n, fr: fr),
              const SizedBox(height: AppSpacing.md),
            ],
          ]
              .animate(interval: 60.ms)
              .fadeIn(duration: 500.ms, curve: const Cubic(.2, .8, .2, 1))
              .moveY(begin: 8, end: 0, duration: 500.ms),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final bool fr;

  const _NotificationTile({required this.notification, required this.fr});

  (IconData, Color) get _iconMeta => switch (notification.kind) {
        NotificationKind.success =>
          (Icons.check_rounded, AppColors.success),
        NotificationKind.warning =>
          (Icons.warning_amber_rounded, AppColors.warn),
        NotificationKind.payment =>
          (Icons.credit_card_rounded, AppColors.accent),
        NotificationKind.info =>
          (Icons.notifications_none_rounded, const Color(0xFF7F9BFF)),
      };

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final (icon, color) = _iconMeta;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: notification.unread ? c.surface2 : c.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: c.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        fr ? notification.titleFr : notification.titleEn,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    if (notification.unread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  fr ? notification.bodyFr : notification.bodyEn,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: c.dim),
                ),
                const SizedBox(height: 5),
                Text(
                  fr ? notification.timeFr : notification.timeEn,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: c.faint, fontSize: 11.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

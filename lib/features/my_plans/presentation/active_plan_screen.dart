import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../auth/presentation/auth_shell.dart' show BackChip;
import '../../catalog/data/catalog_mock.dart';
import '../../esim/esim_provider.dart';
import '../../notifications/data/notifications_provider.dart';
import '../../notifications/domain/app_notification.dart';
import '../data/active_plan_provider.dart';

/// Active plan — live usage ring, mock-eSIM install popup (2 s), working
/// top-up. Real LPA provisioning arrives with the eSIM backend
/// (docs/esim-native-integration.md).
class ActivePlanScreen extends ConsumerWidget {
  const ActivePlanScreen({super.key});

  Future<void> _installEsim(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final installer = ref.read(esimInstallerProvider);
    final notifications = ref.read(notificationsProvider.notifier);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _InstallDialog(future: () async {
        final lpa = await installer.order(
            planId: 'sn-orange-active', userId: 'showcase');
        await installer.install(lpa);
      }()),
    );

    notifications.push(AppNotification(
      kind: NotificationKind.success,
      titleFr: 'eSIM installée',
      titleEn: 'eSIM installed',
      bodyFr:
          'Votre eSIM Orange (Sénégal) est active sur cet appareil.',
      bodyEn: 'Your Orange eSIM (Senegal) is active on this device.',
      timeFr: l10n.justNow,
      timeEn: l10n.justNow,
      unread: true,
    ));
  }

  void _openTopUp(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(activePlanProvider.notifier);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (sheetContext) {
        final isDark = Theme.of(sheetContext).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xF20B1322) : c.bg2,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.sheet)),
            border: Border(top: BorderSide(color: c.border2)),
          ),
          child: SafeArea(
            top: false,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(AppSpacing.gutter,
                  AppSpacing.md, AppSpacing.gutter, AppSpacing.xl),
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: c.border2,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.topup.toUpperCase(),
                    style: AppTheme.sectionLabel(sheetContext)),
                const SizedBox(height: AppSpacing.md),
                for (final spec in CatalogMock.planSpecs) ...[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      _confirmTopUp(context, ref, notifier, spec.tier);
                    },
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
                                Text(spec.dataLabel,
                                    style: AppTheme.display(
                                        size: 22, color: c.text)),
                                const SizedBox(height: 2),
                                Text(
                                  '+${spec.validityDays} j',
                                  style: Theme.of(sheetContext)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: c.dim),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            notifier.priceLabelFor(spec),
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
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmTopUp(BuildContext context, WidgetRef ref,
      ActivePlanNotifier notifier, int tier) {
    final l10n = AppLocalizations.of(context)!;
    final spec = CatalogMock.planSpecs[tier];
    notifier.topUp(spec);
    ref.read(notificationsProvider.notifier).push(AppNotification(
          kind: NotificationKind.payment,
          titleFr: 'Recharge réussie',
          titleEn: 'Top-up successful',
          bodyFr:
              '${spec.dataLabel} ajoutés à votre forfait Sénégal (Orange) — '
              '${notifier.priceLabelFor(spec)}.',
          bodyEn:
              '${spec.dataLabel} added to your Senegal plan (Orange) — '
              '${notifier.priceLabelFor(spec)}.',
          timeFr: l10n.justNow,
          timeEn: l10n.justNow,
          unread: true,
        ));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.success,
      content: Text(
        '${l10n.topupSuccess} · +${spec.dataLabel}',
        style: const TextStyle(
          fontFamily: AppTheme.textFamily,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);
    final plan = ref.watch(activePlanProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          children: [
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                BackChip(
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go('/my-plans')),
                const SizedBox(width: AppSpacing.md),
                Text(l10n.planActiveTitle,
                    style: AppTheme.display(size: 22, color: c.text)),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: c.border),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(170, 170),
                          painter: _UsageRingPainter(
                            pct: plan.leftPct / 100,
                            trackColor: c.surface2,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              plan.leftLabel,
                              style:
                                  AppTheme.display(size: 32, color: c.text),
                            ),
                            Text(
                              '/ ${plan.totalLabel}',
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
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '${ActivePlanNotifier.country} · '
                    '${ActivePlanNotifier.operator}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StatusChip(label: l10n.active, color: AppColors.success),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        l10n.daysLeft(plan.daysLeft),
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
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: c.border),
              ),
              child: Column(
                children: [
                  Text(l10n.scanQr.toUpperCase(),
                      style: AppTheme.sectionLabel(context)),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.input),
                    ),
                    child: const CustomPaint(
                      size: Size(150, 150),
                      painter: _FakeQrPainter(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: l10n.installEsim,
              onPressed: () => _installEsim(context, ref),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: l10n.topup,
              variant: AppButtonVariant.secondary,
              onPressed: () => _openTopUp(context, ref),
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

/// Install popup: spinner while provisioning (mock: ~2 s), then success.
class _InstallDialog extends StatelessWidget {
  final Future<void> future;

  const _InstallDialog({required this.future});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xF20B1322) : c.bg2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: c.border2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: FutureBuilder<void>(
          future: future,
          builder: (context, snapshot) {
            final done = snapshot.connectionState == ConnectionState.done;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!done) ...[
                  const SizedBox(
                    width: 54,
                    height: 54,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.5,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    l10n.installingEsim,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ] else ...[
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.14),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.success.withOpacity(0.4)),
                    ),
                    child: const Icon(Icons.check_rounded,
                        size: 34, color: AppColors.success),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.esimInstalled,
                    style: AppTheme.display(size: 22, color: c.text),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.esimInstalledBody,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: c.dim),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: l10n.ok,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Conic-gradient usage ring (accent → track).
class _UsageRingPainter extends CustomPainter {
  final double pct;
  final Color trackColor;

  const _UsageRingPainter({required this.pct, required this.trackColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const stroke = 13.0;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = trackColor,
    );

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * pct,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..shader = const SweepGradient(
          startAngle: -math.pi / 2,
          endAngle: 3 * math.pi / 2,
          colors: [AppColors.accent, AppColors.primary],
          transform: GradientRotation(-math.pi / 2),
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_UsageRingPainter old) =>
      old.pct != pct || old.trackColor != trackColor;
}

/// Deterministic fake QR — same finder-pattern algorithm as the prototype.
class _FakeQrPainter extends CustomPainter {
  const _FakeQrPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const n = 21;
    final cell = size.width / n;
    final paint = Paint()..color = const Color(0xFF0A1224);

    bool? finder(int ox, int oy, int x, int y) {
      final dx = x - ox, dy = y - oy;
      if (dx < 0 || dy < 0 || dx > 6 || dy > 6) return null;
      final edge = dx == 0 || dx == 6 || dy == 0 || dy == 6;
      final inner = dx >= 2 && dx <= 4 && dy >= 2 && dy <= 4;
      return edge || inner;
    }

    var seed = 97;
    double rnd() {
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      return seed / 0x7fffffff;
    }

    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        var f = finder(0, 0, x, y);
        f ??= finder(n - 7, 0, x, y);
        f ??= finder(0, n - 7, x, y);
        bool on;
        if (f != null) {
          on = f;
        } else if ((x < 8 && y < 8) ||
            (x > n - 9 && y < 8) ||
            (x < 8 && y > n - 9)) {
          on = false;
        } else {
          on = rnd() > 0.52;
        }
        if (on) {
          canvas.drawRect(
            Rect.fromLTWH(x * cell, y * cell, cell, cell),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_FakeQrPainter old) => false;
}

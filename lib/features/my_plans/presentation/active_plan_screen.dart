import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../auth/presentation/auth_shell.dart' show BackChip;
import '../data/my_plans_mock.dart';

/// Active plan — conic usage ring, fake QR (real LPA arrives with the
/// Purchase/eSIM sub-project), install/top-up actions.
class ActivePlanScreen extends StatelessWidget {
  const ActivePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);

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
                            pct: MyPlansMock.activeRingPct / 100,
                            trackColor: c.surface2,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              MyPlansMock.activeUsedLabel,
                              style:
                                  AppTheme.display(size: 32, color: c.text),
                            ),
                            Text(
                              '/ ${MyPlansMock.activeTotalLabel}',
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
                    '${MyPlansMock.activeCountry} · ${MyPlansMock.activeOperator}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StatusChip(label: l10n.active, color: AppColors.success),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        l10n.daysLeft(MyPlansMock.activeDaysLeft),
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
            AppButton(label: l10n.installEsim, onPressed: () {}),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: l10n.topup,
              variant: AppButtonVariant.secondary,
              onPressed: () {},
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

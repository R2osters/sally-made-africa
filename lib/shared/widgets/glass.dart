import 'dart:io' show Platform;
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Liquid-glass backdrop: blur + saturation boost (spec: nav blur(26)
/// saturate(150%), sheets blur(40) saturate(200%)).
ImageFilter liquidBlur(double sigma, double saturation) {
  final s = saturation;
  const lr = 0.2126, lg = 0.7152, lb = 0.0722;
  return ImageFilter.compose(
    outer: ColorFilter.matrix([
      lr + (1 - lr) * s, lg * (1 - s), lb * (1 - s), 0, 0,
      lr * (1 - s), lg + (1 - lg) * s, lb * (1 - s), 0, 0,
      lr * (1 - s), lg * (1 - s), lb + (1 - lb) * s, 0, 0,
      0, 0, 0, 1, 0,
    ]),
    inner: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
  );
}

/// Slow vertical levitation (spec: 6 s float), used on the welcome globe.
/// Static under FLUTTER_TEST so pumpAndSettle terminates.
class Levitate extends StatefulWidget {
  final Widget child;
  final double amplitude;

  const Levitate({super.key, required this.child, this.amplitude = 9});

  @override
  State<Levitate> createState() => _LevitateState();
}

class _LevitateState extends State<Levitate>
    with SingleTickerProviderStateMixin {
  static final bool _isTestEnv =
      !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');

  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(seconds: 6));
    if (!_isTestEnv) _c.repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) => Transform.translate(
        offset:
            Offset(0, -widget.amplitude * math.sin(_c.value * 2 * math.pi)),
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// Frosted-glass surface: translucent fill, hairline border, backdrop blur.
/// Blur is opt-out (`frosted: false`) for cheap surfaces stacked in lists —
/// per spec only major surfaces (nav, sheets, foreground cards) blur.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double radius;
  final double blur;
  final bool frosted;
  final Color? color;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.radius = AppRadius.card,
    this.blur = 14,
    this.frosted = false,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final borderRadius = BorderRadius.circular(radius);

    Widget content = Container(
      decoration: BoxDecoration(
        color: color ?? c.surface,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor ?? c.border),
      ),
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: child,
    );

    if (frosted) {
      content = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: content,
        ),
      );
    }

    if (onTap == null) return content;
    return _PressScale(onTap: onTap!, child: content);
  }
}

/// Spec press feedback: scale(.96), 120 ms.
class _PressScale extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const _PressScale({required this.onTap, required this.child});

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Modal bottom sheet in the liquid-glass style: handle, radius 34,
/// blur(40), specular top highlight, rises with the spec curve.
Future<T?> showGlassSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.55),
    builder: (context) => GlassSheetBody(child: Builder(builder: builder)),
  );
}

class GlassSheetBody extends StatelessWidget {
  final Widget child;

  const GlassSheetBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xE60B1322) : c.bg2.withOpacity(0.92),
            border: Border(top: BorderSide(color: c.border2)),
            // Specular top highlight.
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: const Alignment(0, -0.6),
              colors: [
                isDark ? const Color(0xE60B1322) : c.bg2.withOpacity(0.92),
                isDark ? const Color(0xF0142036) : c.bg2,
              ],
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
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

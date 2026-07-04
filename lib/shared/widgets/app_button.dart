import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, ghost }

/// Liquid-glass button. Primary = the one allowed gradient + accent glow;
/// secondary = glass fill + border; ghost = text only. Press-scale(.96).
class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final Widget? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.icon,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final onPressed = widget.loading ? null : widget.onPressed;
    final isPrimary = widget.variant == AppButtonVariant.primary;
    final spinner = SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: isPrimary ? Colors.white : AppColors.primary,
      ),
    );
    final content = widget.loading
        ? spinner
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(widget.label),
            ],
          );

    Widget button = switch (widget.variant) {
      AppButtonVariant.primary => DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppRadius.button),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.7),
                blurRadius: 34,
                spreadRadius: -10,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
            ),
            child: content,
          ),
        ),
      AppButtonVariant.secondary =>
        OutlinedButton(onPressed: onPressed, child: content),
      AppButtonVariant.ghost =>
        TextButton(onPressed: onPressed, child: content),
    };

    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed && onPressed != null ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: button,
      ),
    );
  }
}

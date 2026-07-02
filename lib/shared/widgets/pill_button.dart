// lib/shared/widgets/pill_button.dart
import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;
  final bool filled;

  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailingIcon,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final bg = filled ? t.primaryContainer : Colors.transparent;
    final fg = filled ? t.onPrimaryContainer : t.primary;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          side: filled ? null : BorderSide(color: t.outline, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(t.radiusXl),
          ),
          textStyle: t.titleMd,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              Icon(trailingIcon, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}

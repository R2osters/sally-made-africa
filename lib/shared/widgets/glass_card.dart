// lib/shared/widgets/glass_card.dart
import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const GlassCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      padding: padding ?? EdgeInsets.all(t.stackMd),
      decoration: BoxDecoration(
        color: t.surfaceContainerLowest.withOpacity(0.8),
        borderRadius: BorderRadius.circular(t.radiusXl),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

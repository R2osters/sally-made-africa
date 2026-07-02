// lib/shared/widgets/gradient_background.dart
import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.7, -0.7),
          radius: 1.2,
          colors: [t.secondaryContainer, t.surface, t.primaryFixed],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}

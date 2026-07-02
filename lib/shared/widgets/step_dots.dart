// lib/shared/widgets/step_dots.dart
import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

class StepDots extends StatelessWidget {
  final int count;
  final int activeIndex;

  const StepDots({super.key, required this.count, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? t.primary : t.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(t.radiusFull),
          ),
        );
      }),
    );
  }
}

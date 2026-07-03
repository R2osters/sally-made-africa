import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

/// Themed text input: label above the field, inline error, optional icon.
class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? errorText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.errorText,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            errorText: errorText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

/// Liquid-glass palette. Two real themes (dark is primary); surfaces are
/// translucent stacks — white over deep space in dark, night-blue over soft
/// grey-blue in light. Accent and semantics are shared.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.bg2,
    required this.surface,
    required this.surface2,
    required this.border,
    required this.border2,
    required this.text,
    required this.dim,
    required this.faint,
  });

  final Color bg;
  final Color bg2;
  final Color surface;
  final Color surface2;
  final Color border;
  final Color border2;
  final Color text;
  final Color dim;
  final Color faint;

  // Shared accent & semantics (identical in both themes).
  static const Color primary = Color(0xFF2F80FF);
  static const Color accent = Color(0xFF37E0FF);
  static const Color success = Color(0xFF2FD98A);
  static const Color warn = Color(0xFFFFB23E);
  static const Color danger = Color(0xFFFF5C6C);

  /// The only gradient allowed — primary CTAs.
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B8BFF), Color(0xFF2F6BFF)],
  );

  static const AppColors dark = AppColors(
    bg: Color(0xFF05070F),
    bg2: Color(0xFF0A1120),
    surface: Color(0x0BFFFFFF), // white 4.5%
    surface2: Color(0x12FFFFFF), // white 7%
    border: Color(0x17FFFFFF), // white 9%
    border2: Color(0x29FFFFFF), // white 16%
    text: Color(0xFFEAF0FB),
    dim: Color(0xFF95A1B8),
    faint: Color(0xFF5C6479),
  );

  static const AppColors light = AppColors(
    bg: Color(0xFFEEF2F9),
    bg2: Color(0xFFFFFFFF),
    surface: Color(0x0A0C162D), // night-blue 4%
    surface2: Color(0x0F0C162D), // night-blue 6%
    border: Color(0x170C162D), // night-blue 9%
    border2: Color(0x240C162D), // night-blue 14%
    text: Color(0xFF0B1220),
    dim: Color(0xFF586378),
    faint: Color(0xFF8B95A8),
  );

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors copyWith({
    Color? bg,
    Color? bg2,
    Color? surface,
    Color? surface2,
    Color? border,
    Color? border2,
    Color? text,
    Color? dim,
    Color? faint,
  }) {
    return AppColors(
      bg: bg ?? this.bg,
      bg2: bg2 ?? this.bg2,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      border: border ?? this.border,
      border2: border2 ?? this.border2,
      text: text ?? this.text,
      dim: dim ?? this.dim,
      faint: faint ?? this.faint,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      bg2: Color.lerp(bg2, other.bg2, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      border: Color.lerp(border, other.border, t)!,
      border2: Color.lerp(border2, other.border2, t)!,
      text: Color.lerp(text, other.text, t)!,
      dim: Color.lerp(dim, other.dim, t)!,
      faint: Color.lerp(faint, other.faint, t)!,
    );
  }
}

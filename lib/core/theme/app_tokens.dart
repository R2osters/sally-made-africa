import 'package:flutter/material.dart';

@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  // Colors
  final Color primary;
  final Color primaryContainer;
  final Color onPrimary;
  final Color onPrimaryContainer;
  final Color primaryFixed;
  final Color primaryFixedDim;
  final Color secondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color tertiaryContainer;
  final Color tertiaryFixed;
  final Color error;
  final Color errorContainer;
  final Color surface;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color background;
  final Color onBackground;

  // Spacing
  final double base;
  final double stackSm;
  final double gutter;
  final double stackMd;
  final double stackLg;

  // Radii
  final double radiusLg;
  final double radiusXl;
  final double radiusFull;

  // Text styles
  final TextStyle labelSm;
  final TextStyle bodyMd;
  final TextStyle bodyLg;
  final TextStyle titleMd;
  final TextStyle headlineLgMobile;
  final TextStyle headlineLg;
  final TextStyle displayLg;

  const AppTokens({
    required this.primary,
    required this.primaryContainer,
    required this.onPrimary,
    required this.onPrimaryContainer,
    required this.primaryFixed,
    required this.primaryFixedDim,
    required this.secondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.tertiaryContainer,
    required this.tertiaryFixed,
    required this.error,
    required this.errorContainer,
    required this.surface,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.background,
    required this.onBackground,
    required this.base,
    required this.stackSm,
    required this.gutter,
    required this.stackMd,
    required this.stackLg,
    required this.radiusLg,
    required this.radiusXl,
    required this.radiusFull,
    required this.labelSm,
    required this.bodyMd,
    required this.bodyLg,
    required this.titleMd,
    required this.headlineLgMobile,
    required this.headlineLg,
    required this.displayLg,
  });

  static const String _fontFamily = 'Inter';

  static const _labelSm = TextStyle(
      fontFamily: _fontFamily, fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w600);
  static const _bodyMd = TextStyle(
      fontFamily: _fontFamily, fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w400);
  static const _bodyLg = TextStyle(
      fontFamily: _fontFamily, fontSize: 16, height: 24 / 16, fontWeight: FontWeight.w400);
  static const _titleMd = TextStyle(
      fontFamily: _fontFamily, fontSize: 20, height: 28 / 20, fontWeight: FontWeight.w600);
  static const _headlineLgMobile = TextStyle(
      fontFamily: _fontFamily, fontSize: 24, height: 32 / 24, fontWeight: FontWeight.w600);
  static const _headlineLg = TextStyle(
      fontFamily: _fontFamily,
      fontSize: 32,
      height: 40 / 32,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.64);
  static const _displayLg = TextStyle(
      fontFamily: _fontFamily,
      fontSize: 40,
      height: 48 / 40,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.8);

  static const AppTokens light = AppTokens(
    primary: Color(0xFF004AC6),
    primaryContainer: Color(0xFF2563EB),
    onPrimary: Color(0xFFFFFFFF),
    onPrimaryContainer: Color(0xFFEEEFFF),
    primaryFixed: Color(0xFFDBE1FF),
    primaryFixedDim: Color(0xFFB4C5FF),
    secondary: Color(0xFF565E74),
    secondaryContainer: Color(0xFFDAE2FD),
    onSecondaryContainer: Color(0xFF5C647A),
    tertiary: Color(0xFF006242),
    tertiaryContainer: Color(0xFF007D55),
    tertiaryFixed: Color(0xFF6FFBBE),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFFF7F9FB),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF2F4F6),
    surfaceContainer: Color(0xFFECEEF0),
    surfaceContainerHigh: Color(0xFFE6E8EA),
    surfaceContainerHighest: Color(0xFFE0E3E5),
    onSurface: Color(0xFF191C1E),
    onSurfaceVariant: Color(0xFF434655),
    outline: Color(0xFF737686),
    outlineVariant: Color(0xFFC3C6D7),
    background: Color(0xFFF7F9FB),
    onBackground: Color(0xFF191C1E),
    base: 8,
    stackSm: 12,
    gutter: 16,
    stackMd: 24,
    stackLg: 40,
    radiusLg: 8,
    radiusXl: 12,
    radiusFull: 9999,
    labelSm: _labelSm,
    bodyMd: _bodyMd,
    bodyLg: _bodyLg,
    titleMd: _titleMd,
    headlineLgMobile: _headlineLgMobile,
    headlineLg: _headlineLg,
    displayLg: _displayLg,
  );

  // Dark: reuse the same brand hues on a dark surface ramp. Kept simple —
  // real dark tuning is out of scope; this just prevents a null extension.
  static const AppTokens dark = AppTokens(
    primary: Color(0xFFB4C5FF),
    primaryContainer: Color(0xFF2563EB),
    onPrimary: Color(0xFF00174B),
    onPrimaryContainer: Color(0xFFEEEFFF),
    primaryFixed: Color(0xFFDBE1FF),
    primaryFixedDim: Color(0xFFB4C5FF),
    secondary: Color(0xFFBEC6E0),
    secondaryContainer: Color(0xFF3F465C),
    onSecondaryContainer: Color(0xFFDAE2FD),
    tertiary: Color(0xFF4EDEA3),
    tertiaryContainer: Color(0xFF007D55),
    tertiaryFixed: Color(0xFF6FFBBE),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    surface: Color(0xFF191C1E),
    surfaceContainerLowest: Color(0xFF0F1113),
    surfaceContainerLow: Color(0xFF191C1E),
    surfaceContainer: Color(0xFF1D2022),
    surfaceContainerHigh: Color(0xFF282A2D),
    surfaceContainerHighest: Color(0xFF333537),
    onSurface: Color(0xFFE0E3E5),
    onSurfaceVariant: Color(0xFFC3C6D7),
    outline: Color(0xFF8D91A1),
    outlineVariant: Color(0xFF434655),
    background: Color(0xFF191C1E),
    onBackground: Color(0xFFE0E3E5),
    base: 8,
    stackSm: 12,
    gutter: 16,
    stackMd: 24,
    stackLg: 40,
    radiusLg: 8,
    radiusXl: 12,
    radiusFull: 9999,
    labelSm: _labelSm,
    bodyMd: _bodyMd,
    bodyLg: _bodyLg,
    titleMd: _titleMd,
    headlineLgMobile: _headlineLgMobile,
    headlineLg: _headlineLg,
    displayLg: _displayLg,
  );

  @override
  AppTokens copyWith({Color? primary, Color? primaryContainer}) {
    // Only the fields we actually re-theme are exposed; everything else is
    // carried over. Extend as needed.
    return AppTokens(
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimary: onPrimary,
      onPrimaryContainer: onPrimaryContainer,
      primaryFixed: primaryFixed,
      primaryFixedDim: primaryFixedDim,
      secondary: secondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      tertiaryContainer: tertiaryContainer,
      tertiaryFixed: tertiaryFixed,
      error: error,
      errorContainer: errorContainer,
      surface: surface,
      surfaceContainerLowest: surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      background: background,
      onBackground: onBackground,
      base: base,
      stackSm: stackSm,
      gutter: gutter,
      stackMd: stackMd,
      stackLg: stackLg,
      radiusLg: radiusLg,
      radiusXl: radiusXl,
      radiusFull: radiusFull,
      labelSm: labelSm,
      bodyMd: bodyMd,
      bodyLg: bodyLg,
      titleMd: titleMd,
      headlineLgMobile: headlineLgMobile,
      headlineLg: headlineLg,
      displayLg: displayLg,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return t < 0.5 ? this : other;
  }
}

extension AppTokensX on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
}

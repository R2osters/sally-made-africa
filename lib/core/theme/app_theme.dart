import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Liquid-glass theme. Clash Display for display/titles (600, -0.02em),
/// Satoshi for body/UI. Dark is the primary theme; light is a real theme,
/// not an inversion.
abstract final class AppTheme {
  static const String displayFamily = 'ClashDisplay';
  static const String textFamily = 'Satoshi';

  static ThemeData light() => _build(Brightness.light, AppColors.light);
  static ThemeData dark() => _build(Brightness.dark, AppColors.dark);

  static TextStyle display({
    double size = 30,
    FontWeight weight = FontWeight.w600,
    Color? color,
    double height = 1.05,
  }) {
    return TextStyle(
      fontFamily: displayFamily,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: -0.02 * size,
      color: color,
    );
  }

  /// Section label — Satoshi 700, 12, uppercase, +0.08em, faint.
  static TextStyle sectionLabel(BuildContext context) {
    return TextStyle(
      fontFamily: textFamily,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.96,
      color: AppColors.of(context).faint,
    );
  }

  static ThemeData _build(Brightness brightness, AppColors c) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.accent,
      onSecondary: const Color(0xFF00263A),
      error: AppColors.danger,
      onError: Colors.white,
      surface: c.bg,
      onSurface: c.text,
      surfaceContainerHighest: c.bg2,
      outline: c.border,
      outlineVariant: c.border,
    );

    final textTheme = TextTheme(
      // Clash Display — display & titles only.
      displayLarge: display(size: 38, height: 1.02, color: c.text),
      displayMedium: display(size: 32, color: c.text),
      displaySmall: display(size: 30, color: c.text),
      headlineMedium: display(size: 26, color: c.text),
      headlineSmall: display(size: 22, color: c.text),
      // Satoshi — body & UI.
      titleLarge: TextStyle(
          fontFamily: textFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: c.text),
      titleMedium: TextStyle(
          fontFamily: textFamily,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: c.text),
      titleSmall: TextStyle(
          fontFamily: textFamily,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: c.text),
      bodyLarge: TextStyle(
          fontFamily: textFamily,
          fontSize: 16,
          height: 1.5,
          fontWeight: FontWeight.w400,
          color: c.text),
      bodyMedium: TextStyle(
          fontFamily: textFamily,
          fontSize: 15,
          height: 1.5,
          fontWeight: FontWeight.w400,
          color: c.text),
      bodySmall: TextStyle(
          fontFamily: textFamily,
          fontSize: 13,
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: c.dim),
      labelLarge: TextStyle(
          fontFamily: textFamily,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: c.text),
      labelMedium: TextStyle(
          fontFamily: textFamily,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: c.dim),
      labelSmall: TextStyle(
          fontFamily: textFamily,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: c.dim),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: [c],
      fontFamily: textFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: c.bg,
      splashFactory: NoSplash.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: display(size: 22, color: c.text),
        iconTheme: IconThemeData(color: c.text),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          foregroundColor: c.text,
          backgroundColor: c.surface,
          side: BorderSide(color: c.border2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.dim,
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        hintStyle: textTheme.bodyMedium?.copyWith(color: c.faint),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: BorderSide(color: c.border),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: DividerThemeData(color: c.border, thickness: 1),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        modalBackgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Colors.white : c.dim,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primary
              : c.surface2,
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}

// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

import 'app_tokens.dart';

class AppTheme {
  static const Color _seedColor = Color(0xFF004AC6);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppTokens.light.background,
      extensions: const [AppTokens.light],
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppTokens.dark.background,
      extensions: const [AppTokens.dark],
    );
  }
}

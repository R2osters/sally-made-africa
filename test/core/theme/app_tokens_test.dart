import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/theme/app_tokens.dart';
import 'package:travelconnect/core/theme/app_theme.dart';

void main() {
  test('AppTokens.light exposes canonical blue primary', () {
    expect(AppTokens.light.primary, const Color(0xFF004AC6));
    expect(AppTokens.light.primaryContainer, const Color(0xFF2563EB));
    expect(AppTokens.light.stackMd, 24);
    expect(AppTokens.light.radiusXl, 12);
  });

  test('light ThemeData carries AppTokens extension', () {
    final tokens = AppTheme.light().extension<AppTokens>();
    expect(tokens, isNotNull);
    expect(tokens!.primary, const Color(0xFF004AC6));
  });

  test('lerp returns a valid AppTokens instance', () {
    final mixed = AppTokens.light.lerp(AppTokens.dark, 0.5);
    expect(mixed, isA<AppTokens>());
  });
}

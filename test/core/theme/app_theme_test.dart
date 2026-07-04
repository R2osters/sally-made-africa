// test/core/theme/app_theme_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/theme/app_colors.dart';
import 'package:travelconnect/core/theme/app_theme.dart';

void main() {
  test('liquid-glass palette: primary blue, AppColors extension present', () {
    final light = AppTheme.light();
    final dark = AppTheme.dark();

    expect(light.useMaterial3, isTrue);
    expect(light.colorScheme.brightness, Brightness.light);
    expect(dark.colorScheme.brightness, Brightness.dark);

    expect(dark.colorScheme.primary, const Color(0xFF2F80FF));
    expect(dark.colorScheme.secondary, const Color(0xFF37E0FF));

    expect(dark.extension<AppColors>(), isNotNull);
    expect(dark.extension<AppColors>()!.bg, const Color(0xFF05070F));
    expect(light.extension<AppColors>()!.bg, const Color(0xFFEEF2F9));
  });

  test('typography: Clash Display for display, Satoshi for body', () {
    final dark = AppTheme.dark();
    expect(dark.textTheme.displayLarge!.fontFamily, 'ClashDisplay');
    expect(dark.textTheme.displayLarge!.fontSize, 38);
    expect(dark.textTheme.bodyMedium!.fontFamily, 'Satoshi');
    expect(dark.textTheme.labelLarge!.fontWeight, FontWeight.w700);
  });

  test('component themes are configured', () {
    final dark = AppTheme.dark();
    expect(dark.inputDecorationTheme.filled, isTrue);
    expect(dark.cardTheme.shape, isA<RoundedRectangleBorder>());
  });
}

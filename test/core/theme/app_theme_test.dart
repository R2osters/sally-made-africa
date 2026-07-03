// test/core/theme/app_theme_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/theme/app_theme.dart';

void main() {
  // testWidgets (not plain test): GoogleFonts fires an async font fetch whose
  // failure would otherwise be reported after a plain test() completes.
  testWidgets('light and dark themes use the warm orange seed', (tester) async {
    final light = AppTheme.light();
    final dark = AppTheme.dark();
    expect(light.useMaterial3, isTrue);
    expect(light.colorScheme.brightness, Brightness.light);
    expect(dark.colorScheme.brightness, Brightness.dark);
    // Seed #FF6B35 produces an orange-hued primary in light mode.
    final hue = HSLColor.fromColor(light.colorScheme.primary).hue;
    expect(hue, inInclusiveRange(10, 50));
  });

  testWidgets('component themes are configured', (tester) async {
    final light = AppTheme.light();
    expect(light.inputDecorationTheme.filled, isTrue);
    expect(light.cardTheme.shape, isA<RoundedRectangleBorder>());
  });
}

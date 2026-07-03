import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/theme/app_theme.dart';

void main() {
  testWidgets('light and dark themes use the warm orange seed', (WidgetTester tester) async {
    final light = AppTheme.light();
    final dark = AppTheme.dark();
    expect(light.useMaterial3, isTrue);
    expect(light.colorScheme.brightness, Brightness.light);
    expect(dark.colorScheme.brightness, Brightness.dark);
    // Seed #FF6B35 produces an orange-hued primary in light mode.
    final hue = HSLColor.fromColor(light.colorScheme.primary).hue;
    expect(hue, inInclusiveRange(10, 50));
  });

  testWidgets('component themes are configured', (WidgetTester tester) async {
    final light = AppTheme.light();
    expect(light.inputDecorationTheme.filled, isTrue);
    expect(light.cardTheme.shape, isA<RoundedRectangleBorder>());
  });
}

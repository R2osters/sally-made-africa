// test/features/catalog/country_select_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/error/result.dart';
import 'package:travelconnect/core/theme/app_theme.dart';
import 'package:travelconnect/features/catalog/data/catalog_repository.dart';
import 'package:travelconnect/features/catalog/data/models/country.dart';
import 'package:travelconnect/features/catalog/presentation/country_select_screen.dart';

void main() {
  testWidgets('CountrySelectScreen lists countries from provider',
      (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        countriesProvider.overrideWith((ref) async => const Success(
              [Country(code: 'JP', name: 'Japan', region: 'Asia')],
            )),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CountrySelectScreen(),
      ),
    ));
    await tester.pump();
    expect(find.text('Japan'), findsOneWidget);
  });
}

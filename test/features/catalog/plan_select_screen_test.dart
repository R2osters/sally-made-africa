// test/features/catalog/plan_select_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/error/result.dart';
import 'package:travelconnect/core/theme/app_theme.dart';
import 'package:travelconnect/features/catalog/data/catalog_repository.dart';
import 'package:travelconnect/features/catalog/data/models/esim_plan.dart';
import 'package:travelconnect/features/catalog/presentation/plan_select_screen.dart';

void main() {
  testWidgets('PlanSelectScreen lists plans for a country', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        plansProvider('JP').overrideWith((ref) async => const Success([
              EsimPlan(
                id: 'p1',
                countryCode: 'JP',
                dataGb: 10,
                validityDays: 30,
                priceUsd: 24.00,
                networkLabel: '5G/LTE',
                isPopular: true,
              ),
            ])),
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
        home: const PlanSelectScreen(countryCode: 'JP'),
      ),
    ));
    await tester.pump();
    expect(find.textContaining('10'), findsWidgets);
    expect(find.text('Select Plan'), findsWidgets);
  });
}

// test/features/catalog/plan_details_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/theme/app_theme.dart';
import 'package:travelconnect/features/catalog/data/models/country.dart';
import 'package:travelconnect/features/catalog/data/models/esim_plan.dart';
import 'package:travelconnect/features/catalog/presentation/plan_details_screen.dart';
import 'package:travelconnect/features/purchase/presentation/purchase_flow_controller.dart';

void main() {
  testWidgets('PlanDetailsScreen shows selected plan and Buy Now',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(purchaseFlowProvider.notifier).select(
          const Country(code: 'JP', name: 'Japan', region: 'Asia'),
          const EsimPlan(
            id: 'p1',
            countryCode: 'JP',
            dataGb: 5,
            validityDays: 30,
            priceUsd: 14.99,
            isPopular: false,
          ),
        );

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const PlanDetailsScreen(),
      ),
    ));
    expect(find.text('Buy Now'), findsOneWidget);
    expect(find.textContaining('14.99'), findsWidgets);
  });
}

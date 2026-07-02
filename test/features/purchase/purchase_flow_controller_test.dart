// test/features/purchase/purchase_flow_controller_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/features/catalog/data/models/country.dart';
import 'package:travelconnect/features/catalog/data/models/esim_plan.dart';
import 'package:travelconnect/features/purchase/presentation/purchase_flow_controller.dart';

void main() {
  test('select stores plan and computes total with tax', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    const country = Country(code: 'JP', name: 'Japan', region: 'Asia');
    const plan = EsimPlan(
      id: 'p1',
      countryCode: 'JP',
      dataGb: 5,
      validityDays: 30,
      priceUsd: 10.00,
      isPopular: false,
    );

    container.read(purchaseFlowProvider.notifier).select(country, plan);
    final state = container.read(purchaseFlowProvider);

    expect(state.plan!.id, 'p1');
    expect(state.taxes, closeTo(0.8, 0.001));
    expect(state.total, closeTo(10.8, 0.001));
  });

  test('clear resets selection', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    const country = Country(code: 'JP', name: 'Japan', region: 'Asia');
    const plan = EsimPlan(
        id: 'p1',
        countryCode: 'JP',
        dataGb: 5,
        validityDays: 30,
        priceUsd: 10,
        isPopular: false);
    final notifier = container.read(purchaseFlowProvider.notifier);
    notifier.select(country, plan);
    notifier.clear();
    expect(container.read(purchaseFlowProvider).plan, isNull);
  });
}

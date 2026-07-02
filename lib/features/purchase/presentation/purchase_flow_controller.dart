// lib/features/purchase/presentation/purchase_flow_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalog/data/models/country.dart';
import '../../catalog/data/models/esim_plan.dart';

class PurchaseFlowState {
  final Country? country;
  final EsimPlan? plan;

  const PurchaseFlowState({this.country, this.plan});

  num get taxes => (plan?.priceUsd ?? 0) * 0.08;
  num get total => (plan?.priceUsd ?? 0) + taxes;

  PurchaseFlowState copyWith({Country? country, EsimPlan? plan}) =>
      PurchaseFlowState(
        country: country ?? this.country,
        plan: plan ?? this.plan,
      );
}

class PurchaseFlowController extends Notifier<PurchaseFlowState> {
  @override
  PurchaseFlowState build() => const PurchaseFlowState();

  void select(Country country, EsimPlan plan) {
    state = PurchaseFlowState(country: country, plan: plan);
  }

  void clear() {
    state = const PurchaseFlowState();
  }
}

final purchaseFlowProvider =
    NotifierProvider<PurchaseFlowController, PurchaseFlowState>(
        PurchaseFlowController.new);

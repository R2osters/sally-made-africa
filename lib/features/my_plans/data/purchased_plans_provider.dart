import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalog/domain/catalog_models.dart';
import '../domain/purchased_plan.dart';
import 'my_plans_mock.dart';

/// In-session purchased plans, seeded with the showcase data. The Purchase
/// sub-project swaps this for Supabase-backed persistence.
class PurchasedPlansNotifier extends Notifier<List<PurchasedPlan>> {
  @override
  List<PurchasedPlan> build() => List.of(MyPlansMock.plans);

  void addFromSelection(SelectedPlan selection) {
    final hex = selection.operator.brandColor.value
        .toRadixString(16)
        .padLeft(8, '0')
        .substring(2)
        .toUpperCase();
    state = [
      PurchasedPlan(
        countryId: selection.country.id,
        countryName: selection.country.name,
        flagEmoji: selection.country.flagEmoji,
        operatorName: selection.operator.name,
        operatorColorHex: hex,
        dataLabel: selection.spec.dataLabel,
        usedPct: 0,
        leftLabel: selection.spec.dataLabel,
        daysLeft: selection.spec.validityDays,
        status: PlanStatus.active,
      ),
      ...state,
    ];
  }
}

final purchasedPlansProvider =
    NotifierProvider<PurchasedPlansNotifier, List<PurchasedPlan>>(
        PurchasedPlansNotifier.new);

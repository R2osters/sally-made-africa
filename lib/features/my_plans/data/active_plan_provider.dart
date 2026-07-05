import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalog/data/catalog_mock.dart';
import '../../catalog/domain/catalog_models.dart';

/// The showcase active plan (Sénégal · Orange), now live so top-ups work.
class ActivePlanState {
  final double totalGb;
  final double usedGb;
  final int daysLeft;

  const ActivePlanState({
    required this.totalGb,
    required this.usedGb,
    required this.daysLeft,
  });

  double get leftGb => (totalGb - usedGb).clamp(0, totalGb);
  int get leftPct =>
      totalGb == 0 ? 0 : ((leftGb / totalGb) * 100).round();

  static String formatGb(double gb) {
    final isInt = gb == gb.roundToDouble();
    final s = isInt ? gb.toInt().toString() : gb.toStringAsFixed(1);
    return '${s.replaceAll('.', ',')} Go';
  }

  String get leftLabel => formatGb(leftGb);
  String get totalLabel => formatGb(totalGb);
}

class ActivePlanNotifier extends Notifier<ActivePlanState> {
  static const country = 'Sénégal';
  static const operator = 'Orange';

  @override
  ActivePlanState build() =>
      // Prototype values: 3,7 Go left of 6 Go, 5 days.
      const ActivePlanState(totalGb: 6, usedGb: 2.3, daysLeft: 5);

  /// Top-up: adds the tier's data volume and extends validity.
  void topUp(PlanSpec spec) {
    final addedGb =
        double.parse(spec.dataLabel.split(' ').first.replaceAll(',', '.'));
    state = ActivePlanState(
      totalGb: state.totalGb + addedGb,
      usedGb: state.usedGb,
      daysLeft: state.daysLeft + spec.validityDays,
    );
  }

  /// Price label for a top-up tier (active plan is XOF / Sénégal).
  String priceLabelFor(PlanSpec spec) {
    final senegal =
        CatalogMock.countries.firstWhere((c) => c.id == 'sn');
    return CatalogMock.priceLabelFor(senegal, spec);
  }
}

final activePlanProvider =
    NotifierProvider<ActivePlanNotifier, ActivePlanState>(
        ActivePlanNotifier.new);

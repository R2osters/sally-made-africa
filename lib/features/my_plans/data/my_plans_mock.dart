import '../domain/purchased_plan.dart';

/// Showcase data from the design prototype.
abstract final class MyPlansMock {
  static const plans = <PurchasedPlan>[
    PurchasedPlan(
      countryName: 'Sénégal',
      flagEmoji: '🇸🇳',
      operatorName: 'Orange',
      operatorColorHex: 'FF7900',
      dataLabel: '6 Go',
      usedPct: 38,
      leftLabel: '3,7 Go',
      daysLeft: 5,
      status: PlanStatus.active,
    ),
    PurchasedPlan(
      countryName: 'Ghana',
      flagEmoji: '🇬🇭',
      operatorName: 'MTN',
      operatorColorHex: 'FFCC00',
      dataLabel: '15 Go',
      usedPct: 72,
      leftLabel: '4,2 Go',
      daysLeft: 18,
      status: PlanStatus.active,
    ),
    PurchasedPlan(
      countryName: "Côte d'Ivoire",
      flagEmoji: '🇨🇮',
      operatorName: 'Orange',
      operatorColorHex: 'FF7900',
      dataLabel: '6 Go',
      usedPct: 100,
      leftLabel: '0 Go',
      daysLeft: 0,
      status: PlanStatus.expired,
    ),
  ];

  /// Active-plan detail screen (ring + QR) showcase values.
  static const activeUsedLabel = '3,7 Go';
  static const activeTotalLabel = '6 Go';
  static const activeRingPct = 62;
  static const activeCountry = 'Sénégal';
  static const activeOperator = 'Orange';
  static const activeDaysLeft = 5;
}

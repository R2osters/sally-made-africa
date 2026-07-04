enum PlanStatus { active, expired, pending }

class PurchasedPlan {
  final String countryName;
  final String flagEmoji;
  final String operatorName;
  final String operatorColorHex;
  final String dataLabel;
  final int usedPct;
  final String leftLabel;
  final int daysLeft;
  final PlanStatus status;

  const PurchasedPlan({
    required this.countryName,
    required this.flagEmoji,
    required this.operatorName,
    required this.operatorColorHex,
    required this.dataLabel,
    required this.usedPct,
    required this.leftLabel,
    required this.daysLeft,
    required this.status,
  });
}

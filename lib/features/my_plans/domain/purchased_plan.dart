import '../../home/domain/data_plan.dart';

class PurchasedPlan {
  final DataPlan plan;
  final double usedGigabytes;
  final int daysLeft;
  final bool active;

  const PurchasedPlan({
    required this.plan,
    required this.usedGigabytes,
    required this.daysLeft,
    required this.active,
  });
}

// Hard-coded showcase data. Replaced by Supabase in the Purchase sub-project.
import '../../home/domain/data_plan.dart';
import '../domain/purchased_plan.dart';

const PurchasedPlan mockActivePlan = PurchasedPlan(
  plan: DataPlan(
    id: 'gh-mtn-5',
    countryName: 'Ghana',
    flagEmoji: '🇬🇭',
    operatorName: 'MTN',
    gigabytes: 5,
    validityDays: 7,
    priceLabel: '3 500 FCFA',
  ),
  usedGigabytes: 2.1,
  daysLeft: 4,
  active: true,
);

const mockPastPlans = <PurchasedPlan>[
  PurchasedPlan(
    plan: DataPlan(
      id: 'sn-orange-8',
      countryName: 'Sénégal',
      flagEmoji: '🇸🇳',
      operatorName: 'Orange',
      gigabytes: 8,
      validityDays: 14,
      priceLabel: '5 000 FCFA',
    ),
    usedGigabytes: 8,
    daysLeft: 0,
    active: false,
  ),
];

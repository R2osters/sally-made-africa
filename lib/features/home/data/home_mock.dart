// Hard-coded showcase data. Replaced by Supabase in the Catalog sub-project.
import '../domain/data_plan.dart';

const mockPopularCountries = <PopularCountry>[
  PopularCountry(name: 'Ghana', flagEmoji: '🇬🇭'),
  PopularCountry(name: 'Togo', flagEmoji: '🇹🇬'),
  PopularCountry(name: 'Bénin', flagEmoji: '🇧🇯'),
  PopularCountry(name: 'Nigeria', flagEmoji: '🇳🇬'),
  PopularCountry(name: "Côte d'Ivoire", flagEmoji: '🇨🇮'),
  PopularCountry(name: 'Sénégal', flagEmoji: '🇸🇳'),
];

const mockPopularPlans = <DataPlan>[
  DataPlan(
    id: 'gh-mtn-5',
    countryName: 'Ghana',
    flagEmoji: '🇬🇭',
    operatorName: 'MTN',
    gigabytes: 5,
    validityDays: 7,
    priceLabel: '3 500 FCFA',
  ),
  DataPlan(
    id: 'tg-togocom-10',
    countryName: 'Togo',
    flagEmoji: '🇹🇬',
    operatorName: 'Togocom',
    gigabytes: 10,
    validityDays: 30,
    priceLabel: '6 000 FCFA',
  ),
  DataPlan(
    id: 'sn-orange-8',
    countryName: 'Sénégal',
    flagEmoji: '🇸🇳',
    operatorName: 'Orange',
    gigabytes: 8,
    validityDays: 14,
    priceLabel: '5 000 FCFA',
  ),
  DataPlan(
    id: 'ci-mtn-20',
    countryName: "Côte d'Ivoire",
    flagEmoji: '🇨🇮',
    operatorName: 'MTN',
    gigabytes: 20,
    validityDays: 30,
    priceLabel: '10 000 FCFA',
  ),
];

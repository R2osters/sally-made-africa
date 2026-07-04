import 'dart:ui';

/// Catalog domain — countries, operators, plan tiers. Mock-backed for now;
/// the Catalog sub-project swaps the data source for Supabase.
class Country {
  final String id;
  final String name;
  final String flagEmoji;
  final double lat;
  final double lon;
  final String currency; // XOF | GHS | NGN
  final List<String> operatorIds;

  const Country({
    required this.id,
    required this.name,
    required this.flagEmoji,
    required this.lat,
    required this.lon,
    required this.currency,
    required this.operatorIds,
  });
}

class OperatorInfo {
  final String id;
  final String name;
  final Color brandColor;
  final Color onBrandColor;

  const OperatorInfo({
    required this.id,
    required this.name,
    required this.brandColor,
    required this.onBrandColor,
  });

  String get initials {
    final words = name.split(' ');
    return words.map((w) => w[0]).take(2).join().toUpperCase();
  }
}

class PlanSpec {
  final String dataLabel; // "1,5 Go" — displayed as-is
  final int validityDays;
  final int tier; // index into the per-currency price list
  final bool hot; // highlighted tier in the plans sheet

  const PlanSpec({
    required this.dataLabel,
    required this.validityDays,
    required this.tier,
    this.hot = false,
  });
}

/// A concrete plan the user picked: country + operator + tier + price.
class SelectedPlan {
  final Country country;
  final OperatorInfo operator;
  final PlanSpec spec;
  final String priceLabel;
  final String durationLabel;

  const SelectedPlan({
    required this.country,
    required this.operator,
    required this.spec,
    required this.priceLabel,
    required this.durationLabel,
  });
}

class PaymentMethod {
  final String id;
  final String name;
  final String tag;
  final Color brandColor;
  final Color onBrandColor;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.tag,
    required this.brandColor,
    required this.onBrandColor,
  });
}

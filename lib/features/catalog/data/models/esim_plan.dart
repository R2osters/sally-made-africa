class EsimPlan {
  final String id;
  final String countryCode;
  final num dataGb;
  final int validityDays;
  final num priceUsd;
  final String? networkLabel;
  final bool isPopular;

  const EsimPlan({
    required this.id,
    required this.countryCode,
    required this.dataGb,
    required this.validityDays,
    required this.priceUsd,
    this.networkLabel,
    required this.isPopular,
  });

  factory EsimPlan.fromMap(Map<String, dynamic> map) => EsimPlan(
        id: map['id'] as String,
        countryCode: map['country_code'] as String,
        dataGb: map['data_gb'] as num,
        validityDays: map['validity_days'] as int,
        priceUsd: map['price_usd'] as num,
        networkLabel: map['network_label'] as String?,
        isPopular: (map['is_popular'] as bool?) ?? false,
      );
}

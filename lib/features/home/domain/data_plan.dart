class DataPlan {
  final String id;
  final String countryName;
  final String flagEmoji;
  final String operatorName;
  final int gigabytes;
  final int validityDays;
  final String priceLabel;

  const DataPlan({
    required this.id,
    required this.countryName,
    required this.flagEmoji,
    required this.operatorName,
    required this.gigabytes,
    required this.validityDays,
    required this.priceLabel,
  });
}

class PopularCountry {
  final String name;
  final String flagEmoji;
  const PopularCountry({required this.name, required this.flagEmoji});
}

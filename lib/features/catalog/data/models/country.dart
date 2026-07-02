class Country {
  final String code;
  final String name;
  final String region;
  final String? flagUrl;
  final String? coverageLabel;

  const Country({
    required this.code,
    required this.name,
    required this.region,
    this.flagUrl,
    this.coverageLabel,
  });

  factory Country.fromMap(Map<String, dynamic> map) => Country(
        code: map['code'] as String,
        name: map['name'] as String,
        region: map['region'] as String,
        flagUrl: map['flag_url'] as String?,
        coverageLabel: map['coverage_label'] as String?,
      );
}

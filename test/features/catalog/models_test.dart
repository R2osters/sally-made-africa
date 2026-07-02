import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/features/catalog/data/models/country.dart';
import 'package:travelconnect/features/catalog/data/models/esim_plan.dart';

void main() {
  test('Country.fromMap parses fields', () {
    final c = Country.fromMap({
      'code': 'JP',
      'name': 'Japan',
      'region': 'Asia',
      'flag_url': 'https://x/jp.png',
      'coverage_label': 'Excellent Coverage',
    });
    expect(c.code, 'JP');
    expect(c.name, 'Japan');
    expect(c.region, 'Asia');
  });

  test('EsimPlan.fromMap parses fields', () {
    final p = EsimPlan.fromMap({
      'id': 'abc',
      'country_code': 'JP',
      'data_gb': 5,
      'validity_days': 30,
      'price_usd': 14.99,
      'network_label': '5G/LTE',
      'is_popular': true,
    });
    expect(p.id, 'abc');
    expect(p.dataGb, 5);
    expect(p.priceUsd, 14.99);
    expect(p.isPopular, isTrue);
  });
}

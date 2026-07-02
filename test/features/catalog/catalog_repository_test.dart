// test/features/catalog/catalog_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/error/result.dart';
import 'package:travelconnect/features/catalog/data/catalog_repository.dart';
import 'package:travelconnect/features/catalog/data/models/country.dart';
import 'package:travelconnect/features/catalog/data/models/esim_plan.dart';

class _FakeCatalogRepository implements CatalogRepository {
  @override
  Future<Result<List<Country>>> fetchCountries() async =>
      const Success([Country(code: 'JP', name: 'Japan', region: 'Asia')]);

  @override
  Future<Result<List<EsimPlan>>> fetchPlans(String countryCode) async =>
      const Success([]);
}

void main() {
  test('repository contract returns Result of countries', () async {
    final CatalogRepository repo = _FakeCatalogRepository();
    final res = await repo.fetchCountries();
    expect(res, isA<Success<List<Country>>>());
    expect(res.valueOrNull!.first.name, 'Japan');
  });
}

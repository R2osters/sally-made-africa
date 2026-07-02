// lib/features/catalog/data/catalog_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/supabase_client.dart';
import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import 'models/country.dart';
import 'models/esim_plan.dart';

abstract class CatalogRepository {
  Future<Result<List<Country>>> fetchCountries();
  Future<Result<List<EsimPlan>>> fetchPlans(String countryCode);
}

class SupabaseCatalogRepository implements CatalogRepository {
  final SupabaseClient _client;
  const SupabaseCatalogRepository(this._client);

  @override
  Future<Result<List<Country>>> fetchCountries() async {
    try {
      final rows = await _client.from('countries').select().order('name');
      final list = (rows as List)
          .map((r) => Country.fromMap(r as Map<String, dynamic>))
          .toList();
      return Success(list);
    } catch (e) {
      return Error(ServerFailure('Could not load countries: $e'));
    }
  }

  @override
  Future<Result<List<EsimPlan>>> fetchPlans(String countryCode) async {
    try {
      final rows = await _client
          .from('esim_plans')
          .select()
          .eq('country_code', countryCode)
          .order('price_usd');
      final list = (rows as List)
          .map((r) => EsimPlan.fromMap(r as Map<String, dynamic>))
          .toList();
      return Success(list);
    } catch (e) {
      return Error(ServerFailure('Could not load plans: $e'));
    }
  }
}

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return SupabaseCatalogRepository(ref.watch(supabaseClientProvider));
});

final countriesProvider = FutureProvider<Result<List<Country>>>((ref) {
  return ref.watch(catalogRepositoryProvider).fetchCountries();
});

final plansProvider =
    FutureProvider.family<Result<List<EsimPlan>>, String>((ref, countryCode) {
  return ref.watch(catalogRepositoryProvider).fetchPlans(countryCode);
});

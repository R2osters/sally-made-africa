// lib/features/catalog/presentation/country_select_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/result.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../data/catalog_repository.dart';

class CountrySelectScreen extends ConsumerWidget {
  const CountrySelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(countriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.countrySelectTitle)),
      body: async.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(countriesProvider),
        ),
        data: (result) => switch (result) {
          Error(failure: final f) => ErrorView(
              message: f.message,
              onRetry: () => ref.invalidate(countriesProvider),
            ),
          Success(value: final countries) => ListView.separated(
              padding: EdgeInsets.all(t.gutter),
              itemCount: countries.length,
              separatorBuilder: (_, __) => Divider(color: t.outlineVariant),
              itemBuilder: (context, i) {
                final c = countries[i];
                return ListTile(
                  title: Text(c.name, style: t.bodyLg),
                  subtitle: Text(c.region,
                      style: t.labelSm.copyWith(color: t.onSurfaceVariant)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/country/${c.code}/plans'),
                );
              },
            ),
        },
      ),
    );
  }
}

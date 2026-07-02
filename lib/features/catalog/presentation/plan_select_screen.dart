// lib/features/catalog/presentation/plan_select_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/result.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/pill_button.dart';
import '../data/catalog_repository.dart';

class PlanSelectScreen extends ConsumerWidget {
  final String countryCode;
  const PlanSelectScreen({super.key, required this.countryCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(plansProvider(countryCode));

    return Scaffold(
      appBar: AppBar(title: Text(countryCode)),
      body: async.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(plansProvider(countryCode)),
        ),
        data: (result) => switch (result) {
          Error(failure: final f) => ErrorView(
              message: f.message,
              onRetry: () => ref.invalidate(plansProvider(countryCode)),
            ),
          Success(value: final plans) => ListView.builder(
              padding: EdgeInsets.all(t.gutter),
              itemCount: plans.length,
              itemBuilder: (context, i) {
                final p = plans[i];
                return Card(
                  margin: EdgeInsets.only(bottom: t.gutter),
                  child: Padding(
                    padding: EdgeInsets.all(t.stackMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${p.dataGb}GB',
                                style: t.displayLg.copyWith(color: t.onSurface)),
                            Text('\$${p.priceUsd.toStringAsFixed(2)}',
                                style: t.titleMd.copyWith(color: t.onSurface)),
                          ],
                        ),
                        Text('${p.validityDays} Days',
                            style: t.bodyMd
                                .copyWith(color: t.onSurfaceVariant)),
                        SizedBox(height: t.stackSm),
                        PillButton(
                          label: l10n.selectPlan,
                          onPressed: () => context.push('/plans/${p.id}'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        },
      ),
    );
  }
}

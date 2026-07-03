import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/pill_button.dart';
import 'purchase_flow_controller.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(purchaseFlowProvider);
    final plan = state.plan;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkoutTitle)),
      body: ListView(
        padding: EdgeInsets.all(t.stackMd),
        children: [
          Text(l10n.checkoutTitle,
              style: t.displayLg.copyWith(color: t.onSurface)),
          SizedBox(height: t.stackMd),
          Text(l10n.orderSummary,
              style: t.titleMd.copyWith(color: t.onSurface)),
          SizedBox(height: t.stackSm),
          if (plan != null) ...[
            _row(t, '${plan.dataGb}GB • ${plan.validityDays} Days',
                '\$${plan.priceUsd.toStringAsFixed(2)}'),
            Divider(color: t.outlineVariant),
            _row(t, l10n.subtotal,
                '\$${plan.priceUsd.toStringAsFixed(2)}'),
            _row(t, l10n.taxesFees, '\$${state.taxes.toStringAsFixed(2)}'),
            Divider(color: t.outlineVariant),
            _row(t, l10n.total, '\$${state.total.toStringAsFixed(2)}',
                bold: true),
          ],
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(t.stackMd),
        child: PillButton(
          label: l10n.continueToPayment,
          trailingIcon: Icons.lock,
          onPressed: plan == null ? null : () => context.push('/payment-method'),
        ),
      ),
    );
  }

  Widget _row(AppTokens t, String label, String value, {bool bold = false}) {
    final style = bold
        ? t.titleMd.copyWith(color: t.onSurface)
        : t.bodyLg.copyWith(color: t.onSurfaceVariant);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: t.base),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }
}

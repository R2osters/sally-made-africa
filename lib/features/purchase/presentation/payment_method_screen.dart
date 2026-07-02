// lib/features/purchase/presentation/payment_method_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/pill_button.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selected = 'card';

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = AppLocalizations.of(context)!;
    final methods = <String, (String, IconData)>{
      'apple_pay': ('Apple Pay', Icons.apple),
      'card': ('Credit or Debit Card', Icons.credit_card),
      'paypal': ('PayPal', Icons.account_balance_wallet),
      'google_pay': ('Google Pay', Icons.g_mobiledata),
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.paymentMethodTitle)),
      body: ListView(
        padding: EdgeInsets.all(t.stackMd),
        children: [
          Text(l10n.paymentMethodTitle,
              style: t.displayLg.copyWith(color: t.onSurface)),
          SizedBox(height: t.stackMd),
          ...methods.entries.map((e) {
            final (label, icon) = e.value;
            return RadioListTile<String>(
              value: e.key,
              groupValue: _selected,
              onChanged: (v) => setState(() => _selected = v!),
              title: Text(label, style: t.titleMd.copyWith(color: t.onSurface)),
              secondary: Icon(icon, color: t.primary),
            );
          }),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(t.stackMd),
        child: PillButton(
          label: l10n.confirmPayment,
          onPressed: () => context.push('/payment-processing'),
        ),
      ),
    );
  }
}

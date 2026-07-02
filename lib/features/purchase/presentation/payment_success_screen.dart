import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/pill_button.dart';
import 'purchase_flow_controller.dart';

class PaymentSuccessScreen extends ConsumerWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = AppLocalizations.of(context)!;

    void finish() {
      ref.read(purchaseFlowProvider.notifier).clear();
      context.go('/my-plans');
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(t.stackMd),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: t.tertiaryContainer.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle, size: 64, color: t.tertiary),
              ),
              SizedBox(height: t.stackMd),
              Text(l10n.purchaseSuccessTitle,
                  style: t.displayLg.copyWith(color: t.onSurface),
                  textAlign: TextAlign.center),
              const Spacer(),
              PillButton(
                label: l10n.activateEsim,
                trailingIcon: Icons.sim_card,
                onPressed: finish,
              ),
              SizedBox(height: t.stackSm),
              PillButton(
                label: l10n.goToMyPlans,
                filled: false,
                onPressed: finish,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

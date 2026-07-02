// lib/features/catalog/presentation/plan_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/pill_button.dart';
import '../../purchase/presentation/purchase_flow_controller.dart';

class PlanDetailsScreen extends ConsumerWidget {
  const PlanDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = AppLocalizations.of(context)!;
    final plan = ref.watch(purchaseFlowProvider).plan;

    if (plan == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('No plan selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('${plan.dataGb}GB')),
      body: ListView(
        padding: EdgeInsets.all(t.stackMd),
        children: [
          Text('${plan.dataGb}GB Data',
              style: t.displayLg.copyWith(color: t.onSurface)),
          SizedBox(height: t.base),
          Text('\$${plan.priceUsd.toStringAsFixed(2)}',
              style: t.headlineLg.copyWith(color: t.primary)),
          SizedBox(height: t.stackSm),
          Text('Valid for ${plan.validityDays} Days',
              style: t.bodyMd.copyWith(color: t.onSurfaceVariant)),
          SizedBox(height: t.stackLg),
          Text(l10n.planFeaturesTitle,
              style: t.titleMd.copyWith(color: t.onSurface)),
          SizedBox(height: t.stackSm),
          _Feature(icon: Icons.speed, label: 'High-Speed 5G/4G', tokens: t),
          _Feature(
              icon: Icons.install_mobile,
              label: 'Instant Activation',
              tokens: t),
          _Feature(
              icon: Icons.wifi_tethering, label: 'Hotspot Allowed', tokens: t),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(t.stackMd),
        child: PillButton(
          label: l10n.buyNow,
          onPressed: () => context.push('/checkout'),
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppTokens tokens;
  const _Feature(
      {required this.icon, required this.label, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: tokens.base),
      child: Row(
        children: [
          Icon(icon, color: tokens.primary),
          SizedBox(width: tokens.gutter),
          Text(label, style: tokens.bodyLg.copyWith(color: tokens.onSurface)),
        ],
      ),
    );
  }
}

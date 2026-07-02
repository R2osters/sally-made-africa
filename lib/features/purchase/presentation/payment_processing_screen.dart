// lib/features/purchase/presentation/payment_processing_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';

class PaymentProcessingScreen extends StatefulWidget {
  const PaymentProcessingScreen({super.key});

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Mock gateway latency. Real PaymentService lands in the Purchase spec.
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) context.go('/payment-success');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield, size: 64, color: t.primary),
            SizedBox(height: t.stackLg),
            const CircularProgressIndicator(),
            SizedBox(height: t.stackMd),
            Text(l10n.processingPayment,
                style: t.headlineLgMobile.copyWith(color: t.onSurface),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

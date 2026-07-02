import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/gradient_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) context.go('/onboarding');
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
      body: GradientBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: t.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.flight_takeoff,
                    size: 48, color: t.primaryContainer),
              ),
              SizedBox(height: t.stackMd),
              Text('TravelConnect',
                  style: t.displayLg.copyWith(color: t.primaryContainer)),
              SizedBox(height: t.base),
              Text(l10n.splashTagline,
                  style: t.bodyLg.copyWith(color: t.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}

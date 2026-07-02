// lib/features/onboarding/presentation/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/pill_button.dart';
import '../../../shared/widgets/step_dots.dart';

class _Slide {
  final IconData icon;
  final String title;
  final String body;
  const _Slide(this.icon, this.title, this.body);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() => context.go('/login');

  void _next(int lastIndex) {
    if (_index < lastIndex) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = AppLocalizations.of(context)!;
    final slides = [
      _Slide(Icons.public, l10n.onboardingTitle1, l10n.onboardingBody1),
      _Slide(Icons.sim_card, l10n.onboardingTitle2, l10n.onboardingBody2),
      _Slide(Icons.savings, l10n.onboardingTitle3, l10n.onboardingBody3),
    ];
    final lastIndex = slides.length - 1;
    final isLast = _index == lastIndex;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: t.stackMd),
              Text('TravelConnect',
                  style: t.headlineLgMobile.copyWith(color: t.primary)),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: slides.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final s = slides[i];
                    return Padding(
                      padding: EdgeInsets.all(t.gutter),
                      child: GlassCard(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                color: t.primaryFixed,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(s.icon,
                                  size: 44, color: t.primaryContainer),
                            ),
                            SizedBox(height: t.stackLg),
                            Text(s.title,
                                style: t.headlineLgMobile
                                    .copyWith(color: t.onSurface),
                                textAlign: TextAlign.center),
                            SizedBox(height: t.stackSm),
                            Text(s.body,
                                style: t.bodyLg
                                    .copyWith(color: t.onSurfaceVariant),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              StepDots(count: slides.length, activeIndex: _index),
              Padding(
                padding: EdgeInsets.all(t.stackMd),
                child: Column(
                  children: [
                    PillButton(
                      label: isLast
                          ? l10n.onboardingGetStarted
                          : l10n.onboardingContinue,
                      trailingIcon: Icons.arrow_forward,
                      onPressed: () => _next(lastIndex),
                    ),
                    SizedBox(height: t.stackSm),
                    TextButton(
                      onPressed: isLast ? null : _finish,
                      child: Text(l10n.onboardingSkip,
                          style: t.labelSm.copyWith(
                              color: isLast
                                  ? Colors.transparent
                                  : t.onSurfaceVariant)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

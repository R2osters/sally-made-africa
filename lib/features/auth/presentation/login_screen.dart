import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/pill_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(t.stackMd),
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: t.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.public, color: t.onPrimaryContainer),
                    ),
                    SizedBox(height: t.gutter),
                    Text(l10n.loginTitle,
                        style: t.headlineLgMobile.copyWith(color: t.primary)),
                    SizedBox(height: t.base),
                    Text(l10n.loginSubtitle,
                        style: t.bodyMd.copyWith(color: t.onSurfaceVariant),
                        textAlign: TextAlign.center),
                    SizedBox(height: t.stackMd),
                    TextField(
                      decoration: InputDecoration(
                        labelText: l10n.emailLabel,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: t.gutter),
                    TextField(
                      decoration: InputDecoration(
                        labelText: l10n.passwordLabel,
                        border: const OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: t.stackMd),
                    PillButton(
                      label: l10n.logInAction,
                      onPressed: () => context.go('/home'),
                    ),
                    SizedBox(height: t.stackSm),
                    TextButton(
                      onPressed: () => context.go('/signup'),
                      child: Text(l10n.createAccountAction,
                          style: t.labelSm.copyWith(color: t.primary)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

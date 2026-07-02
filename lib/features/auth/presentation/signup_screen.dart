import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/pill_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _agreed = false;

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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.signupTitle,
                        style: t.titleMd.copyWith(color: t.onSurface)),
                    SizedBox(height: t.stackMd),
                    TextField(
                      decoration: InputDecoration(
                        labelText: l10n.fullNameLabel,
                        prefixIcon: const Icon(Icons.person),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: t.stackSm),
                    TextField(
                      decoration: InputDecoration(
                        labelText: l10n.emailLabel,
                        prefixIcon: const Icon(Icons.mail),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: t.stackSm),
                    TextField(
                      decoration: InputDecoration(
                        labelText: l10n.passwordLabel,
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: t.stackSm),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreed,
                          onChanged: (v) =>
                              setState(() => _agreed = v ?? false),
                        ),
                        Expanded(
                          child: Text(l10n.agreeTerms,
                              style: t.bodyMd
                                  .copyWith(color: t.onSurfaceVariant)),
                        ),
                      ],
                    ),
                    SizedBox(height: t.stackMd),
                    PillButton(
                      label: l10n.createAccountAction,
                      trailingIcon: Icons.arrow_forward,
                      onPressed: _agreed ? () => context.go('/home') : null,
                    ),
                    SizedBox(height: t.stackSm),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(l10n.logInAction,
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

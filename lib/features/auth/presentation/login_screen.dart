import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _emailError;
  bool _loading = false;

  static final _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _emailError =
          _emailRe.hasMatch(_email.text) ? null : l10n.authEmailInvalid;
    });
    if (_emailError != null) return;
    setState(() => _loading = true);
    // UI-only: fake a short round-trip, then land on Home.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Text(l10n.authLoginTitle,
                style: textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800))
                .animate()
                .fadeIn(duration: 300.ms)
                .moveY(begin: 12),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              label: l10n.authEmailLabel,
              controller: _email,
              errorText: _emailError,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
            ).animate(delay: 80.ms).fadeIn(duration: 300.ms).moveY(begin: 12),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.authPasswordLabel,
              controller: _password,
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: true,
            ).animate(delay: 160.ms).fadeIn(duration: 300.ms).moveY(begin: 12),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(l10n.authForgotPassword),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: l10n.authLoginButton,
              loading: _loading,
              onPressed: _submit,
            ).animate(delay: 240.ms).fadeIn(duration: 300.ms),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: l10n.authNoAccount,
              variant: AppButtonVariant.ghost,
              onPressed: () => context.go('/auth/signup'),
            ),
          ],
        ),
      ),
    );
  }
}

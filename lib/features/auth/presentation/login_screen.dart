import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'auth_shell.dart';

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
      _emailError = _emailRe.hasMatch(_email.text) ? null : l10n.emailInvalid;
    });
    if (_emailError != null) return;
    setState(() => _loading = true);
    // UI-only: fake a short round-trip, then verify by OTP.
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (mounted) context.go('/auth/otp');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthShell(
      title: l10n.loginTitle,
      subtitle: l10n.loginSub,
      children: [
        AppTextField(
          label: l10n.email,
          hint: 'vous@exemple.com',
          controller: _email,
          errorText: _emailError,
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: l10n.password,
          controller: _password,
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(l10n.forgot),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(label: l10n.signIn, loading: _loading, onPressed: _submit),
        const SizedBox(height: AppSpacing.xl),
        AuthFooterLink(
          question: l10n.noAccount,
          action: l10n.signupLink,
          onTap: () => context.go('/auth/signup'),
        ),
      ]
          .animate(interval: 60.ms)
          .fadeIn(duration: 500.ms, curve: const Cubic(.2, .8, .2, 1))
          .moveY(begin: 8, end: 0, duration: 500.ms),
    );
  }
}

/// "Question  Action" footer used by login/signup.
class AuthFooterLink extends StatelessWidget {
  final String question;
  final String action;
  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(question, style: textTheme.bodySmall),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: const TextStyle(
              fontFamily: AppTheme.textFamily,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF37E0FF),
            ),
          ),
        ),
      ],
    );
  }
}

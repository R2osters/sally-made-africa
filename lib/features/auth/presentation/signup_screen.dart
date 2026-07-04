import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'auth_shell.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _nameError;
  String? _emailError;
  bool _loading = false;

  static final _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _nameError = _name.text.trim().isEmpty ? l10n.fieldRequired : null;
      _emailError = _emailRe.hasMatch(_email.text) ? null : l10n.emailInvalid;
    });
    if (_nameError != null || _emailError != null) return;
    setState(() => _loading = true);
    // UI-only: fake a short round-trip, then verify by OTP.
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (mounted) context.go('/auth/otp');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return AuthShell(
      title: l10n.signupTitle,
      subtitle: l10n.signupSub,
      children: [
        AppTextField(
          label: l10n.fullName,
          controller: _name,
          errorText: _nameError,
          prefixIcon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: AppSpacing.lg),
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
        const SizedBox(height: AppSpacing.xl),
        AppButton(
            label: l10n.createAccount, loading: _loading, onPressed: _submit),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.termsNotice,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.xl),
        AuthFooterLink(
          question: l10n.haveAccountQ,
          action: l10n.signIn,
          onTap: () => context.go('/auth/login'),
        ),
      ]
          .animate(interval: 60.ms)
          .fadeIn(duration: 500.ms, curve: const Cubic(.2, .8, .2, 1))
          .moveY(begin: 8, end: 0, duration: 500.ms),
    );
  }
}

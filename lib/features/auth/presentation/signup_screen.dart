import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  bool _loading = false;

  static final _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _validateLive() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _nameError = _name.text.trim().isEmpty ? l10n.authFieldRequired : null;
      _emailError =
          _emailRe.hasMatch(_email.text) ? null : l10n.authEmailInvalid;
      _passwordError =
          _password.text.length >= 8 ? null : l10n.authPasswordTooShort;
    });
  }

  Future<void> _submit() async {
    _validateLive();
    if (_nameError != null || _emailError != null || _passwordError != null) {
      return;
    }
    setState(() => _loading = true);
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
            Text(l10n.authSignupTitle,
                style: textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800))
                .animate()
                .fadeIn(duration: 300.ms)
                .moveY(begin: 12),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              label: l10n.authNameLabel,
              controller: _name,
              errorText: _nameError,
              prefixIcon: Icons.person_outline_rounded,
              onChanged: (_) => _validateLive(),
            ).animate(delay: 60.ms).fadeIn(duration: 300.ms).moveY(begin: 12),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.authEmailLabel,
              controller: _email,
              errorText: _emailError,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => _validateLive(),
            ).animate(delay: 120.ms).fadeIn(duration: 300.ms).moveY(begin: 12),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.authPhoneLabel,
              controller: _phone,
              prefixIcon: Icons.phone_iphone_rounded,
              keyboardType: TextInputType.phone,
            ).animate(delay: 180.ms).fadeIn(duration: 300.ms).moveY(begin: 12),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.authPasswordLabel,
              controller: _password,
              errorText: _passwordError,
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: true,
              onChanged: (_) => _validateLive(),
            ).animate(delay: 240.ms).fadeIn(duration: 300.ms).moveY(begin: 12),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: l10n.authSignupButton,
              loading: _loading,
              onPressed: _submit,
            ).animate(delay: 300.ms).fadeIn(duration: 300.ms),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: l10n.authHaveAccount,
              variant: AppButtonVariant.ghost,
              onPressed: () => context.go('/auth/login'),
            ),
          ],
        ),
      ),
    );
  }
}

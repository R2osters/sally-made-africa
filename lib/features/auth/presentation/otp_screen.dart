import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../profile/data/profile_mock.dart';
import 'auth_shell.dart';

/// OTP verification — 4 boxes, masked phone, resend countdown.
/// UI-only: Verify goes straight to /home.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const _boxCount = 4;
  final _controllers =
      List.generate(_boxCount, (_) => TextEditingController());
  final _nodes = List.generate(_boxCount, (_) => FocusNode());
  Timer? _timer;
  int _secondsLeft = 24;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) t.cancel();
      setState(() => _secondsLeft = (_secondsLeft - 1).clamp(0, 60));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onDigit(int index, String value) {
    if (value.isNotEmpty && index < _boxCount - 1) {
      _nodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);
    final time =
        '00:${_secondsLeft.toString().padLeft(2, '0')}';

    return AuthShell(
      title: l10n.otpTitle,
      subtitle: '${l10n.otpSub} ${ProfileMock.otpMaskedPhone}',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < _boxCount; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.md),
              SizedBox(
                width: 62,
                height: 64,
                child: TextField(
                  controller: _controllers[i],
                  focusNode: _nodes[i],
                  onChanged: (v) => _onDigit(i, v),
                  maxLength: 1,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: AppTheme.display(size: 26, color: c.text),
                  decoration: const InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppButton(label: l10n.verify, onPressed: () => context.go('/home')),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Text(
            l10n.resendIn(time),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: c.faint),
          ),
        ),
      ]
          .animate(interval: 60.ms)
          .fadeIn(duration: 500.ms, curve: const Cubic(.2, .8, .2, 1))
          .moveY(begin: 8, end: 0, duration: 500.ms),
    );
  }
}

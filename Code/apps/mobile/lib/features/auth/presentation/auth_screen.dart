import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/features/auth/application/auth_flow_notifier.dart';
import 'package:sanaya/features/auth/application/auth_flow_state.dart';
import 'package:sanaya/features/auth/presentation/widgets/otp_step.dart';
import 'package:sanaya/features/auth/presentation/widgets/phone_entry_step.dart';
import 'package:sanaya/features/auth/presentation/widgets/role_selection_step.dart';

/// Parcours d'authentification OTP (FM-05, issue #34) : rôle → téléphone →
/// OTP → session persistée. Pilote `authFlowProvider` (FM-05b) ; l'écran ne
/// fait qu'afficher l'état et compter les tentatives de soumission pour
/// réinitialiser le champ OTP (voir `OtpStep`).
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  int _otpAttemptCount = 0;

  String? _errorMessage(Translations t, String? errorCode) {
    return switch (errorCode) {
      'OTP_INVALID' => t.auth.errorOtpInvalid,
      'OTP_EXPIRED' => t.auth.errorOtpExpired,
      'OTP_TOO_MANY_ATTEMPTS' => t.auth.errorOtpTooManyAttempts,
      'RATE_LIMIT_EXCEEDED' => t.auth.errorRateLimitExceeded,
      'VALIDATION_ERROR' => t.auth.errorValidation,
      null => null,
      _ => t.auth.errorGeneric,
    };
  }

  Future<void> _submitOtp(String code) async {
    setState(() => _otpAttemptCount++);
    await ref.read(authFlowProvider.notifier).submitOtp(code);
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(translationsProvider);
    final state = ref.watch(authFlowProvider);
    final notifier = ref.read(authFlowProvider.notifier);
    final errorMessage = _errorMessage(t, state.errorCode);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: state.step == AuthStep.role
          ? null
          : AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: state.step == AuthStep.phone
                    ? notifier.backToRole
                    : notifier.backToPhone,
              ),
            ),
      body: SafeArea(
        child: switch (state.step) {
          AuthStep.role => RoleSelectionStep(onSelect: notifier.selectRole),
          AuthStep.phone => PhoneEntryStep(
            translations: t,
            isSubmitting: state.isSubmitting,
            errorMessage: errorMessage,
            onSubmit: notifier.submitPhone,
          ),
          AuthStep.otp => OtpStep(
            translations: t,
            phone: state.phone ?? '',
            isSubmitting: state.isSubmitting,
            errorMessage: errorMessage,
            attemptsRemaining: state.attemptsRemaining,
            canResend: state.canResendOtp,
            resendCountdownSeconds: state.resendCountdownSeconds,
            attemptCount: _otpAttemptCount,
            onSubmit: _submitOtp,
            onResend: notifier.resendOtp,
          ),
        },
      ),
    );
  }
}

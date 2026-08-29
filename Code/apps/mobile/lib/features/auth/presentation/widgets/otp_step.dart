import 'dart:async';

import 'package:flutter/material.dart';

import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/features/auth/presentation/widgets/otp_code_field.dart';

/// Troisième écran du parcours FM-05 : saisie du code à 6 chiffres. Le champ
/// se réinitialise après chaque tentative (voir la [Key] passée à
/// [OtpCodeField]) — [attemptCount] change à chaque appel de [onSubmit].
class OtpStep extends StatefulWidget {
  const OtpStep({
    required this.translations,
    required this.phone,
    required this.isSubmitting,
    required this.errorMessage,
    required this.attemptsRemaining,
    required this.canResend,
    required this.resendCountdownSeconds,
    required this.attemptCount,
    required this.onSubmit,
    required this.onResend,
    super.key,
  });

  final Translations translations;
  final String phone;
  final bool isSubmitting;
  final String? errorMessage;
  final int? attemptsRemaining;
  final bool canResend;
  final int resendCountdownSeconds;
  final int attemptCount;
  final ValueChanged<String> onSubmit;
  final VoidCallback onResend;

  @override
  State<OtpStep> createState() => _OtpStepState();
}

class _OtpStepState extends State<OtpStep> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    // Rafraîchit l'affichage du compte à rebours chaque seconde. La valeur
    // de vérité reste `otpResendAvailableAt` dans `AuthFlowState` (Riverpod)
    // — ce timer ne fait que forcer un rebuild, il peut être recréé sans
    // perte de correction (ex. après une rotation d'écran).
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.translations;
    final colors = context.colors;
    final hasError = widget.errorMessage != null;

    return Padding(
      padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.auth.otpTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            t.auth.otpSubtitle.replaceAll('{phone}', widget.phone),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),
          OtpCodeField(
            key: ValueKey(widget.attemptCount),
            length: 6,
            enabled: !widget.isSubmitting,
            hasError: hasError,
            onCompleted: widget.onSubmit,
          ),
          if (hasError) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.attemptsRemaining != null
                  ? t.auth.otpAttemptsRemaining.replaceAll(
                      '{count}',
                      widget.attemptsRemaining.toString(),
                    )
                  : widget.errorMessage!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colors.destructive),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: AppButton(
              variant: AppButtonVariant.ghost,
              size: AppButtonSize.small,
              label: widget.canResend
                  ? t.auth.otpResend
                  : t.auth.otpResendCountdown.replaceAll(
                      '{seconds}',
                      widget.resendCountdownSeconds.toString(),
                    ),
              onPressed: widget.canResend && !widget.isSubmitting
                  ? widget.onResend
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

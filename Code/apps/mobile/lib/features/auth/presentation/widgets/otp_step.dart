import 'dart:async';

import 'package:flutter/material.dart';

import 'package:sanaya/core/i18n/format.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
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
  String _code = '';

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
  void didUpdateWidget(OtpStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    // `OtpCodeField` se réinitialise (nouvelle Key) à chaque tentative — le
    // code local suivi ici doit repartir à vide avec lui, sinon le bouton
    // Confirmer resterait actif sur un champ redevenu visuellement vide.
    if (widget.attemptCount != oldWidget.attemptCount) {
      _code = '';
    }
  }

  void _submit() {
    if (_code.length != 6) return;
    widget.onSubmit(_code);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.translations;
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final hasError = widget.errorMessage != null;

    return Padding(
      padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.auth.otpTitle,
            style: AppText.h3(locale).copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            t.auth.otpSubtitle.replaceAll('{phone}', widget.phone),
            style: AppText.body(locale).copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),
          OtpCodeField(
            key: ValueKey(widget.attemptCount),
            length: 6,
            enabled: !widget.isSubmitting,
            hasError: hasError,
            onCompleted: widget.onSubmit,
            onChanged: (code) => setState(() => _code = code),
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
              style: AppText.small(locale).copyWith(color: colors.destructive),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: t.auth.otpCta,
            onPressed: !widget.isSubmitting && _code.length == 6
                ? _submit
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: AppButton(
              variant: AppButtonVariant.ghost,
              size: AppButtonSize.small,
              label: widget.canResend
                  ? t.auth.otpResend
                  : t.auth.otpResendCountdown.replaceAll(
                      '{mmss}',
                      formatCountdown(widget.resendCountdownSeconds),
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

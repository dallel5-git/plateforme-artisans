import 'package:flutter/material.dart';

import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_text_field.dart';

/// Deuxième écran du parcours FM-05 : saisie du téléphone tunisien. La
/// normalisation E.164 complète (`+216XXXXXXXX`) reste faite côté serveur
/// (P4) — ce champ ne fait qu'un filtrage de saisie (chiffres uniquement,
/// 8 chiffres locaux après le préfixe `+216` fixe).
class PhoneEntryStep extends StatefulWidget {
  const PhoneEntryStep({
    required this.translations,
    required this.isSubmitting,
    required this.errorMessage,
    required this.onSubmit,
    super.key,
  });

  final Translations translations;
  final bool isSubmitting;
  final String? errorMessage;
  final ValueChanged<String> onSubmit;

  @override
  State<PhoneEntryStep> createState() => _PhoneEntryStepState();
}

class _PhoneEntryStepState extends State<PhoneEntryStep> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      !widget.isSubmitting && _controller.text.trim().length >= 6;

  void _submit() {
    if (!_canSubmit) return;
    widget.onSubmit('+216${_controller.text.trim()}');
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.translations;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.auth.phoneTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(top: AppSpacing.md),
                child: Text(
                  '+216',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppTextField(
                  hintText: t.auth.phoneHint,
                  controller: _controller,
                  keyboardType: TextInputType.phone,
                  errorText: widget.errorMessage,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: t.auth.phoneCta,
            onPressed: _canSubmit ? _submit : null,
          ),
        ],
      ),
    );
  }
}

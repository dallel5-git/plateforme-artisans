import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Case à cocher de consentement légal explicite (loi tunisienne n° 2004-63 /
/// INPDP).
class InpdpConsentCheckbox extends StatelessWidget {
  const InpdpConsentCheckbox({
    required this.value,
    required this.onChanged,
    this.t,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Translations? t;

  Translations _resolveTranslations() => t ?? AppLocale.fr.buildSync();

  void _showInfoDialog(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final tr = _resolveTranslations();
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          backgroundColor: colors.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(AppRadius.lg),
          ),
          title: Row(
            children: [
              Icon(Icons.shield_outlined, color: colors.accent, size: 24),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  tr.verification.inpdpDialogTitle,
                  style: AppText.subtitle(locale).copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            tr.verification.inpdpDialogBody,
            style: AppText.body(locale).copyWith(
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(
                tr.verification.inpdpDialogClose,
                style: AppText.subtitle(locale).copyWith(
                  color: colors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final tr = _resolveTranslations();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: const BorderRadius.all(AppRadius.md),
        border: Border.all(
          color: value ? colors.accent : colors.border,
          width: value ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: value,
                onChanged: (val) => onChanged(val ?? false),
                activeColor: colors.accent,
                checkColor: colors.onAccent,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(!value),
                  child: Text(
                    tr.verification.inpdpConsentLabel,
                    style: AppText.small(locale).copyWith(
                      color: colors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 36, top: AppSpacing.xs),
            child: GestureDetector(
              onTap: () => _showInfoDialog(context),
              child: Text(
                tr.verification.inpdpConsentLink,
                style: AppText.caption(locale).copyWith(
                  color: colors.accent,
                  decoration: TextDecoration.underline,
                  decorationColor: colors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

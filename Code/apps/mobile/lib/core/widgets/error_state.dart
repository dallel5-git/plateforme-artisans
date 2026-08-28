import 'package:flutter/material.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/empty_state.dart';

/// État d'erreur (design-system.html §8) — écran type « Connexion perdue ».
/// Purement présentation, comme [EmptyState] : `icon`/`title`/`message`/
/// `actionLabel` déjà traduits par l'appelant. Icône sur fond
/// `destructiveSubtle` et bouton primaire « Réessayer » : c'est ce qui la
/// distingue visuellement d'un [EmptyState] (fond neutre, bouton
/// secondaire) pour un même écran de données (§10 du design system : 3
/// états obligatoires — loading/empty/error).
class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.actionLabel,
    this.onAction,
  });

  final String icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.s2xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.destructiveSubtle,
              borderRadius: const BorderRadius.all(AppRadius.pill),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            // h3 est le token le plus proche du corps 16px/700 du mockup —
            // même écart que EmptyState/SO-08.
            style: AppText.h3(locale).copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppText.small(locale).copyWith(color: colors.textSecondary),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: actionLabel!,
              onPressed: onAction,
              size: AppButtonSize.small,
            ),
          ],
        ],
      ),
    );
  }
}

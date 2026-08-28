import 'package:flutter/material.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';

/// État vide (design-system.html §8) — écran type « Aucun artisan trouvé ».
/// Purement présentation : `icon`/`title`/`message`/`actionLabel` sont
/// fournis déjà traduits par l'appelant (aucun `String` en dur ici, comme
/// `AppButton`). Bouton secondaire — l'action proposée élargit la
/// recherche, ce n'est pas une reprise (`ErrorState` s'en distingue par un
/// bouton primaire « Réessayer »).
class EmptyState extends StatelessWidget {
  const EmptyState({
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
              color: colors.surfaceSunken,
              borderRadius: const BorderRadius.all(AppRadius.pill),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            // h3 est le token le plus proche du corps 16px/700 du mockup
            // (l'échelle AppText n'a pas de palier à 16px — même écart que
            // SO-08 pour l'élévation).
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
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.small,
            ),
          ],
        ],
      ),
    );
  }
}

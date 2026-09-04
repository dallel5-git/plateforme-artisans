import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// En-tête de progression de l'assistant (FM-34, issue #231) : barre
/// SEGMENTÉE — un segment par étape, pas un pourcentage continu — avec
/// [stepCountLabel] (« Étape N sur total ») à gauche et le libellé de
/// l'étape courante aligné à droite. Remplace l'ancienne barre continue
/// pilotée par `completionScore` (FM-11) : la complétude reste affichée
/// séparément au récapitulatif (`OnboardingSummaryStep`), jamais recalculée
/// ni affichée ici (P3).
class OnboardingProgressHeader extends StatelessWidget {
  const OnboardingProgressHeader({
    required this.stepLabels,
    required this.currentStepIndex,
    required this.stepCountLabel,
    super.key,
  });

  final List<String> stepLabels;
  final int currentStepIndex;

  /// Déjà formaté par l'appelant (`t.onboarding.stepIndicator`, interpolé
  /// avec `{current}`/`{total}`) — ce widget reste indépendant d'i18n, comme
  /// les autres widgets partagés (FM-04/FM-08).
  final String stepCountLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final currentLabel = stepLabels[currentStepIndex];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                stepCountLabel,
                style: AppText.small(locale).copyWith(color: colors.textMuted),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  currentLabel,
                  textAlign: TextAlign.end,
                  style: AppText.small(locale).copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (var i = 0; i < stepLabels.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(AppRadius.pill),
                    child: Container(
                      height: 6,
                      color: i <= currentStepIndex
                          ? colors.accent
                          : colors.border,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Étape courante + barre de complétude — critère d'acceptation FM-11
/// (« la barre de complétude reflète le `completionScore` renvoyé par
/// l'API », jamais recalculée ici, P3).
class OnboardingProgressHeader extends StatelessWidget {
  const OnboardingProgressHeader({
    required this.stepLabels,
    required this.currentStepIndex,
    required this.completionScore,
    super.key,
  });

  final List<String> stepLabels;
  final int currentStepIndex;
  final int completionScore;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

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
              for (var i = 0; i < stepLabels.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    stepLabels[i],
                    textAlign: TextAlign.center,
                    style: AppText.small(locale).copyWith(
                      color: i <= currentStepIndex
                          ? colors.accent
                          : colors.textMuted,
                      fontWeight: i == currentStepIndex
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: const BorderRadius.all(AppRadius.pill),
            child: LinearProgressIndicator(
              value: (completionScore.clamp(0, 100)) / 100,
              minHeight: 6,
              backgroundColor: colors.border,
              valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

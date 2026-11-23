import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/features/onboarding/application/onboarding_state.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';

/// Reconstitue, à partir du profil connu localement, les clés de
/// `calculateCompletionScore`
/// (`packages/core/src/providers/completion-score.ts`)
/// encore insatisfaites — même nommage que le `missingFields` renvoyé par
/// l'API. Ne décide jamais si la publication est autorisée —
/// `OnboardingState.canPublish` (100 % serveur, P3) reste seul juge de ça ;
/// cette liste sert uniquement à expliquer pourquoi, si le serveur refuse.
/// `phoneVerified`/`categories`/`coverageAreas` sont volontairement absents :
/// le premier n'a aucune couche auth (FM-05) pour le connaître côté client,
/// les deux autres sont garantis non vides pour arriver jusqu'ici (chaque
/// étape bloque son bouton Suivant tant que la sélection est vide).
List<String> computeMissingKeys(ProviderMe? profile) {
  if (profile == null) {
    return const ['bio', 'headline', 'yearsExperience', 'contactPhone'];
  }
  return [
    if (profile.bio.length < 50) 'bio',
    if (profile.headline.isEmpty) 'headline',
    if (profile.yearsExperience <= 0) 'yearsExperience',
    if (profile.whatsappPhone.isEmpty && profile.publicPhone.isEmpty)
      'contactPhone',
  ];
}

String missingKeyLabel(Translations t, String key) => switch (key) {
  'bio' => t.onboarding.missingBio,
  'headline' => t.onboarding.missingHeadline,
  'yearsExperience' => t.onboarding.missingYearsExperience,
  'contactPhone' => t.onboarding.missingContactPhone,
  'categories' => t.onboarding.missingCategories,
  'coverageAreas' => t.onboarding.missingCoverageAreas,
  'photos' => t.onboarding.missingPhotos,
  _ => key,
};

OnboardingStep missingKeyStep(String key) => switch (key) {
  'bio' ||
  'headline' ||
  'yearsExperience' ||
  'contactPhone' => OnboardingStep.profile,
  'categories' => OnboardingStep.categories,
  'coverageAreas' => OnboardingStep.zones,
  'photos' => OnboardingStep.photos,
  _ => OnboardingStep.profile,
};

String missingKeyStepName(Translations t, String key) => switch (key) {
  'bio' ||
  'headline' ||
  'yearsExperience' ||
  'contactPhone' => t.onboarding.stepProfile,
  'categories' => t.onboarding.stepCategories,
  'coverageAreas' => t.onboarding.stepZones,
  'photos' => t.onboarding.stepPhotos,
  _ => t.onboarding.stepProfile,
};

IconData missingKeyIcon(String key) => switch (key) {
  'bio' => Icons.description_outlined,
  'headline' => Icons.badge_outlined,
  'yearsExperience' => Icons.work_history_outlined,
  'contactPhone' => Icons.phone_outlined,
  'categories' => Icons.category_outlined,
  'coverageAreas' => Icons.location_on_outlined,
  'photos' => Icons.photo_library_outlined,
  _ => Icons.edit_outlined,
};

Color completionScoreColor(AppColors colors, int score) {
  if (score < 40) return colors.destructive;
  if (score < 60) return colors.amber;
  return colors.verified;
}

String completionScoreStatusText(Translations t, int score) {
  if (score < 40) return t.onboarding.summaryScoreCritical;
  if (score < 60) return t.onboarding.summaryScoreWarning;
  return t.onboarding.summaryScoreSuccess;
}

class OnboardingSummaryStep extends ConsumerWidget {
  const OnboardingSummaryStep({
    required this.profile,
    required this.completionScore,
    required this.canPublish,
    required this.isSaving,
    required this.errorMessage,
    required this.published,
    required this.onPublish,
    this.onNavigateToStep,
    super.key,
  });

  final ProviderMe? profile;
  final int completionScore;
  final bool canPublish;
  final bool isSaving;
  final String? errorMessage;
  final bool published;

  /// Reçoit les clés manquantes calculées ici (source unique), à relayer
  /// telles quelles à `OnboardingNotifier.publishProfile`.
  final ValueChanged<List<String>> onPublish;

  /// Navigation directe vers l'étape concernée par le champ manquant (MOB-028).
  final ValueChanged<OnboardingStep>? onNavigateToStep;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final locale = Localizations.localeOf(context);
    final colors = context.colors;
    final missingKeys = computeMissingKeys(profile);
    final scoreColor = completionScoreColor(colors, completionScore);
    final scoreStatus = completionScoreStatusText(t, completionScore);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(t.onboarding.summaryTitle, style: AppText.h3(locale)),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      t.onboarding.summaryCompletionLabel.replaceAll(
                        '{score}',
                        '$completionScore',
                      ),
                      style: AppText.bodyStrong(
                        locale,
                      ).copyWith(color: colors.textPrimary),
                    ),
                  ),
                  Text(
                    '$completionScore %',
                    style: AppText.h3(locale).copyWith(
                      color: scoreColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: const BorderRadius.all(AppRadius.pill),
                child: LinearProgressIndicator(
                  value: (completionScore.clamp(0, 100)) / 100.0,
                  minHeight: 8,
                  color: scoreColor,
                  backgroundColor: colors.surfaceSunken,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                scoreStatus,
                style: AppText.caption(locale).copyWith(
                  color: scoreColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (!canPublish && missingKeys.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            t.onboarding.summaryMissingTitle,
            style: AppText.bodyStrong(
              locale,
            ).copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final key in missingKeys) ...[
            Material(
              color: colors.surface,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: colors.border),
                borderRadius: const BorderRadius.all(AppRadius.md),
              ),
              child: InkWell(
                onTap: onNavigateToStep != null
                    ? () => onNavigateToStep!(missingKeyStep(key))
                    : null,
                borderRadius: const BorderRadius.all(AppRadius.md),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm + 4,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xs + 2),
                        decoration: BoxDecoration(
                          color: colors.surfaceSunken,
                          borderRadius: const BorderRadius.all(AppRadius.sm),
                        ),
                        child: Icon(
                          missingKeyIcon(key),
                          size: 20,
                          color: colors.accent,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              missingKeyLabel(t, key),
                              style: AppText.bodyStrong(locale).copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              t.onboarding.missingActionHint.replaceAll(
                                '{step}',
                                missingKeyStepName(t, key),
                              ),
                              style: AppText.small(locale).copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: colors.textMuted,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs + 2),
          ],
        ],
        if (published) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            t.onboarding.summaryPublished,
            style: AppText.bodyStrong(locale).copyWith(color: colors.accent),
          ),
        ],
        if (errorMessage != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            errorMessage!,
            style: AppText.small(locale).copyWith(color: colors.destructive),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          label: t.onboarding.summaryPublish,
          onPressed: isSaving || published
              ? null
              : () => onPublish(missingKeys),
        ),
      ],
    );
  }
}

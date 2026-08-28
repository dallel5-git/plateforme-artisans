import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';

/// Reconstitue, à partir du profil connu localement, les clés de
/// `calculateCompletionScore` (`packages/core/src/providers/completion-score.ts`)
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
  _ => key,
};

class OnboardingSummaryStep extends ConsumerWidget {
  const OnboardingSummaryStep({
    required this.profile,
    required this.completionScore,
    required this.canPublish,
    required this.isSaving,
    required this.errorMessage,
    required this.published,
    required this.onPublish,
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final locale = Localizations.localeOf(context);
    final colors = context.colors;
    final missingKeys = computeMissingKeys(profile);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(t.onboarding.summaryTitle, style: AppText.h3(locale)),
        const SizedBox(height: AppSpacing.md),
        Text(
          t.onboarding.summaryCompletionLabel.replaceAll(
            '{score}',
            '$completionScore',
          ),
          style: AppText.bodyStrong(
            locale,
          ).copyWith(color: colors.textPrimary),
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
          for (final key in missingKeys)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(
                '• ${missingKeyLabel(t, key)}',
                style: AppText.body(
                  locale,
                ).copyWith(color: colors.textSecondary),
              ),
            ),
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

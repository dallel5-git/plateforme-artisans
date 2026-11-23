import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';
import 'package:sanaya/features/onboarding/application/onboarding_providers.dart';
import 'package:sanaya/features/onboarding/domain/portfolio_upload_task.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_categories_step.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_photos_step.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_profile_step.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_progress_header.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_summary_step.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_zones_step.dart';

/// Assistant d'onboarding artisan (FM-11, issue #40) : profil → catégories
/// → zones → récapitulatif/publication. Pilote `onboardingProvider`
/// (FM-11b) ; ne recalcule jamais `completionScore` ni la décision de
/// publication elle-même (P3) — uniquement l'affichage.
///
/// Mémoire locale des sélections catégories/zones : `OnboardingNotifier`
/// ne conserve que `completionScore` après chaque étape (reprise
/// session-memory, cf. sa doc), pas les sélections elles-mêmes. Cet écran
/// les retient localement pour qu'un retour en arrière (`previousStep`)
/// réaffiche ce qui a déjà été choisi plutôt qu'un formulaire vide.
///
/// Reprise après fermeture de l'app (FM-36) : `resumeSession()` appelée une
/// seule fois au montage, un skeleton s'affiche pendant l'appel réseau.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  Map<String, bool> _categorySelection = const {};
  Set<String> _zoneSelection = const {};
  List<PortfolioUploadTask> _initialPortfolioTasks = const [];
  bool _published = false;
  bool _resuming = true;

  @override
  void initState() {
    super.initState();
    unawaited(_resume());
  }

  Future<void> _resume() async {
    await ref.read(onboardingProvider.notifier).resumeSession();
    if (mounted) {
      final state = ref.read(onboardingProvider);
      final profile = state.profile;
      if (profile != null) {
        final catMap = {
          for (final c in profile.categories) c.categoryId: c.isPrimary,
        };
        if (catMap.isNotEmpty && !catMap.containsValue(true)) {
          catMap[catMap.keys.first] = true;
        }
        setState(() {
          _categorySelection = catMap;
          _zoneSelection = {
            for (final a in profile.coverageAreas) a.governorateId,
          };
          _initialPortfolioTasks = [
            for (final item in profile.portfolio)
              PortfolioUploadTask(
                localId: item.id,
                phase: PortfolioUploadPhase.done,
                portfolioItemId: item.id,
                mediaId: item.mediaId,
              ),
          ];
          _resuming = false;
        });
      } else {
        setState(() => _resuming = false);
      }
    }
  }

  String? _errorMessage(
    Translations t,
    String? errorCode,
    Map<String, dynamic>? errorDetails,
  ) {
    // FM-34b : un plafond dépassé malgré le contrôle client (désynchro
    // multi-session) remonte `VALIDATION_ERROR` + `details.limit` — priorité
    // sur les messages génériques ci-dessous.
    if (errorCode == 'VALIDATION_ERROR') {
      final limit = errorDetails?['limit'];
      if (limit != null) {
        return t.errors.validationLimit.replaceAll('{limit}', '$limit');
      }
    }
    return switch (errorCode) {
      'ONBOARDING_PROFILE_SAVE_FAILED' => t.onboarding.profileSaveError,
      'ONBOARDING_CATEGORIES_SAVE_FAILED' => t.onboarding.categoriesSaveError,
      'ONBOARDING_ZONES_SAVE_FAILED' => t.onboarding.zonesSaveError,
      'ONBOARDING_PUBLISH_FAILED' => t.onboarding.summaryPublishError,
      _ => null,
    };
  }

  Future<void> _submitProfile(ProfileStepValues values) async {
    final notifier = ref.read(onboardingProvider.notifier);
    final request = V1ProvidersMePostRequest(
      (b) => b
        ..businessName = values.businessName
        ..baseGovernorateId = values.baseGovernorateId
        ..headline = values.headline
        ..bio = values.bio
        ..yearsExperience = values.yearsExperience
        ..whatsappPhone = values.whatsappPhone
        ..publicPhone = values.publicPhone,
    );
    try {
      await notifier.saveProfile(request);
    } on Object {
      // Déjà reflété dans `state.errorCode` — rien de plus à faire ici.
    }
  }

  Future<void> _submitCategories(Map<String, bool> selection) async {
    setState(() => _categorySelection = selection);
    final notifier = ref.read(onboardingProvider.notifier);
    final request = V1ProvidersMeCategoriesPutRequest(
      (b) => b.categories.addAll(
        selection.entries.map(
          (entry) => V1ProvidersMeCategoriesPutRequestCategoriesInner(
            (cb) => cb
              ..categoryId = entry.key
              ..isPrimary = entry.value,
          ),
        ),
      ),
    );
    try {
      await notifier.saveCategories(request);
    } on Object {
      // Idem — géré via `state.errorCode`.
    }
  }

  Future<void> _submitZones(Set<String> selection) async {
    setState(() => _zoneSelection = selection);
    final notifier = ref.read(onboardingProvider.notifier);
    final request = V1ProvidersMeCoverageAreasPutRequest(
      (b) => b.coverageAreas.addAll(
        selection.map(
          (governorateId) =>
              V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner(
                (cb) => cb.governorateId = governorateId,
              ),
        ),
      ),
    );
    try {
      await notifier.saveCoverageAreas(request);
    } on Object {
      // Idem — géré via `state.errorCode`.
    }
  }

  Future<void> _publish(List<String> missingKeys) async {
    final notifier = ref.read(onboardingProvider.notifier);
    try {
      await notifier.publishProfile(missingKeys);
      // `publishProfile` no-op (score < 60) laisse `profile` inchangé — ne
      // marque publié que si le PATCH a effectivement abouti.
      final publishedStatus = ref
          .read(onboardingProvider)
          .profile
          ?.publicationStatus;
      if (mounted &&
          publishedStatus ==
              V1ProvidersMePost200ResponseProviderPublicationStatusEnum
                  .PUBLISHED) {
        setState(() => _published = true);
        // FM-24 : rend le shell pro (dashboard + onglets) atteignable dans le
        // parcours normal.
        ref.read(hasPublishedProfileProvider.notifier).state = true;
        // MOB-029 : écran de célébration chaleureux et passerelle KYC (ADR-002)
        // plutôt que redirection abrupte vers le dashboard.
        context.go('/pro/celebration');
      }
    } on Object {
      // Idem — géré via `state.errorCode`.
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(translationsProvider);
    final state = ref.watch(onboardingProvider);
    final errorMessage = _errorMessage(t, state.errorCode, state.errorDetails);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.onboarding.wizardTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (state.isFirstStep) {
              context.go('/client');
            } else {
              ref.read(onboardingProvider.notifier).previousStep();
            }
          },
        ),
      ),
      body: _resuming
          ? const _OnboardingResumingSkeleton()
          : Column(
              children: [
                OnboardingProgressHeader(
                  stepLabels: [
                    t.onboarding.stepProfile,
                    t.onboarding.stepCategories,
                    t.onboarding.stepZones,
                    t.onboarding.stepPhotos,
                    t.onboarding.stepSummary,
                  ],
                  currentStepIndex: state.currentStepIndex,
                  stepCountLabel: t.onboarding.stepIndicator
                      .replaceAll(
                        '{current}',
                        '${state.currentStepIndex + 1}',
                      )
                      .replaceAll('{total}', '${OnboardingStep.values.length}'),
                ),
                Expanded(
                  child: switch (state.currentStep) {
                    OnboardingStep.profile => OnboardingProfileStep(
                      initialProfile: state.profile,
                      isSaving: state.isSaving,
                      errorMessage: errorMessage,
                      onSubmit: _submitProfile,
                    ),
                    OnboardingStep.categories => OnboardingCategoriesStep(
                      initialSelection: _categorySelection,
                      isSaving: state.isSaving,
                      errorMessage: errorMessage,
                      onSubmit: _submitCategories,
                    ),
                    OnboardingStep.zones => OnboardingZonesStep(
                      initialSelection: _zoneSelection,
                      isSaving: state.isSaving,
                      errorMessage: errorMessage,
                      onSubmit: _submitZones,
                    ),
                    OnboardingStep.photos => OnboardingPhotosStep(
                      initialItems: _initialPortfolioTasks,
                      isSaving: state.isSaving,
                      errorMessage: errorMessage,
                      onSubmit: () => ref
                          .read(onboardingProvider.notifier)
                          .advanceFromPhotos(),
                    ),
                    OnboardingStep.summary => OnboardingSummaryStep(
                      profile: state.profile,
                      completionScore: state.completionScore,
                      canPublish: state.canPublish,
                      isSaving: state.isSaving,
                      errorMessage: errorMessage,
                      published: _published,
                      onPublish: _publish,
                      onNavigateToStep: (step) =>
                          ref.read(onboardingProvider.notifier).goToStep(step),
                    ),
                  },
                ),
              ],
            ),
    );
  }
}

/// Silhouette affichée pendant `_resume()` (FM-36) — remplace le formulaire
/// le temps de savoir si un profil existant doit préremplir l'étape 1.
class _OnboardingResumingSkeleton extends StatelessWidget {
  const _OnboardingResumingSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSkeleton(height: 24),
          SizedBox(height: AppSpacing.xl),
          AppSkeleton(height: 56),
          SizedBox(height: AppSpacing.md),
          AppSkeleton(height: 56),
          SizedBox(height: AppSpacing.md),
          AppSkeleton(height: 56),
        ],
      ),
    );
  }
}

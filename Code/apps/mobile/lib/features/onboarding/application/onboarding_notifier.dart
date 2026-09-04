import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/onboarding/application/onboarding_repository_provider.dart';
import 'package:sanaya/features/onboarding/application/onboarding_state.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';

/// Gère l'état complet de l'assistant d'onboarding artisan (FM-11).
///
/// Architecture :
/// - `build()` → état initial synchrone (pas d'appel réseau au démarrage)
/// - `saveProfile()` → POST ou PATCH selon `state.profile == null`
/// - `saveCategories()` / `saveCoverageAreas()` → PUT
/// - `publishProfile()` → PATCH publicationStatus=PUBLISHED (score ≥ 60)
/// - `previousStep()` → navigation arrière sans appel réseau
///
/// `completionScore` : toujours celui renvoyé par l'API (P3 CLAUDE.md).
/// Reprise après fermeture de l'app : `GET /providers/me` (BE-44) — câblage laissé à FM-36.
class OnboardingNotifier extends AutoDisposeNotifier<OnboardingState> {
  @override
  OnboardingState build() => OnboardingState.initial;

  OnboardingRepository get _repo => ref.read(onboardingRepositoryProvider);

  // ---------------------------------------------------------------------------
  // saveProfile (étape 1 — profil)
  // ---------------------------------------------------------------------------

  /// POST si `state.profile == null`, PATCH sinon.
  Future<void> saveProfile(V1ProvidersMePostRequest body) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final ProviderMe updated;
      if (state.profile == null) {
        final result = await _repo.createProfile(body);
        updated = result.provider;
      } else {
        // FM-11c : la version d'origine ne recopiait que `businessName` —
        // un retour à l'étape profil pour corriger bio/headline/etc.
        // perdait silencieusement ces champs au PATCH.
        final patchBody = V1ProvidersMePatchRequest(
          (b) => b
            ..businessName = body.businessName
            ..headline = body.headline
            ..bio = body.bio
            ..yearsExperience = body.yearsExperience
            ..whatsappPhone = body.whatsappPhone
            ..publicPhone = body.publicPhone,
        );
        updated = await _repo.updateProfile(patchBody);
      }
      state = state.copyWith(
        profile: updated,
        completionScore: updated.completionScore,
        isSaving: false,
        currentStep: OnboardingStep.categories,
      );
    } on Object {
      state = state.copyWith(
        isSaving: false,
        errorCode: 'ONBOARDING_PROFILE_SAVE_FAILED',
      );
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // saveCategories (étape 2)
  // ---------------------------------------------------------------------------

  Future<void> saveCategories(
    V1ProvidersMeCategoriesPutRequest body,
  ) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final result = await _repo.setCategories(body);
      state = state.copyWith(
        completionScore: result.completionScore,
        isSaving: false,
        currentStep: OnboardingStep.zones,
      );
    } on SanayaApiException catch (e) {
      // FM-34b : le plafond catégories (3, plan FREE) est déjà appliqué
      // côté UI (OnboardingCategoriesStep) — cette branche ne se déclenche
      // qu'en cas de désynchronisation (ex. plusieurs sessions), d'où le
      // besoin de remonter `details.limit` plutôt qu'un message générique.
      state = state.copyWith(
        isSaving: false,
        errorCode: e.code == 'VALIDATION_ERROR'
            ? e.code
            : 'ONBOARDING_CATEGORIES_SAVE_FAILED',
        errorDetails: e.details,
      );
      rethrow;
    } on Object {
      state = state.copyWith(
        isSaving: false,
        errorCode: 'ONBOARDING_CATEGORIES_SAVE_FAILED',
      );
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // saveCoverageAreas (étape 3)
  // ---------------------------------------------------------------------------

  Future<void> saveCoverageAreas(
    V1ProvidersMeCoverageAreasPutRequest body,
  ) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final result = await _repo.setCoverageAreas(body);
      state = state.copyWith(
        completionScore: result.completionScore,
        isSaving: false,
        currentStep: OnboardingStep.summary,
      );
    } on SanayaApiException catch (e) {
      // FM-34b : même remarque que saveCategories — plafond (1 gouvernorat)
      // déjà appliqué côté UI, cette branche couvre la désynchronisation.
      state = state.copyWith(
        isSaving: false,
        errorCode: e.code == 'VALIDATION_ERROR'
            ? e.code
            : 'ONBOARDING_ZONES_SAVE_FAILED',
        errorDetails: e.details,
      );
      rethrow;
    } on Object {
      state = state.copyWith(
        isSaving: false,
        errorCode: 'ONBOARDING_ZONES_SAVE_FAILED',
      );
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // publishProfile (récapitulatif)
  // ---------------------------------------------------------------------------

  /// Bloqué client-side si `completionScore < 60`.
  Future<void> publishProfile(List<String> missingFields) async {
    if (!state.canPublish) {
      state = state.copyWith(missingFields: missingFields);
      return;
    }
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final patchBody = V1ProvidersMePatchRequest(
        (b) => b
          ..publicationStatus =
              V1ProvidersMePatchRequestPublicationStatusEnum.PUBLISHED,
      );
      final updated = await _repo.updateProfile(patchBody);
      state = state.copyWith(
        profile: updated,
        completionScore: updated.completionScore,
        isSaving: false,
        missingFields: [],
      );
    } on Object {
      state = state.copyWith(
        isSaving: false,
        errorCode: 'ONBOARDING_PUBLISH_FAILED',
      );
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // previousStep
  // ---------------------------------------------------------------------------

  void previousStep() {
    if (state.isFirstStep) return;
    final idx = state.currentStepIndex - 1;
    state = state.copyWith(
      currentStep: OnboardingStep.values[idx],
      clearError: true,
    );
  }
}

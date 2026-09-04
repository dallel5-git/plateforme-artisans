import 'package:sanaya/features/onboarding/data/onboarding_repository.dart'
    show ProviderMe;

// ---------------------------------------------------------------------------
// Étapes de l'assistant
// ---------------------------------------------------------------------------

/// Les 4 étapes de l'assistant d'onboarding dans l'ordre de présentation.
enum OnboardingStep { profile, categories, zones, summary }

// ---------------------------------------------------------------------------
// État immuable de l'assistant
// ---------------------------------------------------------------------------

/// État complet de l'assistant d'onboarding.
///
/// Immuable : toute modification passe par [copyWith]. Pas de `setState`
/// pour de l'état serveur (règle Dart CLAUDE.md §4.2).
class OnboardingState {
  const OnboardingState({
    required this.currentStep,
    required this.completionScore,
    required this.missingFields,
    required this.isSaving,
    this.profile,
    this.errorCode,
    this.errorDetails,
  });

  /// Profil artisan renvoyé par l'API. `null` tant que `createProfile`
  /// n'a pas été appelé avec succès (premier POST /providers/me).
  final ProviderMe? profile;

  /// Étape courante affichée à l'écran.
  final OnboardingStep currentStep;

  /// Score de complétude 0-100 calculé côté API (P3 — jamais recalculé
  /// ici). Mis à jour après chaque sauvegarde réussie.
  final int completionScore;

  /// Liste des champs manquants renvoyée par l'API quand
  /// `completionScore < 60` et qu'une publication est tentée.
  final List<String> missingFields;

  /// `true` pendant un appel réseau en cours (disable le bouton Suivant).
  final bool isSaving;

  /// Code d'erreur typé (packages/constants/error-codes) positionné après
  /// un appel API échoué. `null` = pas d'erreur en cours.
  final String? errorCode;

  /// `details` du `SanayaApiException` correspondant (FM-34b) — porte par
  /// ex. `{limit: 3}` pour un `VALIDATION_ERROR` de plafond dépassé.
  /// `null` si l'erreur n'a pas de détails ou si `errorCode` est `null`.
  final Map<String, dynamic>? errorDetails;

  // ---------------------------------------------------------------------------
  // Dérivés
  // ---------------------------------------------------------------------------

  /// `true` si l'artisan peut publier son profil (seuil 60 %).
  bool get canPublish => completionScore >= 60;

  /// `true` si c'est la dernière étape (récapitulatif).
  bool get isLastStep => currentStep == OnboardingStep.summary;

  /// `true` si c'est la première étape (profil).
  bool get isFirstStep => currentStep == OnboardingStep.profile;

  /// Index 0-based de l'étape courante (utile pour `StepIndicator`).
  int get currentStepIndex => OnboardingStep.values.indexOf(currentStep);

  /// Nombre total d'étapes.
  static int get totalSteps => OnboardingStep.values.length;

  // ---------------------------------------------------------------------------
  // Copie immuable
  // ---------------------------------------------------------------------------

  OnboardingState copyWith({
    ProviderMe? profile,
    OnboardingStep? currentStep,
    int? completionScore,
    List<String>? missingFields,
    bool? isSaving,
    String? errorCode,
    Map<String, dynamic>? errorDetails,
    bool clearError = false,
  }) {
    return OnboardingState(
      profile: profile ?? this.profile,
      currentStep: currentStep ?? this.currentStep,
      completionScore: completionScore ?? this.completionScore,
      missingFields: missingFields ?? this.missingFields,
      isSaving: isSaving ?? this.isSaving,
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      errorDetails: clearError ? null : (errorDetails ?? this.errorDetails),
    );
  }

  // ---------------------------------------------------------------------------
  // État initial
  // ---------------------------------------------------------------------------

  /// Point de départ de l'assistant : score 0, étape profil, pas d'erreur.
  static const initial = OnboardingState(
    currentStep: OnboardingStep.profile,
    completionScore: 0,
    missingFields: [],
    isSaving: false,
  );
}

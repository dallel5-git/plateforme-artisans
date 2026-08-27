import 'package:sanaya/core/api/generated/api.dart';

// Alias de lisibilité — mêmes types que ceux générés par openapi-generator,
// pas de redéclaration d'un type de domaine (P4 CLAUDE.md). Même patron que
// ProviderProfileRepository (FM-08a).
typedef OnboardingProfile = V1ProvidersMePost200ResponseProvider;
typedef CreateProfileResult = V1ProvidersMePost200Response;
typedef CategoriesResult = V1ProvidersMeCategoriesPut200Response;
typedef CoverageAreasResult = V1ProvidersMeCoverageAreasPut200Response;
typedef CategoryInput = V1ProvidersMeCategoriesPutRequestCategoriesInner;
typedef CoverageAreaInput =
    V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner;
typedef SpokenLanguage = V1ProvidersMePostRequestSpokenLanguagesEnum;
typedef AvailabilityStatus = V1ProvidersMePatchRequestAvailabilityStatusEnum;
typedef PublicationStatus = V1ProvidersMePatchRequestPublicationStatusEnum;

/// Un 403 `PROVIDER_PROFILE_INCOMPLETE` — publication refusée sous
/// `MIN_PUBLICATION_COMPLETION_SCORE` (60 %,
/// `packages/core/src/providers/completion-score.ts`). Distingue ce cas
/// précis d'une [ForbiddenException] générique pour que l'appelant n'ait
/// pas à relire `details` lui-même à chaque site d'appel.
class PublicationBlocked {
  const PublicationBlocked({
    required this.completionScore,
    required this.missingFields,
  });

  final int completionScore;
  final List<String> missingFields;

  /// `null` si [error] n'est pas ce blocage précis — tout le reste doit
  /// continuer à se propager tel quel (401, réseau, 500…).
  static PublicationBlocked? fromException(Object error) {
    if (error is! ForbiddenException ||
        error.code != 'PROVIDER_PROFILE_INCOMPLETE') {
      return null;
    }
    final details = error.details;
    final score = details?['completionScore'];
    final missing = details?['missingFields'];
    return PublicationBlocked(
      completionScore: score is int ? score : 0,
      missingFields: missing is List
          ? missing.whereType<String>().toList()
          : const [],
    );
  }
}

/// Accès BE-19 : création/mise à jour du profil artisan authentifié,
/// catégories et zones de couverture. Aucune règle métier ici (P3) — la
/// seule exception est [PublicationBlocked], qui distingue un blocage de
/// publication d'un 403 générique. `unwrapDioErrors` est utilisé ici
/// (contrairement à `ProviderProfileRepository`, purement lecture) parce que
/// l'appelant a besoin d'exceptions typées, pas seulement d'un état
/// loading/erreur générique.
class OnboardingRepository {
  OnboardingRepository(this._api);

  final DefaultApi _api;

  /// Crée le profil et promeut l'utilisateur PROVIDER (US-P-01). `provider`
  /// dans le retour ne porte pas encore de catégories/zones — les deux
  /// étapes suivantes du wizard les ajoutent.
  Future<CreateProfileResult> createProfile({
    required String businessName,
    required String baseGovernorateId,
    String? baseDelegationId,
    String? headline,
    String? bio,
    int? yearsExperience,
    String? whatsappPhone,
    String? publicPhone,
    List<SpokenLanguage>? spokenLanguages,
  }) {
    return unwrapDioErrors(() async {
      final response = await _api.v1ProvidersMePost(
        v1ProvidersMePostRequest: V1ProvidersMePostRequest((b) {
          b
            ..businessName = businessName
            ..baseGovernorateId = baseGovernorateId
            ..baseDelegationId = baseDelegationId
            ..headline = headline
            ..bio = bio
            ..yearsExperience = yearsExperience
            ..whatsappPhone = whatsappPhone
            ..publicPhone = publicPhone;
          if (spokenLanguages != null) {
            b.spokenLanguages.addAll(spokenLanguages);
          }
        }),
      );
      return response.data!;
    });
  }

  /// Met à jour le profil ; `publicationStatus: PUBLISHED` sous 60 % lance
  /// [ForbiddenException] — voir [PublicationBlocked.fromException].
  /// `baseGovernorateId`/`baseDelegationId`/`spokenLanguages` ne sont pas
  /// modifiables ici : le contrat réel (`providers.ts`,
  /// `updateProviderMeSchema`) ne les accepte qu'à la création.
  /// `availableAgainAt`/`workingHours` sont
  /// hors périmètre du wizard FM-11 (tableau de bord, pas onboarding) — le
  /// client généré les type d'ailleurs en `BuiltMap<String, JsonObject?>`
  /// plutôt qu'en date/horaires (schéma `z.date()`/`z.unknown()` encore flou
  /// côté `packages/validators/src/provider.ts`), à revisiter quand FM-12 en
  /// aura besoin.
  Future<OnboardingProfile> updateProfile({
    String? businessName,
    String? headline,
    String? bio,
    int? yearsExperience,
    String? whatsappPhone,
    String? publicPhone,
    AvailabilityStatus? availabilityStatus,
    bool? acceptsEmergency,
    PublicationStatus? publicationStatus,
  }) {
    return unwrapDioErrors(() async {
      final response = await _api.v1ProvidersMePatch(
        v1ProvidersMePatchRequest: V1ProvidersMePatchRequest((b) {
          b
            ..businessName = businessName
            ..headline = headline
            ..bio = bio
            ..yearsExperience = yearsExperience
            ..whatsappPhone = whatsappPhone
            ..publicPhone = publicPhone
            ..availabilityStatus = availabilityStatus
            ..acceptsEmergency = acceptsEmergency
            ..publicationStatus = publicationStatus;
        }),
      );
      return response.data!;
    });
  }

  /// Remplace tout le set de catégories (une seule `isPrimary: true`,
  /// limite du plan FREE côté serveur).
  Future<CategoriesResult> replaceCategories(List<CategoryInput> categories) {
    return unwrapDioErrors(() async {
      final response = await _api.v1ProvidersMeCategoriesPut(
        v1ProvidersMeCategoriesPutRequest: V1ProvidersMeCategoriesPutRequest(
          (b) => b.categories.addAll(categories),
        ),
      );
      return response.data!;
    });
  }

  /// Remplace tout le set de zones d'intervention (`delegationId` absent =
  /// tout le gouvernorat, limite du plan FREE côté serveur).
  Future<CoverageAreasResult> replaceCoverageAreas(
    List<CoverageAreaInput> coverageAreas,
  ) {
    return unwrapDioErrors(() async {
      final response = await _api.v1ProvidersMeCoverageAreasPut(
        v1ProvidersMeCoverageAreasPutRequest:
            V1ProvidersMeCoverageAreasPutRequest(
              (b) => b.coverageAreas.addAll(coverageAreas),
            ),
      );
      return response.data!;
    });
  }
}

import 'package:built_value/serializer.dart';
import 'package:sanaya/core/api/generated/api.dart';

// Alias de lisibilité — types générés par openapi-generator, pas de
// redéclaration d'un type de domaine (P4 CLAUDE.md).
typedef ProviderMe = V1ProvidersMePost200ResponseProvider;
typedef CreateProviderResponse = V1ProvidersMePost200Response;
typedef CategoriesResult = V1ProvidersMeCategoriesPut200Response;
typedef CoverageAreasResult = V1ProvidersMeCoverageAreasPut200Response;

/// Accès aux routes d'onboarding artisan (BE-19) :
///   POST  /v1/providers/me       → créer le profil
///   PATCH /v1/providers/me       → mettre à jour le profil
///   PUT   /v1/providers/me/categories
///   PUT   /v1/providers/me/coverage-areas
///
/// Aucune règle métier ici (P3) — simple passage par le client généré.
/// Le `completionScore` est calculé côté API et renvoyé dans chaque réponse.
class OnboardingRepository {
  OnboardingRepository(this._api);

  final DefaultApi _api;

  /// Crée le profil artisan. Promeut l'utilisateur au rôle PROVIDER s'il ne
  /// l'est pas déjà et émet de nouveaux tokens (contrat BE-19).
  /// Retourne la réponse complète (accessToken, refreshToken, provider) afin
  /// que l'appelant puisse rafraîchir les tokens en session.
  Future<CreateProviderResponse> createProfile(
    V1ProvidersMePostRequest body,
  ) async {
    final response = await _api.v1ProvidersMePost(
      v1ProvidersMePostRequest: body,
    );
    return response.data!;
  }

  /// Met à jour le profil artisan. `completionScore` est recalculé à chaque
  /// appel. Si `publicationStatus: PUBLISHED` est envoyé avec un score < 60,
  /// l'API renvoie une erreur métier (422) — l'appelant gère via
  /// DioException → AppException (FM-02c).
  Future<ProviderMe> updateProfile(V1ProvidersMePatchRequest body) async {
    final response = await _api.v1ProvidersMePatch(
      v1ProvidersMePatchRequest: body,
    );
    return _asProviderMe(response.data!);
  }

  /// Remplace le set complet de catégories (une seule `isPrimary: true`,
  /// limite FREE : 3 catégories). `completionScore` recalculé.
  ///
  /// `unwrapDioErrors` (FM-34b) : un dépassement de plafond malgré le
  /// contrôle client (`OnboardingCategoriesStep`) remonte un
  /// `ValidationException` typé (`details.limit`) plutôt qu'un
  /// `DioException` brut, pour que le notifier puisse l'afficher.
  Future<CategoriesResult> setCategories(
    V1ProvidersMeCategoriesPutRequest body,
  ) => unwrapDioErrors(() async {
    final response = await _api.v1ProvidersMeCategoriesPut(
      v1ProvidersMeCategoriesPutRequest: body,
    );
    return response.data!;
  });

  /// Remplace le set complet de zones d'intervention. `delegationId` absent =
  /// tout le gouvernorat. Limite FREE : 1 gouvernorat distinct.
  /// `completionScore` recalculé. Voir [setCategories] pour `unwrapDioErrors`.
  Future<CoverageAreasResult> setCoverageAreas(
    V1ProvidersMeCoverageAreasPutRequest body,
  ) => unwrapDioErrors(() async {
    final response = await _api.v1ProvidersMeCoverageAreasPut(
      v1ProvidersMeCoverageAreasPutRequest: body,
    );
    return response.data!;
  });
}

/// `PATCH` et `GET /providers/me` (BE-44) renvoient toutes deux exactement
/// `providerMeSchema` côté serveur — comme `POST /providers/me` en imbriquant
/// une copie sous `provider`. Mais openapi-generator ne déduplique le type
/// Dart généré qu'entre schémas de réponse racine : `PATCH`/`GET` partagent
/// désormais un même type ([ProviderMe] reste alias sur celui de `POST`, par
/// stabilité pour tout le code déjà écrit contre lui), alors que le `provider`
/// imbriqué de `POST` reste un type distinct. Convertit via les sérialiseurs
/// générés plutôt que de dupliquer la vingtaine de champs à la main (P4
/// CLAUDE.md).
ProviderMe _asProviderMe(V1ProvidersMeGet200Response provider) {
  final json = standardSerializers.serialize(
    provider,
    specifiedType: const FullType(V1ProvidersMeGet200Response),
  );
  return standardSerializers.deserialize(
        json,
        specifiedType: const FullType(ProviderMe),
      )!
      as ProviderMe;
}

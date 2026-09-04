import 'package:dio/dio.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/provider_profile/data/provider_profile_cache.dart';

// Alias de lisibilité — même types que ceux générés par openapi-generator,
// pas de redéclaration d'un type de domaine (P4 CLAUDE.md).
typedef ProviderProfile = V1ProvidersSlugGet200Response;
typedef ProviderReview = V1ProvidersSlugReviewsGet200ResponseItemsInner;
typedef ReviewsPage = V1ProvidersSlugReviewsGet200Response;

/// Accès BE-17 : fiche artisan publique et liste d'avis paginée.
/// Aucune règle métier ici (P3) — simple passage par le client généré.
/// Patron identique à CatalogRepository (FM-06a).
class ProviderProfileRepository {
  ProviderProfileRepository(this._api, {ProviderProfileCache? cache})
    : _cache = cache ?? ProviderProfileCache.withDefaultBox();

  final DefaultApi _api;
  final ProviderProfileCache _cache;

  /// Fiche artisan publique : profil, galerie, offres, zones, agrégat d'avis.
  /// Écrit la fiche en cache disque après chaque succès (FM-28 : « fiches
  /// déjà consultées » consultables en mode avion). Sur échec réseau, sert
  /// la dernière version en cache si elle existe ; sinon relance l'erreur
  /// d'origine — jamais un écran blanc silencieux (P3/P5).
  Future<ProviderProfile> fetchProfile(String slug) async {
    try {
      final profile = (await _api.v1ProvidersSlugGet(slug: slug)).data!;
      await _cache.write(slug, profile);
      return profile;
    } on DioException catch (error, stackTrace) {
      final cached = await _cache.read(slug);
      if (cached != null) return cached;
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  /// Avis paginés par curseur. [cursor] null = première page.
  /// Retourne la page complète (items + nextCursor) pour que le notifier
  /// gère l'accumulation et le curseur suivant.
  Future<ReviewsPage> fetchReviews(
    String slug, {
    String? cursor,
    int limit = 10,
  }) async {
    final response = await _api.v1ProvidersSlugReviewsGet(
      slug: slug,
      cursor: cursor,
      limit: limit,
    );
    return response.data!;
  }
}

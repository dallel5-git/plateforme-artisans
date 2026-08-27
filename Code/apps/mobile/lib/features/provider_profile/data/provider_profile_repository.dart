import 'package:sanaya/core/api/generated/api.dart';

// Alias de lisibilité — même types que ceux générés par openapi-generator,
// pas de redéclaration d'un type de domaine (P4 CLAUDE.md).
typedef ProviderProfile = V1ProvidersSlugGet200Response;
typedef ProviderReview = V1ProvidersSlugReviewsGet200ResponseItemsInner;
typedef ReviewsPage = V1ProvidersSlugReviewsGet200Response;

/// Accès BE-17 : fiche artisan publique et liste d'avis paginée.
/// Aucune règle métier ici (P3) — simple passage par le client généré.
/// Patron identique à CatalogRepository (FM-06a).
class ProviderProfileRepository {
  ProviderProfileRepository(this._api);

  final DefaultApi _api;

  /// Fiche artisan publique : profil, galerie, offres, zones, agrégat d'avis.
  /// Lance une DioException si l'artisan n'existe pas (404).
  Future<ProviderProfile> fetchProfile(String slug) async {
    final response = await _api.v1ProvidersSlugGet(slug: slug);
    return response.data!;
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

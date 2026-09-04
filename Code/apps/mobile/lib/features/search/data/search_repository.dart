import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/search/data/search_filters.dart';

/// Alias de lisibilité — mêmes types que ceux générés par openapi-generator,
/// pas de redéclaration d'un type de domaine (cf. CLAUDE.md racine, P4).
typedef SearchResultsPage = V1ProvidersSearchGet200Response;
typedef SearchResultItem = V1ProvidersSearchGet200ResponseItemsInner;

/// Accès FM-28 : recherche d'artisans par gouvernorat/catégorie/délégation/
/// vérifié/note minimale, pagination par curseur. Aucune règle métier ici
/// (P3) — un simple passage par le client généré ; l'accumulation des pages
/// et le curseur suivant sont gérés par le notifier appelant (FM-28c), même
/// partage des responsabilités que `FavoritesRepository.fetchFavorites`.
class SearchRepository {
  SearchRepository(this._api);

  final DefaultApi _api;

  Future<SearchResultsPage> search(
    SearchFilters filters, {
    String? cursor,
    int limit = 20,
  }) async {
    final response = await _api.v1ProvidersSearchGet(
      governorate: filters.governorateId,
      category: filters.categorySlug,
      delegation: filters.delegationId,
      verified: filters.isVerified == null
          ? null
          : filters.isVerified!
          ? 'true'
          : 'false',
      minRating: filters.minRating,
      cursor: cursor,
      limit: limit,
    );
    return response.data!;
  }
}

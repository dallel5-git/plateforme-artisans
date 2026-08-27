import 'package:sanaya/core/api/generated/api.dart';

/// Alias de lisibilité — types générés depuis OpenAPI (BE-25),
/// pas de redéclaration d'un type de domaine (cf. CLAUDE.md racine, P4).
typedef FavoriteItem = V1FavoritesGet200ResponseItemsInner;
typedef FavoritesResponse = V1FavoritesGet200Response;

/// Repository pour l'accès aux favoris (BE-25, US-C-08).
/// Aucune règle métier en Dart (P3) : délègue directement au client généré.
class FavoritesRepository {
  const FavoritesRepository(this._api);

  final DefaultApi _api;

  /// Récupère la liste paginée par curseur des favoris du client authentifié.
  Future<FavoritesResponse> fetchFavorites({
    String? cursor,
    int limit = 20,
  }) async {
    final response = await _api.v1FavoritesGet(
      cursor: cursor,
      limit: limit,
    );
    return response.data!;
  }

  /// Ajoute un artisan aux favoris (idempotent, BE-25).
  Future<void> addFavorite(String providerId) async {
    await _api.v1FavoritesProviderIdPut(providerId: providerId);
  }

  /// Retire un artisan des favoris (idempotent, 204 No Content, BE-25).
  Future<void> removeFavorite(String providerId) async {
    await _api.v1FavoritesProviderIdDelete(providerId: providerId);
  }
}

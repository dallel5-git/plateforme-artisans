import 'package:sanaya/core/api/generated/api.dart';

// Alias de lisibilité — types générés depuis OpenAPI (BE-22),
// pas de redéclaration d'un type de domaine (cf. CLAUDE.md racine, P4).
typedef CreatedReview = V1ProvidersIdReviewsPost200Response;

/// Repository pour le dépôt d'avis (BE-22, FM-10).
/// Aucune règle métier en Dart (P3) : délègue directement au client généré.
class ReviewsRepository {
  const ReviewsRepository(this._api);

  final DefaultApi _api;

  /// Dépose un avis (note de 1 à 5, commentaire optionnel) pour l'artisan
  /// [providerId].
  ///
  /// L'API vérifie côté serveur l'existence d'un `ContactEvent` éligible
  /// (>12h, <60j). En cas d'absence de contact éligible ou de doublon, l'API
  /// renvoie 403 `REVIEW_REQUIRES_CONTACT`.
  Future<CreatedReview> createReview({
    required String providerId,
    required int rating,
    String? comment,
  }) async {
    final request = V1ProvidersIdReviewsPostRequest((b) {
      b.rating = rating;
      if (comment != null && comment.trim().isNotEmpty) {
        b.comment = comment.trim();
      }
    });

    final response = await unwrapDioErrors(
      () => _api.v1ProvidersIdReviewsPost(
        id: providerId,
        v1ProvidersIdReviewsPostRequest: request,
      ),
    );

    return response.data!;
  }
}

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:sanaya/core/api/generated/api.dart';

typedef PresignedMediaUpload = V1MediaPresignPost200Response;
typedef ProcessedMedia = V1MediaIdProcessPost200Response;
typedef PortfolioItem = V1ProvidersMePortfolioPost200Response;

/// Accès aux routes médias/portfolio (BE-20a→d, issue #232) :
///   POST   /v1/media/presign               → URL PUT pré-signée (~10 min)
///   PUT    (uploadUrl reçue ci-dessus)      → upload direct vers R2, hors
///                                              contrat OpenAPI (P5)
///   POST   /v1/media/{id}/process           → variantes WebP (thumb/card/full)
///   POST   /v1/providers/me/portfolio       → rattache le média au profil
///   DELETE /v1/providers/me/portfolio/{id}  → détache un élément
///
/// Aucune règle métier ici (P3) — simple passage par le client généré, à
/// l'exception du PUT vers l'URL pré-signée : cette requête ne fait pas
/// partie du contrat `openapi.json` (elle vise directement le bucket R2,
/// c'est tout le sens du presign, cf. `apps/api/src/routes/media.ts`), donc
/// pas de méthode Retrofit générée pour elle. Un `Dio` nu et dédié
/// ([_uploadClient]) l'exécute : les intercepteurs de l'app (`AuthInterceptor`
/// notamment) ajouteraient un header `Authorization` qui invaliderait la
/// signature de l'URL.
class PortfolioRepository {
  PortfolioRepository(this._api, {Dio? uploadClient})
    : _uploadClient = uploadClient ?? Dio();

  final DefaultApi _api;
  final Dio _uploadClient;

  /// Crée le `MediaAsset` et obtient l'URL de mise en ligne directe.
  Future<PresignedMediaUpload> presignUpload({
    required String filename,
    required String mimeType,
    required int sizeBytes,
  }) => unwrapDioErrors(() async {
    final response = await _api.v1MediaPresignPost(
      v1MediaPresignPostRequest: V1MediaPresignPostRequest(
        (b) => b
          ..filename = filename
          ..mimeType = mimeType
          ..sizeBytes = sizeBytes,
      ),
    );
    return response.data!;
  });

  /// Téléverse [bytes] (déjà compressés, `PortfolioImageCompressor`)
  /// directement vers [uploadUrl]. Ne passe jamais par [unwrapDioErrors] :
  /// une erreur ici est une `DioException` brute vers un hôte tiers (R2),
  /// sans enveloppe `{error:{code,...}}` Sanaya à déballer.
  Future<void> uploadToPresignedUrl({
    required String uploadUrl,
    required Uint8List bytes,
    required String mimeType,
    ProgressCallback? onSendProgress,
  }) async {
    await _uploadClient.put<void>(
      uploadUrl,
      data: Stream.fromIterable([bytes]),
      options: Options(
        contentType: mimeType,
        headers: {Headers.contentLengthHeader: bytes.length},
      ),
      onSendProgress: onSendProgress,
    );
  }

  /// Déclenche la génération des variantes WebP côté serveur.
  Future<ProcessedMedia> processMedia(String mediaId) =>
      unwrapDioErrors(() async {
        final response = await _api.v1MediaIdProcessPost(id: mediaId);
        return response.data!;
      });

  /// Rattache un média déjà traité au profil (plafond FREE appliqué
  /// serveur — `VALIDATION_ERROR`/`details.limit` si dépassé, P3).
  Future<PortfolioItem> attachToPortfolio({
    required String mediaId,
    String? categoryId,
    String? caption,
  }) => unwrapDioErrors(() async {
    final response = await _api.v1ProvidersMePortfolioPost(
      v1ProvidersMePortfolioPostRequest: V1ProvidersMePortfolioPostRequest(
        (b) => b
          ..mediaId = mediaId
          ..categoryId = categoryId
          ..caption = caption,
      ),
    );
    return response.data!;
  });

  /// Détache un élément déjà rattaché.
  Future<void> deletePortfolioItem(String id) => unwrapDioErrors(() async {
    await _api.v1ProvidersMePortfolioIdDelete(id: id);
  });
}

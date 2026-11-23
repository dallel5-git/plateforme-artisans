import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:sanaya/core/api/generated/api.dart';

typedef KycPresignedUpload = V1ProvidersMeVerificationPresignPost200Response;
typedef KycSubmitResponse = V1ProvidersMeVerificationSubmitPost200Response;
typedef KycStatusResponse = V1ProvidersMeVerificationGet200Response;

/// Accès aux routes de vérification d'identité KYC (BE-30b / MOB-030) :
///   POST /v1/providers/me/verification/presign → URL PUT pré-signée (~10 min) vers `private-kyc`
///   PUT  (uploadUrl reçue ci-dessus)           → upload direct vers R2 privé avec SSE-S3
///   POST /v1/providers/me/verification/submit  → enregistre la demande (hash + cipher) et passe à PENDING
///   GET  /v1/providers/me/verification         → consulte le statut actuel et la dernière demande
///
/// Aucune règle métier ici (P3) — simple passage par le client généré, à
/// l'exception du PUT vers l'URL pré-signée : cette requête ne fait pas
/// partie du contrat `openapi.json` (elle vise directement le bucket R2 privé,
/// hors contrat OpenAPI, cf. P5), donc pas de méthode Retrofit générée pour elle.
/// Un [Dio] nu et dédié ([_uploadClient]) l'exécute pour éviter d'ajouter des headers
/// `Authorization` qui invalideraient la signature de l'URL.
class KycRepository {
  KycRepository(this._api, {Dio? uploadClient})
    : _uploadClient = uploadClient ?? Dio();

  final DefaultApi _api;
  final Dio _uploadClient;

  /// Obtient l'URL pré-signée pour téléverser une face de CIN vers le coffre-fort R2 privé.
  Future<KycPresignedUpload> presignUpload({
    required V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
    documentType,
    required V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum mimeType,
    required int sizeBytes,
  }) => unwrapDioErrors(() async {
    final response = await _api.v1ProvidersMeVerificationPresignPost(
      v1ProvidersMeVerificationPresignPostRequest:
          V1ProvidersMeVerificationPresignPostRequest(
            (b) => b
              ..documentType = documentType
              ..mimeType = mimeType
              ..sizeBytes = sizeBytes,
          ),
    );
    return response.data!;
  });

  /// Téléverse [bytes] directement vers [uploadUrl].
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

  /// Soumet les identifiants et les pièces d'identité rattachées pour instruction.
  Future<KycSubmitResponse> submitVerification({
    required String cinNumber,
    required String fullNameOnId,
    required String cinFrontMediaId,
    required String cinBackMediaId,
  }) => unwrapDioErrors(() async {
    final response = await _api.v1ProvidersMeVerificationSubmitPost(
      v1ProvidersMeVerificationSubmitPostRequest:
          V1ProvidersMeVerificationSubmitPostRequest(
            (b) => b
              ..cinNumber = cinNumber
              ..fullNameOnId = fullNameOnId
              ..cinFrontMediaId = cinFrontMediaId
              ..cinBackMediaId = cinBackMediaId,
          ),
    );
    return response.data!;
  });

  /// Récupère le statut KYC courant de l'artisan connecté et sa dernière demande.
  Future<KycStatusResponse> getVerificationStatus() =>
      unwrapDioErrors(() async {
        final response = await _api.v1ProvidersMeVerificationGet();
        return response.data!;
      });
}

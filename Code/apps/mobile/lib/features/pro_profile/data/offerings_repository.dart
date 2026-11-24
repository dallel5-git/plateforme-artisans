import 'package:sanaya/core/api/generated/api.dart';

typedef MyOffering = V1ProvidersMeOfferingsGet200ResponseInner;
typedef OfferingResponse = V1ProvidersMeOfferingsGet200ResponseInner;

/// Accès aux routes de gestion des prestations et tarifs indicatifs (BE-47 / MOB-022) :
///   GET    /v1/providers/me/offerings       → liste des offres actives
///   POST   /v1/providers/me/offerings       → ajout d'une prestation
///   PATCH  /v1/providers/me/offerings/{id}  → mise à jour tarif / titre
///   DELETE /v1/providers/me/offerings/{id}  → retrait de l'offre
class OfferingsRepository {
  OfferingsRepository(this._api);

  final DefaultApi _api;

  /// Récupère la liste des offres de l'artisan connecté.
  Future<List<MyOffering>> fetchMyOfferings() => unwrapDioErrors(() async {
    final response = await _api.v1ProvidersMeOfferingsGet();
    return response.data?.toList() ?? [];
  });

  /// Ajoute une nouvelle offre au profil.
  Future<OfferingResponse> createOffering(
    V1ProvidersMeOfferingsPostRequest request,
  ) => unwrapDioErrors(() async {
    final response = await _api.v1ProvidersMeOfferingsPost(
      v1ProvidersMeOfferingsPostRequest: request,
    );
    return response.data!;
  });

  /// Met à jour les informations ou tarifs d'une offre existante.
  Future<OfferingResponse> updateOffering(
    String id,
    V1ProvidersMeOfferingsIdPatchRequest request,
  ) => unwrapDioErrors(() async {
    final response = await _api.v1ProvidersMeOfferingsIdPatch(
      id: id,
      v1ProvidersMeOfferingsIdPatchRequest: request,
    );
    return response.data!;
  });

  /// Supprime une offre du profil.
  Future<void> deleteOffering(String id) => unwrapDioErrors(() async {
    await _api.v1ProvidersMeOfferingsIdDelete(id: id);
  });
}

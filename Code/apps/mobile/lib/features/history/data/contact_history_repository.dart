import 'package:sanaya/core/api/generated/api.dart';

/// Alias de lisibilité — types générés depuis OpenAPI (BE-45),
/// pas de redéclaration d'un type de domaine à la main (CLAUDE.md racine, P4).
typedef ContactHistoryItem = V1ContactEventsGet200ResponseItemsInner;
typedef ContactHistoryPage = V1ContactEventsGet200Response;

/// Repository pour l'historique des contacts du client authentifié (BE-45,
/// US-C-09). Aucune règle métier en Dart (P3) : délègue directement au
/// client généré, sur `ContactEventsApi` (pas `DefaultApi` — classe dédiée
/// au module `/v1/contact-events`, cf. `ContactService` pour le `POST`).
class ContactHistoryRepository {
  const ContactHistoryRepository(this._api);

  final ContactEventsApi _api;

  /// Récupère la liste paginée par curseur de l'historique de contacts.
  Future<ContactHistoryPage> fetchHistory({
    String? cursor,
    int limit = 20,
  }) async {
    final response = await _api.v1ContactEventsGet(
      cursor: cursor,
      limit: limit,
    );
    return response.data!;
  }
}

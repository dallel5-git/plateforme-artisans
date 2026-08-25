import 'package:test/test.dart';
import 'package:sanaya_api_client/sanaya_api_client.dart';

/// tests for ContactEventsApi
void main() {
  final instance = SanayaApiClient().getContactEventsApi();

  group(ContactEventsApi, () {
    // Révèle le numéro d'un prestataire et trace l'événement (P9). Canal PHONE ou WHATSAPP uniquement. Déduplique deux clics de la même session sur le même artisan/canal en 30 min. Rate-limit 30/j par identité et par IP.
    //
    //Future<ContactEventResponse> v1ContactEventsPost(V1ContactEventsPostRequest v1ContactEventsPostRequest) async
    test('test v1ContactEventsPost', () async {
      // TODO
    });
  });
}

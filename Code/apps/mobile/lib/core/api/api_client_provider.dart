import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client.dart';
import 'package:sanaya/core/api/generated/api.dart';

/// Instance partagée du client généré (BE-26/FM-02b), construite sur le
/// `Dio` partagé de `buildApiClient()` (FM-02c — URL de base + timeouts
/// réseau dégradé, `ErrorMappingInterceptor` déjà branché). FM-02d/e y
/// ajouteront les intercepteurs auth/refresh/retry ; ce provider reste le
/// point d'injection unique, seul le contenu de `buildApiClient()` change.
final apiClientProvider = Provider<SanayaApiClient>(
  (ref) => SanayaApiClient(dio: buildApiClient()),
);

/// Point d'entrée unique pour `/v1/categories` et `/v1/governorates` (BE-14)
/// — règle mobile CLAUDE.md #1 : aucun `Dio` écrit à la main, tout passe par
/// le client généré.
final defaultApiProvider = Provider<DefaultApi>(
  (ref) => ref.watch(apiClientProvider).getDefaultApi(),
);

/// Point d'entrée unique pour `/v1/contact-events` (BE-21, FM-09).
final contactEventsApiProvider = Provider<ContactEventsApi>(
  (ref) => ref.watch(apiClientProvider).getContactEventsApi(),
);

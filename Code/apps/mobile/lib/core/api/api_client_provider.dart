import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client.dart';
import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/api/interceptors/auth_interceptor.dart';

/// Instance partagée — un seul `AuthTokenStore` pour toute l'app, pour que
/// l'access token qu'il détient en mémoire soit le même que celui que lit
/// `AuthInterceptor` (et que celui qu'écrira l'écran de login, FM-05).
final authTokenStoreProvider = Provider<AuthTokenStore>(
  (ref) => AuthTokenStore(),
);

/// Instance partagée du client généré (BE-26/FM-02b), construite sur le
/// `Dio` partagé de `buildApiClient()` (FM-02c — URL de base + timeouts
/// réseau dégradé, `ErrorMappingInterceptor` déjà branché) et `FM-02d` —
/// `AuthInterceptor` (bearer + refresh transparent single-flight). L'ordre
/// d'assignation est contraint : `AuthInterceptor.dio` ne peut être fixé
/// qu'une fois le `Dio` construit (il en a besoin pour rejouer une requête
/// après refresh), donc après `buildApiClient()`, pas avant. FM-02e y
/// ajoutera le retry ; ce provider reste le point d'injection unique, seul
/// le contenu de `buildApiClient()` change.
final apiClientProvider = Provider<SanayaApiClient>((ref) {
  final tokenStore = ref.watch(authTokenStoreProvider);
  final authInterceptor = AuthInterceptor(tokenStore);
  final dio = buildApiClient(interceptors: [authInterceptor]);
  authInterceptor.dio = dio;
  return SanayaApiClient(dio: dio);
});

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

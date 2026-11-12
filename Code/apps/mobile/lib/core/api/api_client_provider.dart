import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client.dart';
import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/api/interceptors/auth_interceptor.dart';
import 'package:sanaya/core/api/interceptors/retry_interceptor.dart';
import 'package:sanaya/core/demo/demo_mock_interceptor.dart';
import 'package:sanaya/core/demo/demo_mode_provider.dart';

/// Instance partagée — un seul `AuthTokenStore` pour toute l'app, pour que
/// l'access token qu'il détient en mémoire soit le même que celui que lit
/// `AuthInterceptor` (et que celui qu'écrira l'écran de login, FM-05).
final authTokenStoreProvider = Provider<AuthTokenStore>(
  (ref) => AuthTokenStore(),
);

/// Instance partagée du client généré (BE-26/FM-02b), construite sur le
/// `Dio` partagé de `buildApiClient()` (FM-02c — URL de base + timeouts
/// réseau dégradé, `ErrorMappingInterceptor` déjà branché), `FM-02d` —
/// `AuthInterceptor` (bearer + refresh transparent single-flight) — et
/// `FM-02e` — `RetryInterceptor` (backoff sur les `GET` idempotents,
/// erreurs transitoires uniquement). Ordre : Auth avant Retry, tous deux
/// avant `ErrorMappingInterceptor` (toujours dernier dans
/// `buildApiClient()`) — un 401 doit pouvoir déclencher un refresh+rejeu
/// avant qu'une erreur réseau/5xx ne déclenche un retry, et avant que
/// l'une ou l'autre ne devienne une `SanayaApiException` définitive.
/// L'ordre d'assignation de `.dio` est contraint : ni l'un ni l'autre
/// intercepteur ne peut recevoir son `Dio` avant que `buildApiClient()`
/// l'ait construit (tous deux en ont besoin pour rejouer une requête via
/// `dio.fetch`), donc après, jamais avant.
final apiClientProvider = Provider<SanayaApiClient>((ref) {
  final isDemo = ref.watch(demoModeProvider);
  final demoRole = ref.watch(demoRoleProvider);
  final tokenStore = ref.watch(authTokenStoreProvider);
  final demoInterceptor = DemoMockInterceptor(
    isDemoMode: () => isDemo,
    getDemoRole: () => demoRole,
  );
  final authInterceptor = AuthInterceptor(tokenStore);
  final retryInterceptor = RetryInterceptor();
  final dio = buildApiClient(
    interceptors: [demoInterceptor, authInterceptor, retryInterceptor],
  );
  authInterceptor.dio = dio;
  retryInterceptor.dio = dio;
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

/// Point d'entrée unique pour `/v1/auth/*` (BE-10, FM-05, FM-13).
final authApiProvider = Provider<AuthApi>(
  (ref) => ref.watch(apiClientProvider).getAuthApi(),
);

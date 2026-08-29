import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';
import 'package:sanaya/features/auth/application/auth_status.dart';

bool _hasProviderRole(
  Iterable<V1AuthOtpVerifyPost200ResponseUserRolesEnum> roles,
) => roles.contains(V1AuthOtpVerifyPost200ResponseUserRolesEnum.PROVIDER);

/// Statut de session global (FM-05d), consommé par la garde `redirect:` de
/// `router` (`app/router.dart`). `build()` restaure la session persistée
/// (`AuthTokenStore.restoreSession`) puis résout le rôle via `GET /auth/me`
/// — la réponse d'`otp/verify` ne survit pas à un redémarrage de l'app.
class AuthStateNotifier extends AsyncNotifier<AuthStatus> {
  @override
  Future<AuthStatus> build() async {
    final restored = await ref.watch(authTokenStoreProvider).restoreSession();
    if (!restored) return const AuthStatus.unauthenticated();

    final user = await ref.read(authRepositoryProvider).getCurrentUser();
    return AuthStatus.authenticated(isProvider: _hasProviderRole(user.roles));
  }

  /// Appelé par `AuthFlowNotifier.submitOtp` juste après
  /// `AuthTokenStore.saveSession()` — la réponse de vérification porte déjà
  /// le rôle, pas besoin d'un second appel à `/auth/me`.
  void setAuthenticated(
    Iterable<V1AuthOtpVerifyPost200ResponseUserRolesEnum> roles,
  ) {
    state = AsyncData(
      AuthStatus.authenticated(isProvider: _hasProviderRole(roles)),
    );
  }

  /// Déconnexion : révoque la session serveur, purge le stockage local,
  /// puis repasse l'état à non-authentifié. Aucun écran n'appelle encore
  /// cette méthode (pas de bouton de déconnexion dans le périmètre FM-05,
  /// voir `auth_repository.dart` — prévu pour FM-13) ; elle est prête pour
  /// quand ce sera le cas.
  Future<void> signOut() async {
    final tokenStore = ref.read(authTokenStoreProvider);
    final refreshToken = await tokenStore.peekRefreshToken();
    await ref.read(logoutProvider)(refreshToken: refreshToken);
    await tokenStore.clear();
    state = const AsyncData(AuthStatus.unauthenticated());
  }
}

final authStateProvider = AsyncNotifierProvider<AuthStateNotifier, AuthStatus>(
  AuthStateNotifier.new,
);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/demo/demo_mode_provider.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';
import 'package:sanaya/features/auth/application/auth_status.dart';
import 'package:sanaya/features/dashboard/application/dashboard_providers.dart';
import 'package:sanaya/features/favorites/application/favorites_providers.dart';
import 'package:sanaya/features/history/application/contact_history_providers.dart';
import 'package:sanaya/features/onboarding/application/onboarding_providers.dart';
import 'package:sanaya/features/onboarding/data/publication_status_persistence.dart';
import 'package:sanaya/features/reviews/application/pro_reviews_providers.dart';

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
    final isDemo = ref.watch(demoModeProvider);
    if (isDemo) {
      final role = ref.watch(demoRoleProvider);
      switch (role) {
        case DemoRole.guest:
          return const AuthStatus.unauthenticated();
        case DemoRole.client:
          return const AuthStatus.authenticated(isProvider: false);
        case DemoRole.provider:
          return const AuthStatus.authenticated(isProvider: true);
      }
    }

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
  /// réinitialise le statut de publication et les préférences locales, puis
  /// invalide l'ensemble des caches et états privés pour garantir l'étanchéité
  /// absolue entre sessions (MOB-006).
  Future<void> signOut() async {
    final tokenStore = ref.read(authTokenStoreProvider);
    final refreshToken = await tokenStore.peekRefreshToken();
    await ref.read(logoutProvider)(refreshToken: refreshToken);
    await tokenStore.clear();

    // MOB-006 : réinitialiser hasPublishedProfileProvider et purger
    // SharedPreferences
    ref.read(hasPublishedProfileProvider.notifier).state = false;
    await clearPublicationStatus();

    // MOB-006 : invalidation explicite des états et caches privés
    // Note : currentUserProvider écoute déjà authStateProvider.future
    // (ref.watch) et se recalcule donc automatiquement vers null lors du
    // changement d'état.
    ref
      ..invalidate(favoritesListProvider)
      ..invalidate(contactHistoryProvider)
      ..invalidate(dashboardStatsProvider)
      ..invalidate(myProviderProfileProvider);

    state = const AsyncData(AuthStatus.unauthenticated());
  }
}

final authStateProvider = AsyncNotifierProvider<AuthStateNotifier, AuthStatus>(
  AuthStateNotifier.new,
);

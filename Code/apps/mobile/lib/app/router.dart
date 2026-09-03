import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/client_shell_screen.dart';
import 'package:sanaya/app/design_system_preview_screen.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/splash_screen.dart';
import 'package:sanaya/core/widgets/error_state.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';
import 'package:sanaya/features/auth/presentation/auth_screen.dart';
import 'package:sanaya/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:sanaya/features/favorites/presentation/favorites_screen.dart';
import 'package:sanaya/features/history/presentation/history_placeholder_screen.dart';
import 'package:sanaya/features/onboarding/presentation/onboarding_screen.dart';
import 'package:sanaya/features/profile/presentation/profile_placeholder_screen.dart';
import 'package:sanaya/features/provider_profile/presentation/screens/provider_profile_screen.dart';
import 'package:sanaya/features/provider_profile/presentation/screens/review_form_screen.dart';
import 'package:sanaya/features/search/presentation/search_home_screen.dart';
import 'package:sanaya/features/settings/presentation/legal_notice_screen.dart';
import 'package:sanaya/features/settings/presentation/settings_screen.dart';

/// Fait réévaluer `redirect:` quand `authStateProvider` change en dehors
/// d'une navigation (ex. restauration de session résolue en tâche de fond,
/// déconnexion) — `router` reste un singleton top-level (patron déjà en
/// place, réutilisé par `test/widget_test.dart` via `router.go(...)`),
/// donc ce pont ne peut pas être un `Provider<GoRouter>` classique.
/// Branché par `SanayaApp` (`main.dart`) via `ref.listen(authStateProvider,
/// (_, __) => authRouterRefreshListenable.refresh())`.
class GoRouterRefreshListenable extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final authRouterRefreshListenable = GoRouterRefreshListenable();

/// go_router n'a pas d'équivalent aux dossiers parenthésés d'Expo Router —
/// les groupes (auth)/(client)/(pro) de l'issue FM-01 sont traduits en
/// préfixes de chemin visibles, cohérent avec la justification même du
/// choix de go_router dans l'ADR-001 ("aligne le modèle mental sur celui du
/// Web"). `redirect:` (FM-05d, étendu FM-23) ne fait qu'éviter à un
/// utilisateur déjà authentifié de repasser par `/auth` ou le splash `/` —
/// il ne bloque pas l'accès anonyme à `/client`/`/pro` (recherche publique,
/// hors périmètre FM-05 : seul le contact d'un artisan ou la publication
/// d'un profil nécessitent une session, gérés ailleurs).
final router = GoRouter(
  initialLocation: '/',
  refreshListenable: authRouterRefreshListenable,
  redirect: (context, state) {
    final container = ProviderScope.containerOf(context, listen: false);
    final auth = container.read(authStateProvider);
    final onSplash = state.matchedLocation == '/';

    // FM-23 : tant que la restauration de session n'est pas résolue,
    // rester sur (ou revenir vers) le splash — évite le flash d'écran sur
    // réseau lent que produisait l'ancien `valueOrNull == null` (il
    // confondait "en cours" et "pas de session").
    if (auth.isLoading) return onSplash ? null : '/';

    final status = auth.valueOrNull;
    if (status == null || !status.isAuthenticated) {
      // Résolu, anonyme : le splash laisse place à la recherche publique
      // (gratuite pour le particulier, CLAUDE.md racine) — jamais à un
      // écran de choix de rôle brut (l'ancien hub à 3 boutons).
      return onSplash ? '/client' : null;
    }

    final onEntryRoute = onSplash || state.matchedLocation == '/auth';
    if (!onEntryRoute) return null;
    return status.isProvider ? '/pro' : '/client';
  },
  errorBuilder: (_, _) => const _RouteNotFoundScreen(),
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (_, _) => const SplashScreen(),
    ),
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (_, _) => const AuthScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (_, _, navigationShell) =>
          ClientShellScreen(navigationShell: navigationShell),
      branches: [
        // `pageBuilder: NoTransitionPage` sur les 4 branches : `goBranch()`
        // bascule instantanément via l'`IndexedStack` du shell — une
        // transition de page animée par défaut laisserait une page
        // fantôme intercepter les taps pendant sa durée (constaté en test,
        // recette standard `StatefulShellRoute`).
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/client',
              name: 'client-home',
              pageBuilder: (_, _) =>
                  const NoTransitionPage(child: SearchHomeScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/client/favorites',
              name: 'client-favorites',
              pageBuilder: (_, _) =>
                  const NoTransitionPage(child: FavoritesScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/client/history',
              name: 'client-history',
              pageBuilder: (_, _) =>
                  const NoTransitionPage(child: HistoryPlaceholderScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/client/profile',
              name: 'client-profile',
              pageBuilder: (_, _) =>
                  const NoTransitionPage(child: ProfilePlaceholderScreen()),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/providers/:slug',
      name: 'provider-profile',
      builder: (_, state) => ProviderProfileScreen(
        slug: state.pathParameters['slug'] ?? '',
      ),
      routes: [
        GoRoute(
          path: 'review',
          name: 'provider-review',
          builder: (_, state) => ReviewFormScreen(
            slug: state.pathParameters['slug'] ?? '',
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/pro',
      name: 'pro-onboarding',
      builder: (_, _) => const OnboardingScreen(),
      routes: [
        GoRoute(
          path: 'dashboard',
          name: 'pro-dashboard',
          builder: (_, _) => const DashboardScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (_, _) => const SettingsScreen(),
      routes: [
        GoRoute(
          path: 'legal',
          name: 'settings-legal',
          builder: (_, _) => const LegalNoticeScreen(),
        ),
      ],
    ),
    // FM-23 : la vitrine interne n'est plus atteignable en production —
    // seul l'icône palette du hub y menait, et le hub disparaît avec ce
    // ticket. Reste accessible par URL/deep-link en debug.
    if (kDebugMode)
      GoRoute(
        path: '/_ds-preview',
        name: 'ds-preview',
        builder: (_, _) => const DesignSystemPreviewScreen(),
      ),
  ],
);

/// Route inconnue → `ErrorState` thémé (design-system.html §8), pas la page
/// anglaise par défaut de go_router.
class _RouteNotFoundScreen extends ConsumerWidget {
  const _RouteNotFoundScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);

    return Scaffold(
      body: Center(
        child: ErrorState(
          icon: '🔍',
          title: t.errors.routeNotFoundTitle,
          message: t.errors.routeNotFoundMessage,
          actionLabel: t.errors.routeNotFoundAction,
          onAction: () => router.go('/client'),
        ),
      ),
    );
  }
}

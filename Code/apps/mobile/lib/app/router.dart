import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/design_system_preview_screen.dart';
import 'package:sanaya/app/home_screen.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';
import 'package:sanaya/features/auth/presentation/auth_screen.dart';
import 'package:sanaya/features/favorites/presentation/favorites_screen.dart';
import 'package:sanaya/features/onboarding/presentation/onboarding_screen.dart';
import 'package:sanaya/features/provider_profile/presentation/screens/provider_profile_screen.dart';
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
/// Web"). `redirect:` (FM-05d) ne fait qu'éviter à un utilisateur déjà
/// authentifié de repasser par `/auth` ou le hub `/` — il ne bloque pas
/// l'accès anonyme à `/client`/`/pro` (recherche publique, hors périmètre
/// FM-05 : seul le contact d'un artisan ou la publication d'un profil
/// nécessitent une session, gérés ailleurs).
final router = GoRouter(
  initialLocation: '/',
  refreshListenable: authRouterRefreshListenable,
  redirect: (context, state) {
    final status = ProviderScope.containerOf(
      context,
      listen: false,
    ).read(authStateProvider).valueOrNull;
    if (status == null || !status.isAuthenticated) return null;

    final onEntryRoute =
        state.matchedLocation == '/' || state.matchedLocation == '/auth';
    if (!onEntryRoute) return null;
    return status.isProvider ? '/pro' : '/client';
  },
  routes: [
    GoRoute(path: '/', name: 'home', builder: (_, _) => const HomeScreen()),
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (_, _) => const AuthScreen(),
    ),
    GoRoute(
      path: '/client',
      name: 'client-home',
      builder: (_, _) => const SearchHomeScreen(),
      routes: [
        GoRoute(
          path: 'favorites',
          name: 'client-favorites',
          builder: (_, _) => const FavoritesScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/providers/:slug',
      name: 'provider-profile',
      builder: (_, state) => ProviderProfileScreen(
        slug: state.pathParameters['slug'] ?? '',
      ),
    ),
    GoRoute(
      path: '/pro',
      name: 'pro-onboarding',
      builder: (_, _) => const OnboardingScreen(),
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
    GoRoute(
      path: '/_ds-preview',
      name: 'ds-preview',
      builder: (_, _) => const DesignSystemPreviewScreen(),
    ),
  ],
);

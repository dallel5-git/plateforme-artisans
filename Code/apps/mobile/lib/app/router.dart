import 'package:go_router/go_router.dart';
import 'package:sanaya/app/bootstrap_placeholder_screen.dart';
import 'package:sanaya/app/design_system_preview_screen.dart';
import 'package:sanaya/app/home_screen.dart';
import 'package:sanaya/features/favorites/presentation/favorites_screen.dart';
import 'package:sanaya/features/provider_profile/presentation/screens/provider_profile_screen.dart';
import 'package:sanaya/features/search/presentation/search_home_screen.dart';
import 'package:sanaya/features/settings/presentation/legal_notice_screen.dart';
import 'package:sanaya/features/settings/presentation/settings_screen.dart';

/// go_router n'a pas d'équivalent aux dossiers parenthésés d'Expo Router —
/// les groupes (auth)/(client)/(pro) de l'issue FM-01 sont traduits en
/// préfixes de chemin visibles, cohérent avec la justification même du
/// choix de go_router dans l'ADR-001 ("aligne le modèle mental sur celui du
/// Web") et prêt pour le `redirect:` de garde par rôle qu'ajoutera FM-05.
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', name: 'home', builder: (_, _) => const HomeScreen()),
    GoRoute(
      path: '/auth',
      name: 'auth-placeholder',
      builder: (_, _) => const BootstrapPlaceholderScreen(
        space: BootstrapNavSpace.auth,
      ),
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
      name: 'pro-placeholder',
      builder: (_, _) => const BootstrapPlaceholderScreen(
        space: BootstrapNavSpace.pro,
      ),
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

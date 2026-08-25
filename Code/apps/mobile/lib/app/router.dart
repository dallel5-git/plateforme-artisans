import 'package:go_router/go_router.dart';

import 'package:sanaya/app/bootstrap_placeholder_screen.dart';
import 'package:sanaya/app/home_screen.dart';

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
      name: 'client-placeholder',
      builder: (_, _) => const BootstrapPlaceholderScreen(
        space: BootstrapNavSpace.client,
      ),
    ),
    GoRoute(
      path: '/pro',
      name: 'pro-placeholder',
      builder: (_, _) => const BootstrapPlaceholderScreen(
        space: BootstrapNavSpace.pro,
      ),
    ),
  ],
);

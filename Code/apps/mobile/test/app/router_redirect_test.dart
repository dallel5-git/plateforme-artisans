import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/router.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';
import 'package:sanaya/features/auth/data/auth_repository.dart';
import 'package:sanaya/features/onboarding/application/onboarding_providers.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockAuthTokenStore extends Mock implements AuthTokenStore {}

class _MockMeResponse extends Mock implements V1AuthMeGet200Response {}

/// `SplashScreen` affiche un `CircularProgressIndicator` indéterminé —
/// `pumpAndSettle()` ne se termine jamais tant qu'il est à l'écran (son
/// animation se reprogramme indéfiniment). On pompe donc un budget de temps
/// borné pour laisser `authStateProvider` résoudre et `redirect:` faire
/// quitter le splash, avant tout `pumpAndSettle()`.
Future<void> pumpPastSplash(WidgetTester tester) async {
  await tester.pump();
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// FM-05d/FM-23 — la garde `redirect:` de `router.dart` : une session déjà
/// restaurée au démarrage ne doit pas repasser par l'écran de rôle (critère
/// d'acceptation FM-05, "fermer et rouvrir l'app conserve la session"), et
/// tant que la restauration n'est pas résolue, l'app reste sur le splash
/// plutôt que de flasher un écran intermédiaire (critère d'acceptation
/// FM-23).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final t = AppLocale.fr.buildSync();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    router.go('/');
  });

  testWidgets(
    'session restaurée (rôle CLIENT) : le splash redirige vers le shell '
    'client, pas /auth',
    (tester) async {
      final authRepository = _MockAuthRepository();
      final authTokenStore = _MockAuthTokenStore();
      when(authTokenStore.restoreSession).thenAnswer((_) async => true);
      final me = _MockMeResponse();
      when(() => me.roles).thenReturn(
        BuiltList<V1AuthOtpVerifyPost200ResponseUserRolesEnum>([
          V1AuthOtpVerifyPost200ResponseUserRolesEnum.CLIENT,
        ]),
      );
      when(authRepository.getCurrentUser).thenAnswer((_) async => me);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            authTokenStoreProvider.overrideWithValue(authTokenStore),
            categoriesProvider.overrideWith((ref) async => const []),
            governoratesProvider.overrideWith((ref) async => const []),
          ],
          child: const SanayaApp(),
        ),
      );
      await pumpPastSplash(tester);

      expect(find.text(t.auth.phoneTitle), findsNothing);
      expect(find.text(t.search.categoriesTitle), findsOneWidget);
      expect(find.text(t.common.nav.searchTab), findsOneWidget);
    },
  );

  testWidgets(
    'session restaurée (rôle PROVIDER, profil PAS encore publié) : /auth '
    'redirige vers l’onboarding pro, pas l’écran de rôle',
    (tester) async {
      // FM-24 : hasPublishedProfileProvider par défaut (false, aucun override
      // ci-dessous) — c'est le cas « pas encore de profil » que ce test
      // verrouille explicitement, distinct du cas « déjà publié » ci-après.
      final authRepository = _MockAuthRepository();
      final authTokenStore = _MockAuthTokenStore();
      when(authTokenStore.restoreSession).thenAnswer((_) async => true);
      final me = _MockMeResponse();
      when(() => me.roles).thenReturn(
        BuiltList<V1AuthOtpVerifyPost200ResponseUserRolesEnum>([
          V1AuthOtpVerifyPost200ResponseUserRolesEnum.PROVIDER,
        ]),
      );
      when(authRepository.getCurrentUser).thenAnswer((_) async => me);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            authTokenStoreProvider.overrideWithValue(authTokenStore),
            categoriesProvider.overrideWith((ref) async => const []),
            governoratesProvider.overrideWith((ref) async => const []),
          ],
          child: const SanayaApp(),
        ),
      );
      await pumpPastSplash(tester);
      router.go('/auth');
      await tester.pumpAndSettle();

      expect(find.text(t.auth.phoneTitle), findsNothing);
      expect(find.text(t.onboarding.wizardTitle), findsOneWidget);
    },
  );

  testWidgets(
    'session restaurée (rôle PROVIDER, profil déjà publié) : /auth redirige '
    'directement vers le shell pro (dashboard), pas l’onboarding',
    (tester) async {
      final authRepository = _MockAuthRepository();
      final authTokenStore = _MockAuthTokenStore();
      when(authTokenStore.restoreSession).thenAnswer((_) async => true);
      final me = _MockMeResponse();
      when(() => me.roles).thenReturn(
        BuiltList<V1AuthOtpVerifyPost200ResponseUserRolesEnum>([
          V1AuthOtpVerifyPost200ResponseUserRolesEnum.PROVIDER,
        ]),
      );
      when(authRepository.getCurrentUser).thenAnswer((_) async => me);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            authTokenStoreProvider.overrideWithValue(authTokenStore),
            categoriesProvider.overrideWith((ref) async => const []),
            governoratesProvider.overrideWith((ref) async => const []),
            hasPublishedProfileProvider.overrideWith((ref) => true),
          ],
          child: const SanayaApp(),
        ),
      );
      await pumpPastSplash(tester);
      router.go('/auth');
      await tester.pumpAndSettle();

      expect(find.text(t.onboarding.wizardTitle), findsNothing);
      // `t.dashboard.title` et `t.common.nav.dashboardTab` sont la même
      // chaîne FR ("Tableau de bord") — apparaît deux fois à l'écran
      // (AppBar + onglet actif), d'où `findsWidgets` plutôt que
      // `findsOneWidget`. Les onglets confirment le shell pro affiché.
      expect(find.text(t.dashboard.title), findsWidgets);
      expect(find.text(t.common.nav.boostsTab), findsOneWidget);
      expect(find.text(t.common.nav.reviewsTab), findsOneWidget);
      expect(find.text(t.common.nav.profileTab), findsOneWidget);
    },
  );

  testWidgets(
    'FM-24 — anonyme forçant /pro/dashboard est redirigé vers /auth, '
    'jamais montré un 401 brut',
    (tester) async {
      final authRepository = _MockAuthRepository();
      final authTokenStore = _MockAuthTokenStore();
      when(authTokenStore.restoreSession).thenAnswer((_) async => false);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            authTokenStoreProvider.overrideWithValue(authTokenStore),
            categoriesProvider.overrideWith((ref) async => const []),
            governoratesProvider.overrideWith((ref) async => const []),
          ],
          child: const SanayaApp(),
        ),
      );
      await pumpPastSplash(tester);
      router.go('/pro/dashboard');
      await tester.pumpAndSettle();

      expect(find.text(t.dashboard.title), findsNothing);
      expect(find.text(t.auth.phoneTitle), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'FM-24 — CLIENT authentifié forçant /pro/dashboard est redirigé vers '
    'son propre espace client, jamais montré un 401 brut',
    (tester) async {
      final authRepository = _MockAuthRepository();
      final authTokenStore = _MockAuthTokenStore();
      when(authTokenStore.restoreSession).thenAnswer((_) async => true);
      final me = _MockMeResponse();
      when(() => me.roles).thenReturn(
        BuiltList<V1AuthOtpVerifyPost200ResponseUserRolesEnum>([
          V1AuthOtpVerifyPost200ResponseUserRolesEnum.CLIENT,
        ]),
      );
      when(authRepository.getCurrentUser).thenAnswer((_) async => me);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            authTokenStoreProvider.overrideWithValue(authTokenStore),
            categoriesProvider.overrideWith((ref) async => const []),
            governoratesProvider.overrideWith((ref) async => const []),
          ],
          child: const SanayaApp(),
        ),
      );
      await pumpPastSplash(tester);
      router.go('/pro/dashboard');
      await tester.pumpAndSettle();

      // Pas /auth : un CLIENT déjà authentifié qui atterrirait sur /auth en
      // repartirait de toute façon aussitôt vers /client (règle
      // `onEntryRoute` pré-existante) — autant y aller directement plutôt
      // que d'afficher furtivement un écran de ré-authentification trompeur.
      expect(find.text(t.dashboard.title), findsNothing);
      expect(find.text(t.auth.phoneTitle), findsNothing);
      expect(find.text(t.search.categoriesTitle), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'MOB-001 — CLIENT authentifié naviguant vers /pro/onboarding accède '
    'à l’onboarding sans être redirigé vers /client',
    (tester) async {
      final authRepository = _MockAuthRepository();
      final authTokenStore = _MockAuthTokenStore();
      when(authTokenStore.restoreSession).thenAnswer((_) async => true);
      final me = _MockMeResponse();
      when(() => me.roles).thenReturn(
        BuiltList<V1AuthOtpVerifyPost200ResponseUserRolesEnum>([
          V1AuthOtpVerifyPost200ResponseUserRolesEnum.CLIENT,
        ]),
      );
      when(authRepository.getCurrentUser).thenAnswer((_) async => me);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            authTokenStoreProvider.overrideWithValue(authTokenStore),
            categoriesProvider.overrideWith((ref) async => const []),
            governoratesProvider.overrideWith((ref) async => const []),
          ],
          child: const SanayaApp(),
        ),
      );
      await pumpPastSplash(tester);
      router.go('/pro/onboarding');
      await tester.pumpAndSettle();

      expect(find.text(t.onboarding.wizardTitle), findsOneWidget);
      expect(find.text(t.search.categoriesTitle), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'MOB-001 — anonyme naviguant vers /pro/onboarding est redirigé vers /auth, '
    'jamais montré un 401 brut',
    (tester) async {
      final authRepository = _MockAuthRepository();
      final authTokenStore = _MockAuthTokenStore();
      when(authTokenStore.restoreSession).thenAnswer((_) async => false);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            authTokenStoreProvider.overrideWithValue(authTokenStore),
            categoriesProvider.overrideWith((ref) async => const []),
            governoratesProvider.overrideWith((ref) async => const []),
          ],
          child: const SanayaApp(),
        ),
      );
      await pumpPastSplash(tester);
      router.go('/pro/onboarding');
      await tester.pumpAndSettle();

      expect(find.text(t.onboarding.wizardTitle), findsNothing);
      expect(find.text(t.auth.phoneTitle), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    '🔒 NON-RÉGRESSION FM-23 : tant que la session n’est pas résolue, '
    'l’app reste sur le splash (pas de flash d’écran intermédiaire)',
    (tester) async {
      final authRepository = _MockAuthRepository();
      final authTokenStore = _MockAuthTokenStore();
      // Future volontairement jamais complété : simule une restauration de
      // session encore en cours (réseau lent, P5).
      when(
        authTokenStore.restoreSession,
      ).thenAnswer((_) => Completer<bool>().future);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            authTokenStoreProvider.overrideWithValue(authTokenStore),
          ],
          child: const SanayaApp(),
        ),
      );
      // Pompes bornées volontairement courtes : `restoreSession()` ne
      // résout jamais dans ce test, `pumpAndSettle()` boucherait donc sur
      // l'animation du splash.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(t.search.categoriesTitle), findsNothing);
      verifyNever(authRepository.getCurrentUser);
    },
  );

  testWidgets(
    // régression #222 : SettingsScreen._confirmLogout appelait
    // authRepository.logout() SANS argument — no-op garanti par le
    // `if (refreshToken != null)` de AuthRepository.logout(), donc
    // authStateProvider ne repassait jamais à unauthenticated et la garde
    // /pro/* (FM-24) ne se déclenchait jamais après déconnexion.
    'RÉGRESSION #222 : se déconnecter depuis les Réglages en session '
    'PROVIDER sur /pro/dashboard fait voir la garde /auth ensuite',
    (tester) async {
      final authRepository = _MockAuthRepository();
      final authTokenStore = _MockAuthTokenStore();
      when(authTokenStore.restoreSession).thenAnswer((_) async => true);
      final me = _MockMeResponse();
      when(() => me.roles).thenReturn(
        BuiltList<V1AuthOtpVerifyPost200ResponseUserRolesEnum>([
          V1AuthOtpVerifyPost200ResponseUserRolesEnum.PROVIDER,
        ]),
      );
      when(() => me.firstName).thenReturn('Ali');
      when(() => me.lastName).thenReturn('Trabelsi');
      when(() => me.phone).thenReturn('+21622123456');
      when(authRepository.getCurrentUser).thenAnswer((_) async => me);
      when(
        authTokenStore.peekRefreshToken,
      ).thenAnswer((_) async => 'session-id.refresh-token');
      when(
        () => authRepository.logout(
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});
      when(authTokenStore.clear).thenAnswer((_) async {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            authTokenStoreProvider.overrideWithValue(authTokenStore),
            categoriesProvider.overrideWith((ref) async => const []),
            governoratesProvider.overrideWith((ref) async => const []),
            hasPublishedProfileProvider.overrideWith((ref) => true),
          ],
          child: const SanayaApp(),
        ),
      );
      await pumpPastSplash(tester);
      router.go('/auth');
      await tester.pumpAndSettle();
      expect(find.text(t.dashboard.title), findsWidgets);

      // Le bouton de déconnexion de `ClientProfileScreen` (`/client/profile`,
      // FM-32) vit dans une branche non initiale du `StatefulShellRoute` du
      // shell client — un widget test qui bascule dessus via `goBranch`
      // obtient un `Scaffold` de hauteur 0 (reproductible aussi sur la
      // branche Favoris, donc indépendant de FM-32 ; probable limitation de
      // `IndexedStack`/`Offstage` sous `pumpAndSettle`, à investiguer
      // séparément). On appelle donc directement `signOut()` via le
      // conteneur Riverpod — ce que vérifie cette régression, c'est que le
      // vrai chemin de déconnexion fait bien réagir la garde `/pro/*`, pas
      // le rendu du bouton lui-même (couvert isolément par
      // `client_profile_screen_test.dart`).
      final container = ProviderScope.containerOf(
        tester.element(find.byType(SanayaApp)),
      );
      await container.read(authStateProvider.notifier).signOut();
      await tester.pumpAndSettle();

      // La garde ne réagit qu'à une navigation (`redirect:` s'exécute à
      // chaque changement de route ou via `authRouterRefreshListenable`) —
      // on force explicitement une tentative sur la route protégée.
      router.go('/pro/dashboard');
      await tester.pumpAndSettle();

      expect(find.text(t.dashboard.title), findsNothing);
      expect(find.text(t.auth.phoneTitle), findsOneWidget);
    },
  );

  testWidgets(
    "FM-25 — un artisan authentifié atteint l'espace client et revient à "
    "l'espace pro sans se déconnecter",
    (tester) async {
      final authRepository = _MockAuthRepository();
      final authTokenStore = _MockAuthTokenStore();
      when(authTokenStore.restoreSession).thenAnswer((_) async => true);
      final me = _MockMeResponse();
      when(() => me.roles).thenReturn(
        BuiltList<V1AuthOtpVerifyPost200ResponseUserRolesEnum>([
          V1AuthOtpVerifyPost200ResponseUserRolesEnum.PROVIDER,
        ]),
      );
      when(authRepository.getCurrentUser).thenAnswer((_) async => me);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            authTokenStoreProvider.overrideWithValue(authTokenStore),
            categoriesProvider.overrideWith((ref) async => const []),
            governoratesProvider.overrideWith((ref) async => const []),
            hasPublishedProfileProvider.overrideWith((ref) => true),
          ],
          child: const SanayaApp(),
        ),
      );
      await pumpPastSplash(tester);
      router.go('/auth');
      await tester.pumpAndSettle();
      expect(find.text(t.dashboard.title), findsWidgets);

      // Le bouton "Retour à l'espace Client" / "Passer en espace Pro" ne
      // fait qu'un `context.go(...)` (widget testé isolément dans
      // client_profile_screen_test.dart /
      // pro_profile_placeholder_screen_test.dart) — ce qui compte ici,
      // niveau routeur, c'est que `redirect:` ne s'y oppose pas et
      // n'exige aucune ré-authentification pour un PROVIDER qui navigue
      // volontairement entre ses deux espaces.
      router.go('/client');
      await tester.pumpAndSettle();

      expect(find.text(t.search.categoriesTitle), findsOneWidget);
      expect(find.text(t.common.nav.profileTab), findsOneWidget);
      expect(find.text(t.auth.phoneTitle), findsNothing);

      router.go('/pro');
      await tester.pumpAndSettle();

      // Retour direct sur le dashboard (profil déjà publié dans ce test) —
      // aucune ré-authentification, la session n'a jamais changé d'état.
      expect(find.text(t.dashboard.title), findsWidgets);
      expect(find.text(t.auth.phoneTitle), findsNothing);
      verifyNever(
        () => authRepository.logout(
          refreshToken: any(named: 'refreshToken'),
        ),
      );
    },
  );

  testWidgets(
    'aucune session : le splash redirige vers le shell client (anonyme), '
    'jamais vers un écran de choix de rôle brut',
    (tester) async {
      final authRepository = _MockAuthRepository();
      final authTokenStore = _MockAuthTokenStore();
      when(authTokenStore.restoreSession).thenAnswer((_) async => false);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            authTokenStoreProvider.overrideWithValue(authTokenStore),
            categoriesProvider.overrideWith((ref) async => const []),
            governoratesProvider.overrideWith((ref) async => const []),
          ],
          child: const SanayaApp(),
        ),
      );
      await pumpPastSplash(tester);

      expect(find.text(t.search.categoriesTitle), findsOneWidget);
      expect(find.text(t.common.nav.searchTab), findsOneWidget);
      expect(find.text(t.common.nav.favoritesTab), findsOneWidget);
      expect(find.text(t.common.nav.historyTab), findsOneWidget);
      expect(find.text(t.common.nav.profileTab), findsOneWidget);
      verifyNever(authRepository.getCurrentUser);
    },
  );
}

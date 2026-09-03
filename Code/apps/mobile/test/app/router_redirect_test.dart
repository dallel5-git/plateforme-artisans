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
import 'package:sanaya/features/auth/data/auth_repository.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/main.dart';

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
  final t = AppLocale.fr.buildSync();

  setUp(() => router.go('/'));

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

      expect(find.text(t.auth.roleTitle), findsNothing);
      expect(find.text(t.search.categoriesTitle), findsOneWidget);
      expect(find.text(t.common.nav.searchTab), findsOneWidget);
    },
  );

  testWidgets(
    'session restaurée (rôle PROVIDER) : /auth redirige vers l’onboarding '
    'pro, pas l’écran de rôle',
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
          ],
          child: const SanayaApp(),
        ),
      );
      await pumpPastSplash(tester);
      router.go('/auth');
      await tester.pumpAndSettle();

      expect(find.text(t.auth.roleTitle), findsNothing);
      expect(find.text(t.onboarding.wizardTitle), findsOneWidget);
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

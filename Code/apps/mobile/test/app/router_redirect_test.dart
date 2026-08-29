import 'package:built_collection/built_collection.dart';
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

/// FM-05d — la garde `redirect:` de `router.dart` : une session déjà
/// restaurée au démarrage ne doit pas repasser par l'écran de rôle (critère
/// d'acceptation FM-05, "fermer et rouvrir l'app conserve la session").
void main() {
  final t = AppLocale.fr.buildSync();

  setUp(() => router.go('/'));

  testWidgets(
    'session restaurée (rôle CLIENT) : / redirige vers l’accueil client, '
    'pas le hub ni /auth',
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
      await tester.pumpAndSettle();

      expect(find.text(t.common.home.navAuth), findsNothing);
      expect(find.text(t.search.categoriesTitle), findsOneWidget);
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
      await tester.pumpAndSettle();
      router.go('/auth');
      await tester.pumpAndSettle();

      expect(find.text(t.auth.roleTitle), findsNothing);
      expect(find.text(t.onboarding.wizardTitle), findsOneWidget);
    },
  );

  testWidgets(
    'aucune session : / affiche toujours le hub à 3 boutons, aucune '
    'redirection',
    (tester) async {
      final authRepository = _MockAuthRepository();
      final authTokenStore = _MockAuthTokenStore();
      when(authTokenStore.restoreSession).thenAnswer((_) async => false);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
            authTokenStoreProvider.overrideWithValue(authTokenStore),
          ],
          child: const SanayaApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(t.common.home.navAuth), findsOneWidget);
      expect(find.text(t.common.home.navClient), findsOneWidget);
      expect(find.text(t.common.home.navPro), findsOneWidget);
      verifyNever(authRepository.getCurrentUser);
    },
  );
}

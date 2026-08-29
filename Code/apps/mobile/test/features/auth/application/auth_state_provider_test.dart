import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';
import 'package:sanaya/features/auth/application/auth_status.dart';
import 'package:sanaya/features/auth/data/auth_repository.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockAuthTokenStore extends Mock implements AuthTokenStore {}

class _MockMeResponse extends Mock implements V1AuthMeGet200Response {}

BuiltList<V1AuthOtpVerifyPost200ResponseUserRolesEnum> _roles(
  List<V1AuthOtpVerifyPost200ResponseUserRolesEnum> roles,
) => BuiltList<V1AuthOtpVerifyPost200ResponseUserRolesEnum>(roles);

ProviderContainer _makeContainer({
  required _MockAuthRepository authRepository,
  required _MockAuthTokenStore authTokenStore,
}) => ProviderContainer(
  overrides: [
    authRepositoryProvider.overrideWithValue(authRepository),
    authTokenStoreProvider.overrideWithValue(authTokenStore),
  ],
);

void main() {
  late _MockAuthRepository authRepository;
  late _MockAuthTokenStore authTokenStore;
  late ProviderContainer container;

  setUp(() {
    authRepository = _MockAuthRepository();
    authTokenStore = _MockAuthTokenStore();
    container = _makeContainer(
      authRepository: authRepository,
      authTokenStore: authTokenStore,
    );
  });

  tearDown(() => container.dispose());

  test(
    'aucune session persistée : résout "unauthenticated" sans appeler /me',
    () async {
      when(
        () => authTokenStore.restoreSession(),
      ).thenAnswer((_) async => false);

      final status = await container.read(authStateProvider.future);

      expect(status.kind, AuthStatusKind.unauthenticated);
      expect(status.isAuthenticated, isFalse);
      verifyNever(() => authRepository.getCurrentUser());
    },
  );

  test(
    'session restaurée : résout "authenticated" avec isProvider selon '
    'GET /auth/me',
    () async {
      when(
        () => authTokenStore.restoreSession(),
      ).thenAnswer((_) async => true);
      final me = _MockMeResponse();
      when(() => me.roles).thenReturn(
        _roles([V1AuthOtpVerifyPost200ResponseUserRolesEnum.PROVIDER]),
      );
      when(
        () => authRepository.getCurrentUser(),
      ).thenAnswer((_) async => me);

      final status = await container.read(authStateProvider.future);

      expect(status.kind, AuthStatusKind.authenticated);
      expect(status.isProvider, isTrue);
    },
  );

  test('signOut() révoque côté serveur, purge le stockage, repasse à '
      'unauthenticated', () async {
    when(
      () => authTokenStore.restoreSession(),
    ).thenAnswer((_) async => false);
    when(
      () => authTokenStore.peekRefreshToken(),
    ).thenAnswer((_) async => 'session-id.token-id');
    when(
      () => authRepository.logout(refreshToken: any(named: 'refreshToken')),
    ).thenAnswer((_) async {});
    when(() => authTokenStore.clear()).thenAnswer((_) async {});

    await container.read(authStateProvider.future);
    // Simule une session ouverte avant de tester la déconnexion.
    container.read(authStateProvider.notifier).setAuthenticated([
      V1AuthOtpVerifyPost200ResponseUserRolesEnum.CLIENT,
    ]);

    await container.read(authStateProvider.notifier).signOut();

    final status = container.read(authStateProvider).value!;
    expect(status.kind, AuthStatusKind.unauthenticated);
    verify(
      () => authRepository.logout(refreshToken: 'session-id.token-id'),
    ).called(1);
    verify(() => authTokenStore.clear()).called(1);
  });
}

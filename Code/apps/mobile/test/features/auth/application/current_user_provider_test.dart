import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';
import 'package:sanaya/features/auth/application/auth_status.dart';
import 'package:sanaya/features/auth/application/current_user_provider.dart';
import 'package:sanaya/features/auth/data/auth_repository.dart';

class _AuthRepositoryMock extends Mock implements AuthRepository {}

class _FixedAuthStateNotifier extends AuthStateNotifier {
  _FixedAuthStateNotifier(this._status);

  final AuthStatus _status;

  @override
  Future<AuthStatus> build() async => _status;
}

void main() {
  late _AuthRepositoryMock authRepository;

  setUpAll(() {
    registerFallbackValue(
      V1AuthMeGet200Response(
        (b) => b
          ..id = 'u1'
          ..phone = '+21622123456'
          ..phoneVerifiedAt = DateTime(2026)
          ..email = ''
          ..emailVerifiedAt = DateTime(2026)
          ..firstName = ''
          ..lastName = ''
          ..avatarMediaId = ''
          ..roles.add(V1AuthOtpVerifyPost200ResponseUserRolesEnum.CLIENT)
          ..status = V1AuthMeGet200ResponseStatusEnum.ACTIVE
          ..locale = 'fr'
          ..lastLoginAt = DateTime(2026)
          ..marketingOptIn = false
          ..createdAt = DateTime(2026)
          ..updatedAt = DateTime(2026),
      ),
    );
  });

  setUp(() {
    authRepository = _AuthRepositoryMock();
  });

  test(
    'session non authentifiée : ne pas appeler /auth/me, renvoie null',
    () async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          authStateProvider.overrideWith(
            () => _FixedAuthStateNotifier(const AuthStatus.unauthenticated()),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(currentUserProvider.future);

      expect(result, isNull);
      verifyNever(authRepository.getCurrentUser);
    },
  );

  test(
    'session authentifiée : renvoie l’utilisateur courant depuis /auth/me',
    () async {
      final user = V1AuthMeGet200Response(
        (b) => b
          ..id = 'u1'
          ..phone = '+21622123456'
          ..phoneVerifiedAt = DateTime(2026)
          ..email = ''
          ..emailVerifiedAt = DateTime(2026)
          ..firstName = 'Salma'
          ..lastName = 'Ben Ali'
          ..avatarMediaId = ''
          ..roles.add(V1AuthOtpVerifyPost200ResponseUserRolesEnum.CLIENT)
          ..status = V1AuthMeGet200ResponseStatusEnum.ACTIVE
          ..locale = 'fr'
          ..lastLoginAt = DateTime(2026)
          ..marketingOptIn = false
          ..createdAt = DateTime(2026)
          ..updatedAt = DateTime(2026),
      );
      when(authRepository.getCurrentUser).thenAnswer((_) async => user);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          authStateProvider.overrideWith(
            () => _FixedAuthStateNotifier(
              const AuthStatus.authenticated(isProvider: false),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(currentUserProvider.future);

      expect(result, same(user));
      verify(authRepository.getCurrentUser).called(1);
    },
  );
}

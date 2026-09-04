import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/auth/application/auth_flow_notifier.dart';
import 'package:sanaya/features/auth/application/auth_flow_state.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';
import 'package:sanaya/features/auth/data/auth_repository.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockAuthTokenStore extends Mock implements AuthTokenStore {}

class _MockVerifyResponse extends Mock
    implements V1AuthOtpVerifyPost200Response {}

class _MockUser extends Mock implements V1AuthOtpVerifyPost200ResponseUser {}

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
    // `submitOtp` arme `authStateProvider` (FM-05d) après succès, ce qui
    // force son `build()` — sans session à restaurer ici, seul le chemin
    // "pas de session persistée" nous intéresse pour ces tests.
    when(
      () => authTokenStore.restoreSession(),
    ).thenAnswer((_) async => false);
    container = _makeContainer(
      authRepository: authRepository,
      authTokenStore: authTokenStore,
    );
  });

  tearDown(() => container.dispose());

  test('état initial : démarre directement à l’étape téléphone (FM-33)', () {
    expect(container.read(authFlowProvider).step, AuthStep.phone);
  });

  group('submitPhone', () {
    test(
      'succès : avance à l’étape OTP et arme le compte à rebours de renvoi',
      () async {
        when(
          () => authRepository.requestOtp('+21622123456'),
        ).thenAnswer((_) async {});

        final ok = await container
            .read(authFlowProvider.notifier)
            .submitPhone('+21622123456');

        expect(ok, isTrue);
        final state = container.read(authFlowProvider);
        expect(state.step, AuthStep.otp);
        expect(state.phone, '+21622123456');
        expect(state.isSubmitting, isFalse);
        expect(state.canResendOtp, isFalse);
        expect(state.resendCountdownSeconds, greaterThan(55));
      },
    );

    test(
      'échec (RATE_LIMIT_EXCEEDED) : reste à l’étape téléphone, erreur exposée',
      () async {
        when(() => authRepository.requestOtp(any())).thenThrow(
          RateLimitException(message: 'Trop de demandes'),
        );

        final notifier = container.read(authFlowProvider.notifier);
        final ok = await notifier.submitPhone('+21622123456');

        expect(ok, isFalse);
        final state = container.read(authFlowProvider);
        expect(state.step, AuthStep.phone);
        expect(state.errorCode, 'RATE_LIMIT_EXCEEDED');
        expect(state.isSubmitting, isFalse);
      },
    );
  });

  group('resendOtp', () {
    test('refuse tant que le cooldown de 60s n’est pas écoulé', () async {
      when(
        () => authRepository.requestOtp('+21622123456'),
      ).thenAnswer((_) async {});
      final notifier = container.read(authFlowProvider.notifier);
      await notifier.submitPhone('+21622123456');

      final resent = await notifier.resendOtp();

      expect(resent, isFalse);
      verify(() => authRepository.requestOtp('+21622123456')).called(1);
    });

    test('sans numéro saisi, ne fait rien', () async {
      final resent = await container
          .read(authFlowProvider.notifier)
          .resendOtp();

      expect(resent, isFalse);
      verifyZeroInteractions(authRepository);
    });
  });

  group('submitOtp', () {
    test(
      'succès : ouvre la session (saveSession) et peuple verifiedUser',
      () async {
        final user = _MockUser();
        final response = _MockVerifyResponse();
        when(() => response.accessToken).thenReturn('access-xyz');
        when(() => response.refreshToken).thenReturn('session-id.token-id');
        when(() => response.user).thenReturn(user);
        when(() => user.roles).thenReturn(
          BuiltList<V1AuthOtpVerifyPost200ResponseUserRolesEnum>([
            V1AuthOtpVerifyPost200ResponseUserRolesEnum.CLIENT,
          ]),
        );
        when(
          () => authRepository.requestOtp('+21622123456'),
        ).thenAnswer((_) async {});
        when(
          () => authRepository.verifyOtp(
            phone: '+21622123456',
            code: '123456',
          ),
        ).thenAnswer((_) async => response);
        when(
          () => authTokenStore.saveSession(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        ).thenAnswer((_) async {});

        final notifier = container.read(authFlowProvider.notifier);
        await notifier.submitPhone('+21622123456');
        final ok = await notifier.submitOtp('123456');

        expect(ok, isTrue);
        final state = container.read(authFlowProvider);
        expect(state.verifiedUser, same(user));
        expect(state.isSubmitting, isFalse);
        verify(
          () => authTokenStore.saveSession(
            accessToken: 'access-xyz',
            refreshToken: 'session-id.token-id',
          ),
        ).called(1);
      },
    );

    test(
      'échec OTP_INVALID : expose errorCode et attemptsRemaining (BE-10e), '
      'n’ouvre pas de session',
      () async {
        when(
          () => authRepository.requestOtp('+21622123456'),
        ).thenAnswer((_) async {});
        when(
          () => authRepository.verifyOtp(
            phone: '+21622123456',
            code: '000000',
          ),
        ).thenThrow(
          UnauthorizedException(
            code: 'OTP_INVALID',
            message: 'Code invalide',
            details: const {'attemptsRemaining': 1},
          ),
        );

        final notifier = container.read(authFlowProvider.notifier);
        await notifier.submitPhone('+21622123456');
        final ok = await notifier.submitOtp('000000');

        expect(ok, isFalse);
        final state = container.read(authFlowProvider);
        expect(state.errorCode, 'OTP_INVALID');
        expect(state.attemptsRemaining, 1);
        expect(state.verifiedUser, isNull);
        verifyZeroInteractions(authTokenStore);
      },
    );

    test('sans numéro saisi, ne fait rien', () async {
      final ok = await container
          .read(authFlowProvider.notifier)
          .submitOtp('123456');

      expect(ok, isFalse);
      verifyZeroInteractions(authRepository);
    });
  });
}

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/auth/data/auth_repository.dart';

class _AuthApiMock extends Mock implements AuthApi {}

class _FakeV1AuthRefreshPostRequest extends Fake
    implements V1AuthRefreshPostRequest {}

class _FakeV1AuthOtpRequestPostRequest extends Fake
    implements V1AuthOtpRequestPostRequest {}

class _FakeV1AuthOtpVerifyPostRequest extends Fake
    implements V1AuthOtpVerifyPostRequest {}

Response<T> _okResponse<T>(String path, T data) => Response<T>(
  requestOptions: RequestOptions(path: path),
  statusCode: 200,
  data: data,
);

V1AuthOtpVerifyPost200ResponseUser _fakeUser({String phone = '+21622123456'}) =>
    V1AuthOtpVerifyPost200ResponseUser(
      (b) => b
        ..id = 'user-uuid'
        ..phone = phone
        ..phoneVerifiedAt = DateTime.utc(2026, 8, 28)
        ..email = 'artisan@example.com'
        ..emailVerifiedAt = DateTime.utc(2026, 8, 28)
        ..firstName = 'Ahmed'
        ..lastName = 'Ben Ali'
        ..avatarMediaId = 'media-uuid'
        ..roles.add(V1AuthOtpVerifyPost200ResponseUserRolesEnum.CLIENT)
        ..status = V1AuthOtpVerifyPost200ResponseUserStatusEnum.ACTIVE
        ..locale = 'fr'
        ..lastLoginAt = DateTime.utc(2026, 8, 28)
        ..marketingOptIn = false
        ..createdAt = DateTime.utc(2026, 8, 28)
        ..updatedAt = DateTime.utc(2026, 8, 28),
    );

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeV1AuthRefreshPostRequest());
    registerFallbackValue(_FakeV1AuthOtpRequestPostRequest());
    registerFallbackValue(_FakeV1AuthOtpVerifyPostRequest());
  });

  late _AuthApiMock authApi;
  late AuthRepository repository;

  setUp(() {
    authApi = _AuthApiMock();
    repository = AuthRepository(authApi);
  });

  group('AuthRepository.requestOtp', () {
    test('appelle v1AuthOtpRequestPost avec le numéro fourni', () async {
      when(
        () => authApi.v1AuthOtpRequestPost(
          v1AuthOtpRequestPostRequest: any(
            named: 'v1AuthOtpRequestPostRequest',
          ),
        ),
      ).thenAnswer(
        (_) async => _okResponse(
          '/v1/auth/otp/request',
          V1AuthOtpRequestPost200Response(
            (b) => b..status = V1AuthOtpRequestPost200ResponseStatusEnum.sent,
          ),
        ),
      );

      await repository.requestOtp('+21622123456');

      verify(
        () => authApi.v1AuthOtpRequestPost(
          v1AuthOtpRequestPostRequest: any(
            named: 'v1AuthOtpRequestPostRequest',
            that: isA<V1AuthOtpRequestPostRequest>().having(
              (r) => r.phone,
              'phone',
              '+21622123456',
            ),
          ),
        ),
      ).called(1);
    });

    test(
      'relance le SanayaApiException typé attaché au DioException (ex. '
      'RATE_LIMIT_EXCEEDED), pas le DioException lui-même',
      () async {
        final apiException = RateLimitException(
          message: 'Trop de demandes',
          details: const {'retryAfterSeconds': 3600},
        );
        when(
          () => authApi.v1AuthOtpRequestPost(
            v1AuthOtpRequestPostRequest: any(
              named: 'v1AuthOtpRequestPostRequest',
            ),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/v1/auth/otp/request'),
            error: apiException,
          ),
        );

        await expectLater(
          repository.requestOtp('+21622123456'),
          throwsA(same(apiException)),
        );
      },
    );
  });

  group('AuthRepository.verifyOtp', () {
    test(
      'retourne accessToken/refreshToken/user sur code correct',
      () async {
        final user = _fakeUser();
        when(
          () => authApi.v1AuthOtpVerifyPost(
            v1AuthOtpVerifyPostRequest: any(
              named: 'v1AuthOtpVerifyPostRequest',
            ),
          ),
        ).thenAnswer(
          (_) async => _okResponse(
            '/v1/auth/otp/verify',
            V1AuthOtpVerifyPost200Response(
              (b) => b
                ..accessToken = 'access-xyz'
                ..refreshToken = 'session-id.token-id'
                ..user.replace(user),
            ),
          ),
        );

        final result = await repository.verifyOtp(
          phone: '+21622123456',
          code: '123456',
        );

        expect(result.accessToken, 'access-xyz');
        expect(result.refreshToken, 'session-id.token-id');
        expect(result.user.phone, '+21622123456');
        verify(
          () => authApi.v1AuthOtpVerifyPost(
            v1AuthOtpVerifyPostRequest: any(
              named: 'v1AuthOtpVerifyPostRequest',
              that: isA<V1AuthOtpVerifyPostRequest>()
                  .having((r) => r.phone, 'phone', '+21622123456')
                  .having((r) => r.code, 'code', '123456'),
            ),
          ),
        ).called(1);
      },
    );

    test(
      'relance le SanayaApiException typé (OTP_INVALID + '
      'details.attemptsRemaining, BE-10e), pas le DioException lui-même',
      () async {
        final apiException = UnauthorizedException(
          code: 'OTP_INVALID',
          message: 'Code invalide',
          details: const {'attemptsRemaining': 2},
        );
        when(
          () => authApi.v1AuthOtpVerifyPost(
            v1AuthOtpVerifyPostRequest: any(
              named: 'v1AuthOtpVerifyPostRequest',
            ),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/v1/auth/otp/verify'),
            error: apiException,
          ),
        );

        await expectLater(
          repository.verifyOtp(phone: '+21622123456', code: '000000'),
          throwsA(same(apiException)),
        );
      },
    );
  });

  group('AuthRepository.logout', () {
    test('appelle v1AuthLogoutPost si un refresh token est fourni', () async {
      when(
        () => authApi.v1AuthLogoutPost(
          v1AuthRefreshPostRequest: any(named: 'v1AuthRefreshPostRequest'),
        ),
      ).thenAnswer(
        (_) async => _okResponse(
          '/v1/auth/logout',
          V1AuthLogoutPost200Response(
            (b) => b..status = V1AuthLogoutPost200ResponseStatusEnum.ok,
          ),
        ),
      );

      await repository.logout(refreshToken: 'token-xyz-123');

      verify(
        () => authApi.v1AuthLogoutPost(
          v1AuthRefreshPostRequest: any(
            named: 'v1AuthRefreshPostRequest',
            that: isA<V1AuthRefreshPostRequest>().having(
              (r) => r.refreshToken,
              'refreshToken',
              'token-xyz-123',
            ),
          ),
        ),
      ).called(1);
    });

    test('ne fait rien si aucun refresh token n’est fourni', () async {
      await repository.logout();
      await repository.logout(refreshToken: '');

      verifyNever(
        () => authApi.v1AuthLogoutPost(
          v1AuthRefreshPostRequest: any(named: 'v1AuthRefreshPostRequest'),
        ),
      );
    });
  });
}

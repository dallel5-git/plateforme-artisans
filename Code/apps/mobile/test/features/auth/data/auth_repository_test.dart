import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/auth/data/auth_repository.dart';

class _AuthApiMock extends Mock implements AuthApi {}

class _FakeV1AuthRefreshPostRequest extends Fake
    implements V1AuthRefreshPostRequest {}

Response<T> _okResponse<T>(String path, T data) => Response<T>(
  requestOptions: RequestOptions(path: path),
  statusCode: 200,
  data: data,
);

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeV1AuthRefreshPostRequest());
  });

  late _AuthApiMock authApi;
  late AuthRepository repository;

  setUp(() {
    authApi = _AuthApiMock();
    repository = AuthRepository(authApi);
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

import 'package:sanaya/core/api/generated/api.dart';

/// Repository pour l'authentification et les sessions (BE-10, FM-05, FM-13).
/// Aucune règle métier en Dart (P3) : délègue directement à `AuthApi`.
class AuthRepository {
  const AuthRepository(this._authApi);

  final AuthApi _authApi;

  Future<void> requestOtp({required String phone}) => unwrapDioErrors(
    () async {
      await _authApi.v1AuthOtpRequestPost(
        v1AuthOtpRequestPostRequest: V1AuthOtpRequestPostRequest(
          (b) => b..phone = phone,
        ),
      );
    },
  );

  Future<V1AuthOtpVerifyPost200Response> verifyOtp({
    required String phone,
    required String code,
  }) => unwrapDioErrors(
    () async => (await _authApi.v1AuthOtpVerifyPost(
      v1AuthOtpVerifyPostRequest: V1AuthOtpVerifyPostRequest(
        (b) => b
          ..phone = phone
          ..code = code,
      ),
    )).data!,
  );

  /// Révoque la session sur le serveur lors de la déconnexion (BE-10d).
  /// Idempotent.
  Future<void> logout({String? refreshToken}) async {
    if (refreshToken != null && refreshToken.isNotEmpty) {
      final request = V1AuthRefreshPostRequest(
        (b) => b..refreshToken = refreshToken,
      );
      await _authApi.v1AuthLogoutPost(v1AuthRefreshPostRequest: request);
    }
  }
}

import 'package:sanaya/core/api/generated/api.dart';

/// Repository pour l'authentification et les sessions (BE-10, FM-05, FM-13).
/// Aucune règle métier en Dart (P3) : délègue directement à `AuthApi`, pas de
/// modèle de domaine réécrit à la main (P4) — les réponses générées sont
/// renvoyées telles quelles.
class AuthRepository {
  const AuthRepository(this._authApi);

  final AuthApi _authApi;

  /// Demande un code OTP par SMS. Réponse identique que le numéro existe
  /// déjà ou non côté serveur (anti-énumération) — rien à distinguer ici.
  Future<void> requestOtp(String phone) async {
    await unwrapDioErrors(
      () => _authApi.v1AuthOtpRequestPost(
        v1AuthOtpRequestPostRequest: V1AuthOtpRequestPostRequest(
          (b) => b.phone = phone,
        ),
      ),
    );
  }

  /// Vérifie le code OTP et renvoie les tokens de session + l'utilisateur
  /// (créé au besoin côté serveur). Sur code invalide, l'appelant retrouve
  /// `details['attemptsRemaining']` sur le [SanayaApiException] levé par
  /// [unwrapDioErrors] (BE-10e).
  Future<V1AuthOtpVerifyPost200Response> verifyOtp({
    required String phone,
    required String code,
  }) async {
    final response = await unwrapDioErrors(
      () => _authApi.v1AuthOtpVerifyPost(
        v1AuthOtpVerifyPostRequest: V1AuthOtpVerifyPostRequest(
          (b) => b
            ..phone = phone
            ..code = code,
        ),
      ),
    );
    return response.data!;
  }

  /// Profil de l'utilisateur authentifié (FM-05d) — utilisé au démarrage de
  /// l'app pour déterminer le rôle après restauration de session, la
  /// réponse d'`otp/verify` ne survivant pas à un redémarrage.
  Future<V1AuthMeGet200Response> getCurrentUser() async {
    final response = await unwrapDioErrors(_authApi.v1AuthMeGet);
    return response.data!;
  }

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

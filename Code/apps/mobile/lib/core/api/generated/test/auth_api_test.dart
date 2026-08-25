import 'package:test/test.dart';
import 'package:sanaya_api_client/sanaya_api_client.dart';

/// tests for AuthApi
void main() {
  final instance = SanayaApiClient().getAuthApi();

  group(AuthApi, () {
    // Révoque la session associée au refresh token présenté. Idempotent.
    //
    //Future<V1AuthLogoutPost200Response> v1AuthLogoutPost(V1AuthRefreshPostRequest v1AuthRefreshPostRequest) async
    test('test v1AuthLogoutPost', () async {
      // TODO
    });

    // Profil de l'utilisateur authentifié, rôles inclus.
    //
    //Future<V1AuthMeGet200Response> v1AuthMeGet() async
    test('test v1AuthMeGet', () async {
      // TODO
    });

    // Demande un code OTP par SMS. Réponse identique, que le numéro existe déjà ou non (anti-énumération). Rate-limit : 5/h par numéro et par IP.
    //
    //Future<V1AuthOtpRequestPost200Response> v1AuthOtpRequestPost(V1AuthOtpRequestPostRequest v1AuthOtpRequestPostRequest) async
    test('test v1AuthOtpRequestPost', () async {
      // TODO
    });

    // Vérifie le code OTP, crée le compte au besoin, émet les tokens de session.
    //
    //Future<V1AuthOtpVerifyPost200Response> v1AuthOtpVerifyPost(V1AuthOtpVerifyPostRequest v1AuthOtpVerifyPostRequest) async
    test('test v1AuthOtpVerifyPost', () async {
      // TODO
    });

    // Fait tourner le refresh token. Un rejeu révoque toute la famille de sessions.
    //
    //Future<AuthTokens> v1AuthRefreshPost(V1AuthRefreshPostRequest v1AuthRefreshPostRequest) async
    test('test v1AuthRefreshPost', () async {
      // TODO
    });
  });
}

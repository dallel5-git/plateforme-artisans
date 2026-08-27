import 'dart:async';

import 'package:dio/dio.dart';

import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/api/exceptions.dart';

/// Chemins qui ne doivent jamais porter d'`Authorization` sortant, ni
/// déclencher de refresh sur un 401 : OTP (avant authentification) et
/// refresh/logout eux-mêmes (évite toute récursion — un 401 sur
/// `/v1/auth/refresh` ne doit jamais retenter un refresh).
const _authExemptPaths = [
  '/v1/auth/otp/request',
  '/v1/auth/otp/verify',
  '/v1/auth/refresh',
  '/v1/auth/logout',
];

bool _isAuthExempt(String path) =>
    _authExemptPaths.any((exempt) => path.endsWith(exempt));

/// Attache `Authorization: Bearer <token>` à chaque requête (sauf OTP/
/// refresh/logout) et, sur un 401, déclenche un refresh transparent
/// (single-flight, voir `AuthTokenStore.refresh`) puis rejoue la requête
/// d'origine — une seule fois, jamais deux, pour ne pas boucler sur un
/// token définitivement invalide.
///
/// [dio] doit être assigné juste après construction, avant toute requête —
/// c'est l'instance sur laquelle cet intercepteur est lui-même enregistré
/// (nécessaire pour rejouer une requête via `dio.fetch`, cf.
/// `api_client_provider.dart` : `buildApiClient()` doit exister avant que
/// l'intercepteur puisse s'y référencer, d'où l'assignation en deux temps).
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStore);

  final AuthTokenStore _tokenStore;
  late final Dio dio;

  static const _retriedFlag = 'sanaya.auth.retried';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!_isAuthExempt(options.path)) {
      final token = _tokenStore.accessToken;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    unawaited(_handleError(err, handler));
  }

  // `void onError(...) async` ne peut pas déclarer `Future<void>` sans casser
  // l'override de `Interceptor.onError` (déclaré `void`) — la logique async
  // vit donc ici, appelée en fire-and-forget depuis onError : c'est
  // ErrorInterceptorHandler (next/resolve/reject), pas la valeur de retour
  // de onError, qui complète effectivement la requête.
  Future<void> _handleError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final alreadyRetried = options.extra[_retriedFlag] == true;
    if (err.response?.statusCode != 401 ||
        _isAuthExempt(options.path) ||
        alreadyRetried) {
      handler.next(err);
      return;
    }

    try {
      await _tokenStore.refresh();
    } on SanayaApiException {
      // Le refresh a déjà purgé les tokens (AuthTokenStore.clear) — laisser
      // le 401 d'origine remonter tel quel plutôt que masquer la cause.
      handler.next(err);
      return;
    }

    try {
      final retryOptions = options.copyWith(
        extra: {...options.extra, _retriedFlag: true},
      );
      final response = await dio.fetch<dynamic>(retryOptions);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}

import 'dart:async';

import 'package:dio/dio.dart';

/// Délais entre chaque tentative (300 ms, puis 900 ms) — P5, réseau dégradé,
/// `apps/mobile/CLAUDE.md`.
const _retryDelays = [Duration(milliseconds: 300), Duration(milliseconds: 900)];

const _retryCountKey = 'sanaya.retry.count';

/// `GET` uniquement (idempotent) — un `POST`/`PUT`/`PATCH`/`DELETE` rejoué
/// automatiquement risquerait une double écriture (P5, CLAUDE.md §4.2).
bool shouldRetryForTest({required String method}) =>
    method.toUpperCase() == 'GET';

bool _isTransientError(DioException err) {
  switch (err.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return true;
    case DioExceptionType.badResponse:
      // 5xx seulement : une erreur 4xx est définitive, la rejouer ne change
      // rien et retarde inutilement l'exception vue par l'appelant.
      return (err.response?.statusCode ?? 0) >= 500;
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.transformTimeout:
    case DioExceptionType.unknown:
      return false;
  }
}

/// Rejoue jusqu'à 2 fois, avec backoff, une requête `GET` en échec sur une
/// erreur transitoire (timeout, connexion, 5xx). Comme `AuthInterceptor`,
/// [dio] doit être assigné juste après construction — nécessaire pour
/// rejouer via `dio.fetch`, cf. `api_client_provider.dart`.
class RetryInterceptor extends Interceptor {
  late final Dio dio;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    unawaited(_handleError(err, handler));
  }

  Future<void> _handleError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final attempt = (options.extra[_retryCountKey] as int?) ?? 0;

    if (!shouldRetryForTest(method: options.method) ||
        !_isTransientError(err) ||
        attempt >= _retryDelays.length) {
      handler.next(err);
      return;
    }

    await Future<void>.delayed(_retryDelays[attempt]);

    try {
      final retryOptions = options.copyWith(
        extra: {...options.extra, _retryCountKey: attempt + 1},
      );
      final response = await dio.fetch<dynamic>(retryOptions);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}

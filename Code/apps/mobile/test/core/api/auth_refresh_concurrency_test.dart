import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sanaya/core/api/api_client.dart';
import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/api/interceptors/auth_interceptor.dart';
import 'package:sanaya/core/api/interceptors/retry_interceptor.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

/// Adaptateur factice partagé entre le `Dio` principal (requêtes protégées)
/// et le `Dio` nu du refresh (`AuthTokenStore._refreshDio`) — route sur
/// `options.path`, comme les deux endpoints réels partagent la même base
/// URL en production. Un délai artificiel sur `/v1/auth/refresh` garantit
/// que les deux requêtes concurrentes ont bien le temps d'appeler
/// `AuthTokenStore.refresh()` avant que le premier refresh ne se termine —
/// sans ça, un test rapide passerait même si le single-flight était cassé,
/// par pure coïncidence de timing (`Future.wait` lance les deux requêtes
/// quasi simultanément, mais chacune traverse plusieurs `await` avant
/// d'atteindre `refresh()`).
class _RoutingAdapter implements HttpClientAdapter {
  final Map<String, int> callCounts = {};

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    callCounts.update(
      options.path,
      (count) => count + 1,
      ifAbsent: () => 1,
    );

    if (options.path == '/v1/auth/refresh') {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return _jsonResponse(200, {
        'accessToken': 'new-access-token',
        'refreshToken': 'new-refresh-token',
      });
    }

    final authHeader = options.headers['Authorization'] as String?;
    if (authHeader == 'Bearer new-access-token') {
      return _jsonResponse(200, {'items': <dynamic>[]});
    }
    return _jsonResponse(401, {
      'error': {'code': 'ACCESS_TOKEN_EXPIRED', 'message': 'token expiré'},
    });
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _jsonResponse(int statusCode, Map<String, dynamic> body) =>
    ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

void main() {
  test(
    '🔒 NON-RÉGRESSION FM-02g — deux requêtes concurrentes avec un token '
    'expiré ne déclenchent qu’UN SEUL refresh, toutes deux aboutissent '
    '(critère d’acceptation issue #33)',
    () async {
      final adapter = _RoutingAdapter();
      final secureStorage = _MockSecureStorage();
      when(
        () => secureStorage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => 'old-refresh-token');
      when(
        () => secureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => secureStorage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});

      final refreshDio = Dio()..httpClientAdapter = adapter;
      final tokenStore = AuthTokenStore(
        secureStorage: secureStorage,
        refreshDio: refreshDio,
      );

      final authInterceptor = AuthInterceptor(tokenStore);
      final retryInterceptor = RetryInterceptor();
      final dio = buildApiClient(
        interceptors: [authInterceptor, retryInterceptor],
      )..httpClientAdapter = adapter;
      authInterceptor.dio = dio;
      retryInterceptor.dio = dio;

      final responses = await Future.wait([
        dio.get<dynamic>('/v1/providers'),
        dio.get<dynamic>('/v1/providers'),
      ]);

      expect(responses[0].statusCode, 200);
      expect(responses[1].statusCode, 200);
      expect(adapter.callCounts['/v1/auth/refresh'], 1);
      // 2 tentatives initiales (401) + 2 rejeux (200) par requête protégée.
      expect(adapter.callCounts['/v1/providers'], 4);
    },
  );
}

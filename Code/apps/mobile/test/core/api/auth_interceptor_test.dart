import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/api/exceptions.dart';
import 'package:sanaya/core/api/interceptors/auth_interceptor.dart';
import 'package:sanaya/core/api/interceptors/error_mapping_interceptor.dart';

class _MockAuthTokenStore extends Mock implements AuthTokenStore {}

/// Adaptateur factice qui rejoue une réponse scriptée par appel (la première
/// pour le 401 initial, la seconde pour la requête rejouée après refresh).
class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this._responses);

  final List<ResponseBody> _responses;
  int callCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final response = _responses[callCount.clamp(0, _responses.length - 1)];
    callCount++;
    return response;
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
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/v1/test'));
  });

  group('FM-02d — AuthInterceptor', () {
    test(
      'attache Authorization: Bearer <token> sur une requête ordinaire',
      () async {
        final tokenStore = _MockAuthTokenStore();
        when(() => tokenStore.accessToken).thenReturn('tok-123');

        RequestOptions? captured;
        final adapter = _ScriptedAdapter([
          _jsonResponse(200, {'ok': true}),
        ]);
        final dio = Dio()..httpClientAdapter = adapter;
        final authInterceptor = AuthInterceptor(tokenStore)..dio = dio;
        dio.interceptors.add(authInterceptor);
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              captured = options;
              handler.next(options);
            },
          ),
        );

        await dio.get<dynamic>('/v1/providers/search');

        expect(captured!.headers['Authorization'], 'Bearer tok-123');
      },
    );

    test(
      "n'attache aucun Authorization sur /v1/auth/otp/request ou "
      '/v1/auth/refresh',
      () async {
        final tokenStore = _MockAuthTokenStore();
        when(() => tokenStore.accessToken).thenReturn('tok-123');

        final captured = <RequestOptions>[];
        final adapter = _ScriptedAdapter([
          _jsonResponse(200, {'status': 'sent'}),
          _jsonResponse(200, {'accessToken': 'a', 'refreshToken': 'b'}),
        ]);
        final dio = Dio()..httpClientAdapter = adapter;
        final authInterceptor = AuthInterceptor(tokenStore)..dio = dio;
        dio.interceptors.add(authInterceptor);
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              captured.add(options);
              handler.next(options);
            },
          ),
        );

        await dio.post<dynamic>('/v1/auth/otp/request', data: {'phone': 'x'});
        await dio.post<dynamic>(
          '/v1/auth/refresh',
          data: {'refreshToken': 'x'},
        );

        expect(captured, hasLength(2));
        for (final options in captured) {
          expect(options.headers.containsKey('Authorization'), isFalse);
        }
      },
    );

    test(
      '🔒 NON-RÉGRESSION — un 401 déclenche UN SEUL refresh puis rejoue la '
      "requête d'origine",
      () async {
        final tokenStore = _MockAuthTokenStore();
        when(() => tokenStore.accessToken).thenReturn('old-token');
        var refreshCount = 0;
        when(tokenStore.refresh).thenAnswer((_) async {
          refreshCount++;
          return 'new-token';
        });

        final adapter = _ScriptedAdapter([
          _jsonResponse(401, {
            'error': {'code': 'ACCESS_TOKEN_EXPIRED', 'message': 'Expiré'},
          }),
          _jsonResponse(200, {'ok': true}),
        ]);
        final dio = Dio()..httpClientAdapter = adapter;
        final authInterceptor = AuthInterceptor(tokenStore)..dio = dio;
        dio.interceptors.add(authInterceptor);

        final response = await dio.get<Map<String, dynamic>>(
          '/v1/providers/search',
        );

        expect(response.data, {'ok': true});
        expect(refreshCount, 1);
        expect(adapter.callCount, 2);
      },
    );

    test(
      'si le refresh lui-même échoue, le 401 remonte tel quel (pas de '
      'deuxième tentative)',
      () async {
        final tokenStore = _MockAuthTokenStore();
        when(() => tokenStore.accessToken).thenReturn('old-token');
        when(tokenStore.refresh).thenThrow(UnauthorizedException());

        final adapter = _ScriptedAdapter([
          _jsonResponse(401, {
            'error': {'code': 'ACCESS_TOKEN_EXPIRED', 'message': 'Expiré'},
          }),
        ]);
        final dio = Dio()..httpClientAdapter = adapter;
        final authInterceptor = AuthInterceptor(tokenStore)..dio = dio;
        dio.interceptors.add(authInterceptor);
        dio.interceptors.add(ErrorMappingInterceptor());

        await expectLater(
          dio.get<dynamic>('/v1/providers/search'),
          throwsA(isA<DioException>()),
        );
        expect(adapter.callCount, 1);
      },
    );

    test(
      'un 401 sur /v1/auth/refresh lui-même ne redéclenche pas de refresh '
      '(anti-récursion)',
      () async {
        final tokenStore = _MockAuthTokenStore();
        when(() => tokenStore.accessToken).thenReturn('old-token');

        final adapter = _ScriptedAdapter([
          _jsonResponse(401, {
            'error': {'code': 'REFRESH_TOKEN_INVALID', 'message': 'Invalide'},
          }),
        ]);
        final dio = Dio()..httpClientAdapter = adapter;
        final authInterceptor = AuthInterceptor(tokenStore)..dio = dio;
        dio.interceptors.add(authInterceptor);
        dio.interceptors.add(ErrorMappingInterceptor());

        await expectLater(
          dio.post<dynamic>('/v1/auth/refresh', data: {'refreshToken': 'x'}),
          throwsA(isA<DioException>()),
        );
        verifyNever(tokenStore.refresh);
      },
    );
  });
}

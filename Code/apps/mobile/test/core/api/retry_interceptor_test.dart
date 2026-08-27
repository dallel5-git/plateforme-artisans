import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/api/interceptors/retry_interceptor.dart';

/// Adaptateur factice minimal — même approche que
/// error_mapping_interceptor_test.dart : pas de dépendance de test
/// supplémentaire pour un seul point d’usage.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._respond);

  final ResponseBody Function(RequestOptions options) _respond;
  int callCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    callCount++;
    return _respond(options);
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

Dio _buildDio(_FakeAdapter adapter) {
  final interceptor = RetryInterceptor();
  final dio = Dio()
    ..httpClientAdapter = adapter
    ..interceptors.add(interceptor);
  interceptor.dio = dio;
  return dio;
}

void main() {
  group('FM-02e — shouldRetryForTest (GET uniquement)', () {
    test('true pour GET', () {
      expect(shouldRetryForTest(method: 'GET'), isTrue);
      expect(shouldRetryForTest(method: 'get'), isTrue);
    });

    test('false pour POST/PUT/PATCH/DELETE', () {
      expect(shouldRetryForTest(method: 'POST'), isFalse);
      expect(shouldRetryForTest(method: 'PUT'), isFalse);
      expect(shouldRetryForTest(method: 'PATCH'), isFalse);
      expect(shouldRetryForTest(method: 'DELETE'), isFalse);
    });
  });

  group('FM-02e — RetryInterceptor', () {
    test(
      'un GET qui échoue en connexion est rejoué jusqu’à 2 fois puis réussit',
      () async {
        var attempt = 0;
        final adapter = _FakeAdapter((options) {
          attempt++;
          if (attempt < 3) {
            throw DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
            );
          }
          return _jsonResponse(200, {'ok': true});
        });
        final dio = _buildDio(adapter);

        final response = await dio.get<Map<String, dynamic>>('/v1/test');

        expect(response.data, {'ok': true});
        expect(adapter.callCount, 3); // 1 tentative + 2 retries
      },
    );

    test(
      'un GET qui échoue toujours est rejoué au maximum 2 fois (3 appels), '
      'puis l’erreur remonte',
      () async {
        final adapter = _FakeAdapter(
          (options) => throw DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
          ),
        );
        final dio = _buildDio(adapter);

        await expectLater(
          dio.get<dynamic>('/v1/test'),
          throwsA(isA<DioException>()),
        );
        expect(adapter.callCount, 3);
      },
    );

    test('un POST qui échoue en connexion n’est jamais rejoué', () async {
      final adapter = _FakeAdapter(
        (options) => throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
        ),
      );
      final dio = _buildDio(adapter);

      await expectLater(
        dio.post<dynamic>('/v1/test'),
        throwsA(isA<DioException>()),
      );
      expect(adapter.callCount, 1);
    });

    test('un GET en erreur 404 (non transitoire) n’est pas rejoué', () async {
      final adapter = _FakeAdapter(
        (_) => _jsonResponse(404, {
          'error': {'code': 'NOT_FOUND', 'message': 'introuvable'},
        }),
      );
      final dio = _buildDio(adapter);

      await expectLater(
        dio.get<dynamic>('/v1/test'),
        throwsA(isA<DioException>()),
      );
      expect(adapter.callCount, 1);
    });

    test('un GET en erreur 503 (serveur, transitoire) est rejoué', () async {
      var attempt = 0;
      final adapter = _FakeAdapter((_) {
        attempt++;
        if (attempt < 2) {
          return _jsonResponse(503, {
            'error': {'code': 'INTERNAL_ERROR', 'message': 'indisponible'},
          });
        }
        return _jsonResponse(200, {'ok': true});
      });
      final dio = _buildDio(adapter);

      final response = await dio.get<Map<String, dynamic>>('/v1/test');

      expect(response.data, {'ok': true});
      expect(adapter.callCount, 2);
    });
  });
}

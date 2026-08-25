import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/api/exceptions.dart';
import 'package:sanaya/core/api/interceptors/error_mapping_interceptor.dart';

/// Adaptateur factice minimal — pas de dépendance de test supplémentaire
/// (mocktail, http_mock_adapter) pour un seul point d'usage : implémente
/// directement l'interface publique `HttpClientAdapter` de dio.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._respond);

  final ResponseBody Function(RequestOptions options) _respond;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => _respond(options);

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
  group('FM-02c — ErrorMappingInterceptor', () {
    test(
      'un 401 réel (via Dio + adaptateur factice) ressort comme UnauthorizedException',
      () async {
        final dio = Dio()
          ..httpClientAdapter = _FakeAdapter(
            (_) => _jsonResponse(401, {
              'error': {'code': 'UNAUTHORIZED', 'message': 'Non authentifié'},
              'requestId': 'r1',
            }),
          )
          ..interceptors.add(ErrorMappingInterceptor());

        try {
          await dio.get<dynamic>('/v1/test');
          fail('devait lancer un DioException');
        } on DioException catch (e) {
          expect(e.error, isA<UnauthorizedException>());
          expect((e.error! as UnauthorizedException).requestId, 'r1');
        }
      },
    );

    test(
      'une réponse 200 normale traverse sans passer par le mapping',
      () async {
        final dio = Dio()
          ..httpClientAdapter = _FakeAdapter(
            (_) => _jsonResponse(200, {'ok': true}),
          )
          ..interceptors.add(ErrorMappingInterceptor());

        final response = await dio.get<Map<String, dynamic>>('/v1/test');
        expect(response.data, {'ok': true});
      },
    );
  });
}

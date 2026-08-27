import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/core/api/exceptions.dart';

DioException _errorResponse(
  int statusCode, {
  Object? data,
}) {
  final options = RequestOptions(path: '/v1/test');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response(
      requestOptions: options,
      statusCode: statusCode,
      data: data,
    ),
  );
}

void main() {
  group('FM-02c — mapping des erreurs API vers des exceptions typées', () {
    test('timeout → NetworkException, quel que soit le type précis', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionError,
      ]) {
        final err = DioException(
          requestOptions: RequestOptions(path: '/v1/test'),
          type: type,
        );
        expect(mapDioExceptionToApiException(err), isA<NetworkException>());
      }
    });

    test(
      'pas de réponse (type inconnu, sans statusCode) → NetworkException',
      () {
        final err = DioException(
          requestOptions: RequestOptions(path: '/v1/test'),
        );
        expect(mapDioExceptionToApiException(err), isA<NetworkException>());
      },
    );

    test(
      "401 → UnauthorizedException, code/message/requestId de l'enveloppe repris tels quels",
      () {
        final err = _errorResponse(
          401,
          data: {
            'error': {
              'code': 'ACCESS_TOKEN_EXPIRED',
              'message': 'Token expiré',
              'details': {'x': 1},
            },
            'requestId': 'req-1',
          },
        );
        final mapped = mapDioExceptionToApiException(err);
        expect(mapped, isA<UnauthorizedException>());
        expect(mapped.code, 'ACCESS_TOKEN_EXPIRED');
        expect(mapped.message, 'Token expiré');
        expect(mapped.requestId, 'req-1');
        expect(mapped.details, {'x': 1});
      },
    );

    test('403 → ForbiddenException', () {
      expect(
        mapDioExceptionToApiException(_errorResponse(403)),
        isA<ForbiddenException>(),
      );
    });

    test('404 → NotFoundException', () {
      expect(
        mapDioExceptionToApiException(_errorResponse(404)),
        isA<NotFoundException>(),
      );
    });

    test('400 et 422 → ValidationException', () {
      expect(
        mapDioExceptionToApiException(_errorResponse(400)),
        isA<ValidationException>(),
      );
      expect(
        mapDioExceptionToApiException(_errorResponse(422)),
        isA<ValidationException>(),
      );
    });

    test('429 → RateLimitException', () {
      expect(
        mapDioExceptionToApiException(_errorResponse(429)),
        isA<RateLimitException>(),
      );
    });

    test('5xx → ServerException', () {
      expect(
        mapDioExceptionToApiException(_errorResponse(500)),
        isA<ServerException>(),
      );
      expect(
        mapDioExceptionToApiException(_errorResponse(503)),
        isA<ServerException>(),
      );
    });

    test(
      'statut inattendu (ex. 418) → ServerException, repli sans planter',
      () {
        expect(
          mapDioExceptionToApiException(_errorResponse(418)),
          isA<ServerException>(),
        );
      },
    );

    test(
      'enveloppe absente ou malformée (corps texte brut) → repli sans planter',
      () {
        final mapped = mapDioExceptionToApiException(
          _errorResponse(500, data: 'plain text'),
        );
        expect(mapped, isA<ServerException>());
        expect(mapped.code, isNotEmpty);
        expect(mapped.message, isNotEmpty);
      },
    );

    // 🔒 Contrat exigé tel quel par contact_flow_test.dart (FM-09/FM-02, pré-écrit) —
    // ne pas changer ces signatures sans mettre à jour ce test-là.
    test('UnauthorizedException() sans argument', () {
      expect(UnauthorizedException(), isA<UnauthorizedException>());
    });

    test('NetworkException(message) positionnel', () {
      expect(NetworkException('hors ligne').message, 'hors ligne');
    });
  });

  group('FM-02c — unwrapDioErrors', () {
    test(
      'relance le SanayaApiException porté par '
      'DioException.error, pas le DioException lui-même',
      () async {
        final options = RequestOptions(path: '/v1/test');
        final apiException = UnauthorizedException();
        Future<int> call() => Future<int>.error(
          DioException(requestOptions: options, error: apiException),
        );

        await expectLater(unwrapDioErrors(call), throwsA(same(apiException)));
      },
    );

    test(
      'laisse passer un DioException sans SanayaApiException attaché',
      () async {
        final options = RequestOptions(path: '/v1/test');
        Future<int> call() =>
            Future<int>.error(DioException(requestOptions: options));

        await expectLater(unwrapDioErrors(call), throwsA(isA<DioException>()));
      },
    );

    test('laisse passer la valeur de retour normale', () async {
      expect(await unwrapDioErrors(() async => 42), 42);
    });
  });
}

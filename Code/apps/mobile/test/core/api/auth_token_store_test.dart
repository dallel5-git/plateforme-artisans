import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/api/exceptions.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

/// Adaptateur factice qui compte ses appels — sert à vérifier le
/// single-flight (un seul appel réseau pour N `refresh()` concurrents).
class _CountingAdapter implements HttpClientAdapter {
  _CountingAdapter(this._respond);

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

void main() {
  late _MockSecureStorage secureStorage;
  late _CountingAdapter adapter;
  late AuthTokenStore store;

  AuthTokenStore buildStore(
    ResponseBody Function(RequestOptions) respond,
  ) {
    adapter = _CountingAdapter(respond);
    final refreshDio = Dio()..httpClientAdapter = adapter;
    return AuthTokenStore(secureStorage: secureStorage, refreshDio: refreshDio);
  }

  setUp(() {
    secureStorage = _MockSecureStorage();
    when(
      () => secureStorage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => 'stored-refresh-token');
    when(
      () => secureStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => secureStorage.delete(key: any(named: 'key')),
    ).thenAnswer((_) async {});
    store = buildStore(
      (_) => _jsonResponse(200, {
        'accessToken': 'new-access',
        'refreshToken': 'new-refresh',
      }),
    );
  });

  group('FM-02d — AuthTokenStore', () {
    test(
      'refresh() réussi met à jour accessToken et persiste le nouveau '
      'refreshToken',
      () async {
        final token = await store.refresh();

        expect(token, 'new-access');
        expect(store.accessToken, 'new-access');
        verify(
          () => secureStorage.write(
            key: any(named: 'key'),
            value: 'new-refresh',
          ),
        ).called(1);
      },
    );

    test(
      "🔒 NON-RÉGRESSION — deux refresh() concurrents ne déclenchent qu'UN "
      'SEUL appel réseau (single-flight)',
      () async {
        final results = await Future.wait([store.refresh(), store.refresh()]);

        expect(results, ['new-access', 'new-access']);
        expect(adapter.callCount, 1);
      },
    );

    test(
      'un refresh() lancé après complétion du précédent en déclenche un '
      'nouveau (pas de single-flight permanent)',
      () async {
        await store.refresh();
        await store.refresh();

        expect(adapter.callCount, 2);
      },
    );

    test(
      '🔒 NON-RÉGRESSION — un échec de refresh purge les tokens (pas de '
      'boucle sur un token définitivement invalide)',
      () async {
        store = buildStore(
          (_) => _jsonResponse(401, {
            'error': {
              'code': 'REFRESH_TOKEN_REUSED',
              'message': 'Rejeu détecté',
            },
          }),
        );

        await expectLater(
          store.refresh(),
          throwsA(isA<UnauthorizedException>()),
        );

        expect(store.accessToken, isNull);
        verify(() => secureStorage.delete(key: any(named: 'key'))).called(1);
      },
    );

    test(
      'aucun refresh token en stockage → échoue sans appel réseau',
      () async {
        when(
          () => secureStorage.read(key: any(named: 'key')),
        ).thenAnswer((_) async => null);

        await expectLater(
          store.refresh(),
          throwsA(isA<UnauthorizedException>()),
        );

        expect(adapter.callCount, 0);
      },
    );

    test(
      "🔒 NON-RÉGRESSION — le refresh token n'est jamais lu depuis "
      'SharedPreferences',
      () async {
        await store.refresh();

        verify(
          () => secureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).called(1);
      },
    );

    test(
      'saveSession() (FM-05) peuple accessToken et persiste refreshToken '
      'sans appel réseau',
      () async {
        await store.saveSession(
          accessToken: 'otp-access',
          refreshToken: 'otp-refresh',
        );

        expect(store.accessToken, 'otp-access');
        verify(
          () => secureStorage.write(
            key: any(named: 'key'),
            value: 'otp-refresh',
          ),
        ).called(1);
        expect(adapter.callCount, 0);
      },
    );

    // ── MOB-002 ────────────────────────────────────────────────────────────
    test(
      'MOB-002 — erreur réseau (connectionError) : clear() NON appelé, '
      'token conservé // régression #MOB-002',
      () async {
        // Adaptateur qui simule une panne réseau
        // (DioExceptionType.connectionError) sans aucune réponse HTTP.
        final networkAdapter = _CountingAdapter((_) {
          throw DioException(
            requestOptions: RequestOptions(path: '/v1/auth/refresh'),
            type: DioExceptionType.connectionError,
          );
        });
        final refreshDio = Dio()..httpClientAdapter = networkAdapter;
        final networkStore = AuthTokenStore(
          secureStorage: secureStorage,
          refreshDio: refreshDio,
        );

        await expectLater(
          networkStore.refresh(),
          throwsA(isA<Exception>()),
        );

        // Le token doit rester intact — delete() ne doit PAS être appelé.
        verifyNever(() => secureStorage.delete(key: any(named: 'key')));
      },
    );

    test(
      'MOB-002 — timeout (receiveTimeout) : clear() NON appelé, '
      'token conservé // régression #MOB-002',
      () async {
        final timeoutAdapter = _CountingAdapter((_) {
          throw DioException(
            requestOptions: RequestOptions(path: '/v1/auth/refresh'),
            type: DioExceptionType.receiveTimeout,
          );
        });
        final refreshDio = Dio()..httpClientAdapter = timeoutAdapter;
        final timeoutStore = AuthTokenStore(
          secureStorage: secureStorage,
          refreshDio: refreshDio,
        );

        await expectLater(
          timeoutStore.refresh(),
          throwsA(isA<Exception>()),
        );

        verifyNever(() => secureStorage.delete(key: any(named: 'key')));
      },
    );

    test(
      'MOB-002 — HTTP 401 : clear() appelé (session invalide, comportement '
      'inchangé) // régression #MOB-002',
      () async {
        store = buildStore(
          (_) => _jsonResponse(401, {
            'error': {
              'code': 'REFRESH_TOKEN_INVALID',
              'message': 'Token expiré',
            },
          }),
        );

        await expectLater(
          store.refresh(),
          throwsA(isA<UnauthorizedException>()),
        );

        verify(() => secureStorage.delete(key: any(named: 'key'))).called(1);
      },
    );

    test(
      'MOB-002 — HTTP 403 : clear() appelé (accès refusé) '
      '// régression #MOB-002',
      () async {
        store = buildStore(
          (_) => _jsonResponse(403, {
            'error': {
              'code': 'FORBIDDEN',
              'message': 'Accès refusé',
            },
          }),
        );

        await expectLater(
          store.refresh(),
          throwsA(isA<Exception>()),
        );

        verify(() => secureStorage.delete(key: any(named: 'key'))).called(1);
      },
    );
    // ── fin MOB-002 ────────────────────────────────────────────────────────
  });
}

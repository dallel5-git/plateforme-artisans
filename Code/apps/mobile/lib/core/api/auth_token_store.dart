import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:sanaya/core/api/env.dart';
import 'package:sanaya/core/api/generated/api.dart';

/// Détient les tokens de session : l'access token vit en mémoire
/// uniquement, le refresh token dans `flutter_secure_storage` (Keystore
/// Android / Keychain iOS) — jamais `SharedPreferences`
/// (`apps/mobile/CLAUDE.md` #8).
///
/// [refresh] est single-flight : un refresh déjà en cours est partagé par
/// tout appelant concurrent au lieu d'en déclencher un second — deux
/// requêtes avec un token expiré ne provoquent qu'un seul appel réseau à
/// `/v1/auth/refresh`. L'appel lui-même passe par un [Dio] nu, sans
/// intercepteur, pour ne jamais se re-déclencher lui-même en cas de 401.
class AuthTokenStore {
  AuthTokenStore({FlutterSecureStorage? secureStorage, Dio? refreshDio})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
      _refreshDio = refreshDio ?? _buildRefreshDio();

  static const _refreshTokenKey = 'sanaya.refresh_token';

  final FlutterSecureStorage _secureStorage;
  final Dio _refreshDio;

  String? _accessToken;
  Completer<String>? _inFlight;

  String? get accessToken => _accessToken;

  Future<String?> readRefreshToken() => _secureStorage.read(
    key: _refreshTokenKey,
  );

  /// Enregistre une session obtenue après la validation OTP. L'access token
  /// reste volontairement en mémoire ; seul le refresh token est persistant.
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  static Dio _buildRefreshDio() => Dio(
    BaseOptions(
      baseUrl: ApiEnv.baseUrl,
      connectTimeout: ApiEnv.connectTimeout,
      receiveTimeout: ApiEnv.receiveTimeout,
    ),
  );

  /// Restaure la session au démarrage : lit le refresh token persistant et
  /// tente un premier refresh. Renvoie `false` si aucune session n'est
  /// persistée ou si elle n'est plus valide (tokens alors déjà purgés par
  /// [refresh]). Primitif consommé par FM-05 (auth : rôle → téléphone →
  /// OTP → session persistée) — ne fait rien d'autre que peupler
  /// [accessToken].
  Future<bool> restoreSession() async {
    final stored = await _secureStorage.read(key: _refreshTokenKey);
    if (stored == null) return false;
    try {
      await refresh();
      return true;
    } on SanayaApiException {
      return false;
    }
  }

  /// Renvoie un access token frais. Un refresh déjà en cours est partagé
  /// (single-flight) — pas de second appel réseau tant que le premier n'a
  /// pas abouti, succès ou échec.
  Future<String> refresh() {
    final existing = _inFlight;
    if (existing != null) return existing.future;

    final completer = Completer<String>();
    _inFlight = completer;
    unawaited(
      _doRefresh()
          .then(completer.complete)
          .catchError((Object error, StackTrace stackTrace) {
            completer.completeError(error, stackTrace);
          })
          .whenComplete(() => _inFlight = null),
    );
    return completer.future;
  }

  Future<String> _doRefresh() async {
    final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
    if (refreshToken == null) {
      throw UnauthorizedException(
        code: 'REFRESH_TOKEN_INVALID',
        message: 'Aucun refresh token en stockage',
      );
    }

    try {
      final response =
          await AuthApi(
            _refreshDio,
            standardSerializers,
          ).v1AuthRefreshPost(
            v1AuthRefreshPostRequest: V1AuthRefreshPostRequest(
              (b) => b.refreshToken = refreshToken,
            ),
          );
      final tokens = response.data!;
      _accessToken = tokens.accessToken;
      await _secureStorage.write(
        key: _refreshTokenKey,
        value: tokens.refreshToken,
      );
      return tokens.accessToken;
    } on DioException catch (e) {
      // Rejeu détecté (REFRESH_TOKEN_REUSED, vol probable) ou tout autre
      // échec : la session est morte dans les deux cas — purge totale
      // plutôt qu'une nouvelle tentative, pour ne jamais boucler sur un
      // refresh token définitivement invalide.
      await clear();
      throw mapDioExceptionToApiException(e);
    }
  }

  /// Purge l'access token (mémoire) et le refresh token (stockage
  /// sécurisé) — échec de refresh ou déconnexion explicite (FM-05).
  Future<void> clear() async {
    _accessToken = null;
    await _secureStorage.delete(key: _refreshTokenKey);
  }
}

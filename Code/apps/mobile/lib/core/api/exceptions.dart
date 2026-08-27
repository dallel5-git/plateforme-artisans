import 'package:dio/dio.dart';

/// Exceptions typées pour les réponses d'erreur de l'API Sanaya.
///
/// Enveloppe source (voir `CLAUDE.md` §4.3, `packages/constants/error-codes.ts`) :
/// `{ error: { code, message, details }, requestId }`. `code` est la valeur
/// stable destinée au client (mapping vers une traduction locale) ; `message`
/// est destiné au développeur, jamais affiché tel quel à l'utilisateur.
sealed class SanayaApiException implements Exception {
  const SanayaApiException({
    required this.code,
    required this.message,
    this.requestId,
    this.details,
  });

  final String code;
  final String message;
  final String? requestId;
  final Map<String, dynamic>? details;

  @override
  String toString() => 'SanayaApiException($code): $message';
}

/// Pas de réponse serveur : hors ligne, timeout, DNS, connexion refusée…
class NetworkException extends SanayaApiException {
  NetworkException([String message = 'Hors ligne ou requête expirée'])
    : super(code: 'NETWORK_ERROR', message: message);
}

/// 401 — non authentifié ou token invalide/expiré.
class UnauthorizedException extends SanayaApiException {
  UnauthorizedException({
    super.code = 'UNAUTHORIZED',
    super.message = 'Authentification requise',
    super.requestId,
    super.details,
  });
}

/// 403 — authentifié mais rôle/propriété insuffisants (distinct de 401,
/// cf. `packages/constants/error-codes.ts`).
class ForbiddenException extends SanayaApiException {
  ForbiddenException({
    super.code = 'FORBIDDEN',
    super.message = 'Accès refusé',
    super.requestId,
    super.details,
  });
}

/// 400/422 — corps ou paramètres de requête invalides.
class ValidationException extends SanayaApiException {
  ValidationException({
    super.code = 'VALIDATION_ERROR',
    super.message = 'Requête invalide',
    super.requestId,
    super.details,
  });
}

/// 404 — ressource introuvable.
class NotFoundException extends SanayaApiException {
  NotFoundException({
    super.code = 'NOT_FOUND',
    super.message = 'Ressource introuvable',
    super.requestId,
    super.details,
  });
}

/// 429 — rate limit dépassé (OTP, contacts, avis…).
class RateLimitException extends SanayaApiException {
  RateLimitException({
    super.code = 'RATE_LIMIT_EXCEEDED',
    super.message = 'Trop de requêtes, réessayer plus tard',
    super.requestId,
    super.details,
  });
}

/// 5xx, ou tout autre statut inattendu — repli générique.
class ServerException extends SanayaApiException {
  ServerException({
    super.code = 'INTERNAL_ERROR',
    super.message = 'Erreur serveur',
    super.requestId,
    super.details,
  });
}

/// Traduit un [DioException] en [SanayaApiException] typée, à partir du
/// statut HTTP et de l'enveloppe `{error:{code,message,details},requestId}`
/// quand elle est présente. Ne lance jamais — un corps de réponse absent ou
/// malformé retombe sur les valeurs par défaut de [ServerException] plutôt
/// que de faire planter le mapping lui-même.
SanayaApiException mapDioExceptionToApiException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return NetworkException();
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.badResponse:
    case DioExceptionType.transformTimeout:
    case DioExceptionType.unknown:
      break;
  }

  final response = error.response;
  if (response == null) return NetworkException();

  final envelope = response.data;
  var code = 'INTERNAL_ERROR';
  var message = 'Erreur serveur';
  Map<String, dynamic>? details;
  String? requestId;

  if (envelope is Map) {
    final errorField = envelope['error'];
    if (errorField is Map) {
      final rawCode = errorField['code'];
      final rawMessage = errorField['message'];
      if (rawCode is String) code = rawCode;
      if (rawMessage is String) message = rawMessage;
      final rawDetails = errorField['details'];
      if (rawDetails is Map) details = Map<String, dynamic>.from(rawDetails);
    }
    final rawRequestId = envelope['requestId'];
    if (rawRequestId is String) requestId = rawRequestId;
  }

  switch (response.statusCode) {
    case 401:
      return UnauthorizedException(
        code: code,
        message: message,
        requestId: requestId,
        details: details,
      );
    case 403:
      return ForbiddenException(
        code: code,
        message: message,
        requestId: requestId,
        details: details,
      );
    case 404:
      return NotFoundException(
        code: code,
        message: message,
        requestId: requestId,
        details: details,
      );
    case 400:
    case 422:
      return ValidationException(
        code: code,
        message: message,
        requestId: requestId,
        details: details,
      );
    case 429:
      return RateLimitException(
        code: code,
        message: message,
        requestId: requestId,
        details: details,
      );
    default:
      return ServerException(
        code: code,
        message: message,
        requestId: requestId,
        details: details,
      );
  }
}

/// Exécute [call] et relance le [SanayaApiException] typé porté par
/// `DioException.error` (attaché par `ErrorMappingInterceptor`) au lieu du
/// [DioException] qui l'enveloppe — c'est ce qui permet à un appelant
/// d'écrire `on UnauthorizedException catch (e)` directement plutôt que de
/// déballer `DioException.error` à chaque site d'appel. Un [DioException]
/// sans exception typée attachée (ex. interceptor non enregistré) traverse
/// tel quel.
Future<T> unwrapDioErrors<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (e) {
    final apiException = e.error;
    if (apiException is SanayaApiException) throw apiException;
    rethrow;
  }
}

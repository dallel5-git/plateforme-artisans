import 'package:dio/dio.dart';

import 'package:sanaya/core/api/env.dart';
import 'package:sanaya/core/api/interceptors/error_mapping_interceptor.dart';

/// Construit un [Dio] configuré pour l'API Sanaya : URL de base et timeouts
/// (P5, `apps/mobile/CLAUDE.md`). `ErrorMappingInterceptor` est toujours
/// enregistré en dernier, pour traduire en `SanayaApiException` toute
/// erreur qui n'a pas déjà été traitée par un intercepteur plus spécifique
/// (auth/refresh, retry — voir FM-02d/FM-02e, passés via [interceptors]).
Dio buildApiClient({List<Interceptor> interceptors = const []}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEnv.baseUrl,
      connectTimeout: ApiEnv.connectTimeout,
      receiveTimeout: ApiEnv.receiveTimeout,
    ),
  );
  dio.interceptors
    ..addAll(interceptors)
    ..add(ErrorMappingInterceptor());
  return dio;
}

import 'package:dio/dio.dart';

import 'package:sanaya/core/api/exceptions.dart';

/// Traduit toute erreur Dio en [SanayaApiException] typée (voir
/// [mapDioExceptionToApiException]) et l'attache à `DioException.error` avant
/// de la relancer. Un appelant récupère l'exception typée avec
/// [unwrapDioErrors] plutôt qu'en déballant `DioException.error` lui-même.
///
/// Doit rester le dernier intercepteur enregistré (voir [buildApiClient]) :
/// un intercepteur plus spécifique (auth/refresh — FM-02d) doit pouvoir
/// intercepter un 401 et rejouer la requête *avant* que celui-ci ne le
/// traduise en exception définitive.
class ErrorMappingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.reject(err.copyWith(error: mapDioExceptionToApiException(err)));
  }
}

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:sanaya/core/api/generated/src/api_util.dart';
import 'package:sanaya/core/api/generated/src/model/v1_admin_verifications_get200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_admin_verifications_id_get200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_admin_verifications_id_review_post200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_admin_verifications_id_review_post_request.dart';

class AdminVerificationsApi {
  final Dio _dio;

  final Serializers _serializers;

  const AdminVerificationsApi(this._dio, this._serializers);

  /// v1AdminVerificationsGet
  /// File des demandes de vérification d’identité KYC pour le back-office. Tri par ancienneté (ascendant par défaut), filtre par statut optionnel, pagination par curseur.
  ///
  /// Parameters:
  /// * [status]
  /// * [limit]
  /// * [cursor]
  /// * [orderBy]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [V1AdminVerificationsGet200Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<V1AdminVerificationsGet200Response>> v1AdminVerificationsGet({
    String? status,
    int? limit = 20,
    String? cursor,
    String? orderBy = 'asc',
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/admin/verifications';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (status != null)
        r'status':
            encodeQueryParameter(_serializers, status, const FullType(String)),
      if (limit != null)
        r'limit':
            encodeQueryParameter(_serializers, limit, const FullType(int)),
      if (cursor != null)
        r'cursor':
            encodeQueryParameter(_serializers, cursor, const FullType(String)),
      if (orderBy != null)
        r'orderBy':
            encodeQueryParameter(_serializers, orderBy, const FullType(String)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    V1AdminVerificationsGet200Response? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
              rawResponse,
              specifiedType: const FullType(V1AdminVerificationsGet200Response),
            ) as V1AdminVerificationsGet200Response;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<V1AdminVerificationsGet200Response>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// v1AdminVerificationsIdGet
  /// Récupère le détail complet d’une demande KYC pour examen modérateur. Génère des URL signées R2 temporaires (TTL &lt;&#x3D; 5 min) pour chaque document et consigne la consultation dans AuditLog (P8/P9).
  ///
  /// Parameters:
  /// * [id]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [V1AdminVerificationsIdGet200Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<V1AdminVerificationsIdGet200Response>>
      v1AdminVerificationsIdGet({
    required String id,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/admin/verifications/{id}'.replaceAll(
        '{' r'id' '}',
        encodeQueryParameter(_serializers, id, const FullType(String))
            .toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    V1AdminVerificationsIdGet200Response? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
              rawResponse,
              specifiedType:
                  const FullType(V1AdminVerificationsIdGet200Response),
            ) as V1AdminVerificationsIdGet200Response;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<V1AdminVerificationsIdGet200Response>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// v1AdminVerificationsIdReviewPost
  /// Applique une décision de modération sur une demande KYC (APPROVED, REJECTED, MORE_INFO_REQUIRED). Enregistre le statut de vérification sur le profil artisan, met à jour le badge &#x60;isVerified&#x60; (ADR-002) et journalise la décision dans AuditLog.
  ///
  /// Parameters:
  /// * [id]
  /// * [v1AdminVerificationsIdReviewPostRequest]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [V1AdminVerificationsIdReviewPost200Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<V1AdminVerificationsIdReviewPost200Response>>
      v1AdminVerificationsIdReviewPost({
    required String id,
    required V1AdminVerificationsIdReviewPostRequest
        v1AdminVerificationsIdReviewPostRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/admin/verifications/{id}/review'.replaceAll(
        '{' r'id' '}',
        encodeQueryParameter(_serializers, id, const FullType(String))
            .toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(V1AdminVerificationsIdReviewPostRequest);
      _bodyData = _serializers.serialize(
          v1AdminVerificationsIdReviewPostRequest,
          specifiedType: _type);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    V1AdminVerificationsIdReviewPost200Response? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
              rawResponse,
              specifiedType:
                  const FullType(V1AdminVerificationsIdReviewPost200Response),
            ) as V1AdminVerificationsIdReviewPost200Response;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<V1AdminVerificationsIdReviewPost200Response>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }
}

# sanaya_api_client.api.AuthApi

## Load the API package
```dart
import 'package:sanaya_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1AuthLogoutPost**](AuthApi.md#v1authlogoutpost) | **POST** /v1/auth/logout | 
[**v1AuthMeGet**](AuthApi.md#v1authmeget) | **GET** /v1/auth/me | 
[**v1AuthOtpRequestPost**](AuthApi.md#v1authotprequestpost) | **POST** /v1/auth/otp/request | 
[**v1AuthOtpVerifyPost**](AuthApi.md#v1authotpverifypost) | **POST** /v1/auth/otp/verify | 
[**v1AuthRefreshPost**](AuthApi.md#v1authrefreshpost) | **POST** /v1/auth/refresh | 


# **v1AuthLogoutPost**
> V1AuthLogoutPost200Response v1AuthLogoutPost(v1AuthRefreshPostRequest)



Révoque la session associée au refresh token présenté. Idempotent.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getAuthApi();
final V1AuthRefreshPostRequest v1AuthRefreshPostRequest = ; // V1AuthRefreshPostRequest | 

try {
    final response = api.v1AuthLogoutPost(v1AuthRefreshPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->v1AuthLogoutPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **v1AuthRefreshPostRequest** | [**V1AuthRefreshPostRequest**](V1AuthRefreshPostRequest.md)|  | 

### Return type

[**V1AuthLogoutPost200Response**](V1AuthLogoutPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1AuthMeGet**
> V1AuthMeGet200Response v1AuthMeGet()



Profil de l'utilisateur authentifié, rôles inclus.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getAuthApi();

try {
    final response = api.v1AuthMeGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->v1AuthMeGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**V1AuthMeGet200Response**](V1AuthMeGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1AuthOtpRequestPost**
> V1AuthOtpRequestPost200Response v1AuthOtpRequestPost(v1AuthOtpRequestPostRequest)



Demande un code OTP par SMS. Réponse identique, que le numéro existe déjà ou non (anti-énumération). Rate-limit : 5/h par numéro et par IP.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getAuthApi();
final V1AuthOtpRequestPostRequest v1AuthOtpRequestPostRequest = ; // V1AuthOtpRequestPostRequest | 

try {
    final response = api.v1AuthOtpRequestPost(v1AuthOtpRequestPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->v1AuthOtpRequestPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **v1AuthOtpRequestPostRequest** | [**V1AuthOtpRequestPostRequest**](V1AuthOtpRequestPostRequest.md)|  | 

### Return type

[**V1AuthOtpRequestPost200Response**](V1AuthOtpRequestPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1AuthOtpVerifyPost**
> V1AuthOtpVerifyPost200Response v1AuthOtpVerifyPost(v1AuthOtpVerifyPostRequest)



Vérifie le code OTP, crée le compte au besoin, émet les tokens de session.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getAuthApi();
final V1AuthOtpVerifyPostRequest v1AuthOtpVerifyPostRequest = ; // V1AuthOtpVerifyPostRequest | 

try {
    final response = api.v1AuthOtpVerifyPost(v1AuthOtpVerifyPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->v1AuthOtpVerifyPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **v1AuthOtpVerifyPostRequest** | [**V1AuthOtpVerifyPostRequest**](V1AuthOtpVerifyPostRequest.md)|  | 

### Return type

[**V1AuthOtpVerifyPost200Response**](V1AuthOtpVerifyPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1AuthRefreshPost**
> AuthTokens v1AuthRefreshPost(v1AuthRefreshPostRequest)



Fait tourner le refresh token. Un rejeu révoque toute la famille de sessions.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getAuthApi();
final V1AuthRefreshPostRequest v1AuthRefreshPostRequest = ; // V1AuthRefreshPostRequest | 

try {
    final response = api.v1AuthRefreshPost(v1AuthRefreshPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->v1AuthRefreshPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **v1AuthRefreshPostRequest** | [**V1AuthRefreshPostRequest**](V1AuthRefreshPostRequest.md)|  | 

### Return type

[**AuthTokens**](AuthTokens.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


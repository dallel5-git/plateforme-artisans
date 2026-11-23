# sanaya_api_client.api.AdminVerificationsApi

## Load the API package
```dart
import 'package:sanaya_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1AdminVerificationsGet**](AdminVerificationsApi.md#v1adminverificationsget) | **GET** /v1/admin/verifications | 
[**v1AdminVerificationsIdGet**](AdminVerificationsApi.md#v1adminverificationsidget) | **GET** /v1/admin/verifications/{id} | 
[**v1AdminVerificationsIdReviewPost**](AdminVerificationsApi.md#v1adminverificationsidreviewpost) | **POST** /v1/admin/verifications/{id}/review | 


# **v1AdminVerificationsGet**
> V1AdminVerificationsGet200Response v1AdminVerificationsGet(status, limit, cursor, orderBy)



File des demandes de vérification d’identité KYC pour le back-office. Tri par ancienneté (ascendant par défaut), filtre par statut optionnel, pagination par curseur.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getAdminVerificationsApi();
final String status = status_example; // String | 
final int limit = 56; // int | 
final String cursor = cursor_example; // String | 
final String orderBy = orderBy_example; // String | 

try {
    final response = api.v1AdminVerificationsGet(status, limit, cursor, orderBy);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AdminVerificationsApi->v1AdminVerificationsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]
 **cursor** | **String**|  | [optional] 
 **orderBy** | **String**|  | [optional] [default to 'asc']

### Return type

[**V1AdminVerificationsGet200Response**](V1AdminVerificationsGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1AdminVerificationsIdGet**
> V1AdminVerificationsIdGet200Response v1AdminVerificationsIdGet(id)



Récupère le détail complet d’une demande KYC pour examen modérateur. Génère des URL signées R2 temporaires (TTL <= 5 min) pour chaque document et consigne la consultation dans AuditLog (P8/P9).

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getAdminVerificationsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.v1AdminVerificationsIdGet(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AdminVerificationsApi->v1AdminVerificationsIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**V1AdminVerificationsIdGet200Response**](V1AdminVerificationsIdGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1AdminVerificationsIdReviewPost**
> V1AdminVerificationsIdReviewPost200Response v1AdminVerificationsIdReviewPost(id, v1AdminVerificationsIdReviewPostRequest)



Applique une décision de modération sur une demande KYC (APPROVED, REJECTED, MORE_INFO_REQUIRED). Enregistre le statut de vérification sur le profil artisan, met à jour le badge `isVerified` (ADR-002) et journalise la décision dans AuditLog.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getAdminVerificationsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final V1AdminVerificationsIdReviewPostRequest v1AdminVerificationsIdReviewPostRequest = ; // V1AdminVerificationsIdReviewPostRequest | 

try {
    final response = api.v1AdminVerificationsIdReviewPost(id, v1AdminVerificationsIdReviewPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AdminVerificationsApi->v1AdminVerificationsIdReviewPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **v1AdminVerificationsIdReviewPostRequest** | [**V1AdminVerificationsIdReviewPostRequest**](V1AdminVerificationsIdReviewPostRequest.md)|  | 

### Return type

[**V1AdminVerificationsIdReviewPost200Response**](V1AdminVerificationsIdReviewPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


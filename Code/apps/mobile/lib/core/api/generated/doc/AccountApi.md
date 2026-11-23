# sanaya_api_client.api.AccountApi

## Load the API package
```dart
import 'package:sanaya_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1UsersMeDelete**](AccountApi.md#v1usersmedelete) | **DELETE** /v1/users/me | 
[**v1UsersMeExportGet**](AccountApi.md#v1usersmeexportget) | **GET** /v1/users/me/export | 


# **v1UsersMeDelete**
> V1UsersMeDelete200Response v1UsersMeDelete(v1UsersMeDeleteRequest)



Supprime et anonymise le compte utilisateur conformément aux exigences INPDP (US-C-13 / CLAUDE.md §3.2). Exige une confirmation explicite (\"SUPPRIMER\" ou \"DELETE\"). Révoque immédiatement toutes les sessions actives.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getAccountApi();
final V1UsersMeDeleteRequest v1UsersMeDeleteRequest = ; // V1UsersMeDeleteRequest | 

try {
    final response = api.v1UsersMeDelete(v1UsersMeDeleteRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AccountApi->v1UsersMeDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **v1UsersMeDeleteRequest** | [**V1UsersMeDeleteRequest**](V1UsersMeDeleteRequest.md)|  | 

### Return type

[**V1UsersMeDelete200Response**](V1UsersMeDelete200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1UsersMeExportGet**
> V1UsersMeExportGet200Response v1UsersMeExportGet()



Exporte l ensemble des données personnelles associées au compte utilisateur au format JSON conformément à la loi tunisienne n° 2004-63 (INPDP) et à l US-C-13.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getAccountApi();

try {
    final response = api.v1UsersMeExportGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling AccountApi->v1UsersMeExportGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**V1UsersMeExportGet200Response**](V1UsersMeExportGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


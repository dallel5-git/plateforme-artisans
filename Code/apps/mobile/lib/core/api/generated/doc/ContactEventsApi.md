# sanaya_api_client.api.ContactEventsApi

## Load the API package
```dart
import 'package:sanaya_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1ContactEventsGet**](ContactEventsApi.md#v1contacteventsget) | **GET** /v1/contact-events | 
[**v1ContactEventsPost**](ContactEventsApi.md#v1contacteventspost) | **POST** /v1/contact-events | 


# **v1ContactEventsGet**
> V1ContactEventsGet200Response v1ContactEventsGet(cursor, limit)



Historique des contacts du client authentifié (US-C-09), trié par date décroissante, pagination par curseur. Chaque item porte déjà les libellés d'affichage (P3, pas de second appel GET /providers/:slug côté mobile) et `hasReview` pour le CTA de dépôt d'avis (FM-31).

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getContactEventsApi();
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.v1ContactEventsGet(cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ContactEventsApi->v1ContactEventsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**V1ContactEventsGet200Response**](V1ContactEventsGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ContactEventsPost**
> ContactEventResponse v1ContactEventsPost(v1ContactEventsPostRequest)



Révèle le numéro d'un prestataire et trace l'événement (P9). Canal PHONE ou WHATSAPP uniquement. Déduplique deux clics de la même session sur le même artisan/canal en 30 min. Rate-limit 30/j par identité et par IP.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getContactEventsApi();
final V1ContactEventsPostRequest v1ContactEventsPostRequest = ; // V1ContactEventsPostRequest | 

try {
    final response = api.v1ContactEventsPost(v1ContactEventsPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ContactEventsApi->v1ContactEventsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **v1ContactEventsPostRequest** | [**V1ContactEventsPostRequest**](V1ContactEventsPostRequest.md)|  | 

### Return type

[**ContactEventResponse**](ContactEventResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


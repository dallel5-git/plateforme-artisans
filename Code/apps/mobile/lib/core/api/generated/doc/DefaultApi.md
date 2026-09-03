# sanaya_api_client.api.DefaultApi

## Load the API package
```dart
import 'package:sanaya_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1CategoriesGet**](DefaultApi.md#v1categoriesget) | **GET** /v1/categories | 
[**v1FavoritesGet**](DefaultApi.md#v1favoritesget) | **GET** /v1/favorites | 
[**v1FavoritesProviderIdDelete**](DefaultApi.md#v1favoritesprovideriddelete) | **DELETE** /v1/favorites/{providerId} | 
[**v1FavoritesProviderIdPut**](DefaultApi.md#v1favoritesprovideridput) | **PUT** /v1/favorites/{providerId} | 
[**v1GovernoratesGet**](DefaultApi.md#v1governoratesget) | **GET** /v1/governorates | 
[**v1GovernoratesIdDelegationsGet**](DefaultApi.md#v1governoratesiddelegationsget) | **GET** /v1/governorates/{id}/delegations | 
[**v1HealthGet**](DefaultApi.md#v1healthget) | **GET** /v1/health | 
[**v1MediaIdProcessPost**](DefaultApi.md#v1mediaidprocesspost) | **POST** /v1/media/{id}/process | 
[**v1MediaPresignPost**](DefaultApi.md#v1mediapresignpost) | **POST** /v1/media/presign | 
[**v1ProfileViewsPost**](DefaultApi.md#v1profileviewspost) | **POST** /v1/profile-views | 
[**v1ProvidersIdReviewsPost**](DefaultApi.md#v1providersidreviewspost) | **POST** /v1/providers/{id}/reviews | 
[**v1ProvidersMeCategoriesPut**](DefaultApi.md#v1providersmecategoriesput) | **PUT** /v1/providers/me/categories | 
[**v1ProvidersMeCoverageAreasPut**](DefaultApi.md#v1providersmecoverageareasput) | **PUT** /v1/providers/me/coverage-areas | 
[**v1ProvidersMeGet**](DefaultApi.md#v1providersmeget) | **GET** /v1/providers/me | 
[**v1ProvidersMeOfferingsIdDelete**](DefaultApi.md#v1providersmeofferingsiddelete) | **DELETE** /v1/providers/me/offerings/{id} | 
[**v1ProvidersMeOfferingsIdPatch**](DefaultApi.md#v1providersmeofferingsidpatch) | **PATCH** /v1/providers/me/offerings/{id} | 
[**v1ProvidersMeOfferingsPost**](DefaultApi.md#v1providersmeofferingspost) | **POST** /v1/providers/me/offerings | 
[**v1ProvidersMePatch**](DefaultApi.md#v1providersmepatch) | **PATCH** /v1/providers/me | 
[**v1ProvidersMePortfolioIdDelete**](DefaultApi.md#v1providersmeportfolioiddelete) | **DELETE** /v1/providers/me/portfolio/{id} | 
[**v1ProvidersMePortfolioPost**](DefaultApi.md#v1providersmeportfoliopost) | **POST** /v1/providers/me/portfolio | 
[**v1ProvidersMePost**](DefaultApi.md#v1providersmepost) | **POST** /v1/providers/me | 
[**v1ProvidersMeStatsGet**](DefaultApi.md#v1providersmestatsget) | **GET** /v1/providers/me/stats | 
[**v1ProvidersSearchGet**](DefaultApi.md#v1providerssearchget) | **GET** /v1/providers/search | 
[**v1ProvidersSlugGet**](DefaultApi.md#v1providersslugget) | **GET** /v1/providers/{slug} | 
[**v1ProvidersSlugReviewsGet**](DefaultApi.md#v1providersslugreviewsget) | **GET** /v1/providers/{slug}/reviews | 


# **v1CategoriesGet**
> V1CategoriesGet200Response v1CategoriesGet()



Arbre complet des catégories, libellés FR et AR. Cache Redis 1h.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();

try {
    final response = api.v1CategoriesGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1CategoriesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**V1CategoriesGet200Response**](V1CategoriesGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1FavoritesGet**
> V1FavoritesGet200Response v1FavoritesGet(cursor, limit)



Favoris du client authentifié, triés par date d'ajout décroissante, pagination par curseur.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.v1FavoritesGet(cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1FavoritesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**V1FavoritesGet200Response**](V1FavoritesGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1FavoritesProviderIdDelete**
> v1FavoritesProviderIdDelete(providerId)



Retire un prestataire des favoris du client authentifié — idempotent, 204 même si le favori n'existait pas.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final String providerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.v1FavoritesProviderIdDelete(providerId);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1FavoritesProviderIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **providerId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1FavoritesProviderIdPut**
> V1FavoritesProviderIdPut200Response v1FavoritesProviderIdPut(providerId)



Ajoute un prestataire aux favoris du client authentifié — idempotent (clé composite (userId, providerId), deux appels successifs ne créent jamais de doublon). 404 si le prestataire n'existe pas ou n'est pas publié.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final String providerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.v1FavoritesProviderIdPut(providerId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1FavoritesProviderIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **providerId** | **String**|  | 

### Return type

[**V1FavoritesProviderIdPut200Response**](V1FavoritesProviderIdPut200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1GovernoratesGet**
> V1GovernoratesGet200Response v1GovernoratesGet()



24 gouvernorats, libellés FR et AR. Cache Redis 1h.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();

try {
    final response = api.v1GovernoratesGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1GovernoratesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**V1GovernoratesGet200Response**](V1GovernoratesGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1GovernoratesIdDelegationsGet**
> V1GovernoratesIdDelegationsGet200Response v1GovernoratesIdDelegationsGet(id)



Délégations actives d’un gouvernorat, libellés FR et AR. Cache Redis 1h.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.v1GovernoratesIdDelegationsGet(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1GovernoratesIdDelegationsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**V1GovernoratesIdDelegationsGet200Response**](V1GovernoratesIdDelegationsGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1HealthGet**
> V1HealthGet200Response v1HealthGet()



Vérifie la disponibilité réelle de PostgreSQL et Redis (pas un {ok:true} de façade).

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();

try {
    final response = api.v1HealthGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1HealthGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**V1HealthGet200Response**](V1HealthGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1MediaIdProcessPost**
> V1MediaIdProcessPost200Response v1MediaIdProcessPost(id)



Télécharge l'original téléversé par le client (voir `POST /v1/media/presign`), génère les 3 variantes WebP (thumb/card/full — BE-20) et les téléverse sur R2. `MediaAsset.publicUrl`/`width`/`height` reflètent la variante `full`.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.v1MediaIdProcessPost(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1MediaIdProcessPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**V1MediaIdProcessPost200Response**](V1MediaIdProcessPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1MediaPresignPost**
> V1MediaPresignPost200Response v1MediaPresignPost(v1MediaPresignPostRequest)



Crée un `MediaAsset` (bucket public) et renvoie une URL PUT pré-signée (~10 min) pour un téléversement direct vers R2, sans transiter par l'API (P5). Le traitement (variantes WebP) se fait ensuite via `POST /v1/media/:id/process`.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final V1MediaPresignPostRequest v1MediaPresignPostRequest = ; // V1MediaPresignPostRequest | 

try {
    final response = api.v1MediaPresignPost(v1MediaPresignPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1MediaPresignPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **v1MediaPresignPostRequest** | [**V1MediaPresignPostRequest**](V1MediaPresignPostRequest.md)|  | 

### Return type

[**V1MediaPresignPost200Response**](V1MediaPresignPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProfileViewsPost**
> v1ProfileViewsPost(v1ProfileViewsPostRequest)



Trace la vue d'un profil artisan (P9). Déduplique par empreinte de session sur un jour calendaire UTC (une vue = une ligne par session et par jour) et met à jour l'agrégat journalier DailyProviderStat. Rate-limit 200/j par identité et par IP.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final V1ProfileViewsPostRequest v1ProfileViewsPostRequest = ; // V1ProfileViewsPostRequest | 

try {
    api.v1ProfileViewsPost(v1ProfileViewsPostRequest);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1ProfileViewsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **v1ProfileViewsPostRequest** | [**V1ProfileViewsPostRequest**](V1ProfileViewsPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProvidersIdReviewsPost**
> V1ProvidersIdReviewsPost200Response v1ProvidersIdReviewsPost(id, v1ProvidersIdReviewsPostRequest)



Dépose un avis rattaché à un ContactEvent réel (BE-22, P9/P10). Sélection automatique du contact éligible (>12h, <60j, pas déjà avisé) — 403 REVIEW_REQUIRES_CONTACT sinon. Auto-évaluation rejetée. Publié immédiatement (pas de filtrage anti-spam pour l'instant).

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final V1ProvidersIdReviewsPostRequest v1ProvidersIdReviewsPostRequest = ; // V1ProvidersIdReviewsPostRequest | 

try {
    final response = api.v1ProvidersIdReviewsPost(id, v1ProvidersIdReviewsPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1ProvidersIdReviewsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **v1ProvidersIdReviewsPostRequest** | [**V1ProvidersIdReviewsPostRequest**](V1ProvidersIdReviewsPostRequest.md)|  | 

### Return type

[**V1ProvidersIdReviewsPost200Response**](V1ProvidersIdReviewsPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProvidersMeCategoriesPut**
> V1ProvidersMeCategoriesPut200Response v1ProvidersMeCategoriesPut(v1ProvidersMeCategoriesPutRequest)



Remplace tout le set de catégories de l’artisan authentifié (une seule catégorie principale, exactement un `isPrimary: true`). Limite du plan FREE : 3 catégories. `completionScore` recalculé.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final V1ProvidersMeCategoriesPutRequest v1ProvidersMeCategoriesPutRequest = ; // V1ProvidersMeCategoriesPutRequest | 

try {
    final response = api.v1ProvidersMeCategoriesPut(v1ProvidersMeCategoriesPutRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1ProvidersMeCategoriesPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **v1ProvidersMeCategoriesPutRequest** | [**V1ProvidersMeCategoriesPutRequest**](V1ProvidersMeCategoriesPutRequest.md)|  | 

### Return type

[**V1ProvidersMeCategoriesPut200Response**](V1ProvidersMeCategoriesPut200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProvidersMeCoverageAreasPut**
> V1ProvidersMeCoverageAreasPut200Response v1ProvidersMeCoverageAreasPut(v1ProvidersMeCoverageAreasPutRequest)



Remplace tout le set de zones d'intervention de l'artisan authentifié. `delegationId` absent = tout le gouvernorat. Limite du plan FREE : 1 gouvernorat distinct (plusieurs délégations du même gouvernorat ne comptent qu'une fois). `completionScore` recalculé.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final V1ProvidersMeCoverageAreasPutRequest v1ProvidersMeCoverageAreasPutRequest = ; // V1ProvidersMeCoverageAreasPutRequest | 

try {
    final response = api.v1ProvidersMeCoverageAreasPut(v1ProvidersMeCoverageAreasPutRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1ProvidersMeCoverageAreasPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **v1ProvidersMeCoverageAreasPutRequest** | [**V1ProvidersMeCoverageAreasPutRequest**](V1ProvidersMeCoverageAreasPutRequest.md)|  | 

### Return type

[**V1ProvidersMeCoverageAreasPut200Response**](V1ProvidersMeCoverageAreasPut200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProvidersMeGet**
> V1ProvidersMeGet200Response v1ProvidersMeGet()



Profil artisan complet de l'utilisateur authentifié (vue propriétaire : mêmes champs que la fiche publique, plus les champs privés utiles à l’édition — availabilityStatus, availableAgainAt, acceptsEmergency, workingHours, publicationStatus, completionScore). BE-44.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();

try {
    final response = api.v1ProvidersMeGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1ProvidersMeGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**V1ProvidersMeGet200Response**](V1ProvidersMeGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProvidersMeOfferingsIdDelete**
> v1ProvidersMeOfferingsIdDelete(id)



Retire une offre de l'artisan authentifié (désactivation, pas de suppression physique).

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.v1ProvidersMeOfferingsIdDelete(id);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1ProvidersMeOfferingsIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProvidersMeOfferingsIdPatch**
> V1ProvidersMeOfferingsPost200Response v1ProvidersMeOfferingsIdPatch(id, v1ProvidersMeOfferingsIdPatchRequest)



Modifie une offre de l'artisan authentifié (catégorie non modifiable).

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final V1ProvidersMeOfferingsIdPatchRequest v1ProvidersMeOfferingsIdPatchRequest = ; // V1ProvidersMeOfferingsIdPatchRequest | 

try {
    final response = api.v1ProvidersMeOfferingsIdPatch(id, v1ProvidersMeOfferingsIdPatchRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1ProvidersMeOfferingsIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **v1ProvidersMeOfferingsIdPatchRequest** | [**V1ProvidersMeOfferingsIdPatchRequest**](V1ProvidersMeOfferingsIdPatchRequest.md)|  | 

### Return type

[**V1ProvidersMeOfferingsPost200Response**](V1ProvidersMeOfferingsPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProvidersMeOfferingsPost**
> V1ProvidersMeOfferingsPost200Response v1ProvidersMeOfferingsPost(v1ProvidersMeOfferingsPostRequest)



Ajoute une offre (tarif) au profil de l'artisan authentifié.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final V1ProvidersMeOfferingsPostRequest v1ProvidersMeOfferingsPostRequest = ; // V1ProvidersMeOfferingsPostRequest | 

try {
    final response = api.v1ProvidersMeOfferingsPost(v1ProvidersMeOfferingsPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1ProvidersMeOfferingsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **v1ProvidersMeOfferingsPostRequest** | [**V1ProvidersMeOfferingsPostRequest**](V1ProvidersMeOfferingsPostRequest.md)|  | 

### Return type

[**V1ProvidersMeOfferingsPost200Response**](V1ProvidersMeOfferingsPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProvidersMePatch**
> V1ProvidersMeGet200Response v1ProvidersMePatch(v1ProvidersMePatchRequest)



Met à jour le profil artisan de l'utilisateur authentifié. `completionScore` est recalculé à chaque appel ; publier (`publicationStatus: PUBLISHED`) est refusé sous 60 % de complétude, avec la liste des champs manquants.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final V1ProvidersMePatchRequest v1ProvidersMePatchRequest = ; // V1ProvidersMePatchRequest | 

try {
    final response = api.v1ProvidersMePatch(v1ProvidersMePatchRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1ProvidersMePatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **v1ProvidersMePatchRequest** | [**V1ProvidersMePatchRequest**](V1ProvidersMePatchRequest.md)|  | 

### Return type

[**V1ProvidersMeGet200Response**](V1ProvidersMeGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProvidersMePortfolioIdDelete**
> v1ProvidersMePortfolioIdDelete(id)



Détache un élément de la galerie de l'artisan authentifié.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.v1ProvidersMePortfolioIdDelete(id);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1ProvidersMePortfolioIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProvidersMePortfolioPost**
> V1ProvidersMePortfolioPost200Response v1ProvidersMePortfolioPost(v1ProvidersMePortfolioPostRequest)



Rattache au profil artisan un `MediaAsset` déjà traité (`POST /v1/media/:id/process`, BE-20c) — le média doit appartenir à l'appelant et être `APPROVED`. Limite du plan FREE : 5 photos (US-P-04).

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final V1ProvidersMePortfolioPostRequest v1ProvidersMePortfolioPostRequest = ; // V1ProvidersMePortfolioPostRequest | 

try {
    final response = api.v1ProvidersMePortfolioPost(v1ProvidersMePortfolioPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1ProvidersMePortfolioPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **v1ProvidersMePortfolioPostRequest** | [**V1ProvidersMePortfolioPostRequest**](V1ProvidersMePortfolioPostRequest.md)|  | 

### Return type

[**V1ProvidersMePortfolioPost200Response**](V1ProvidersMePortfolioPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProvidersMePost**
> V1ProvidersMePost200Response v1ProvidersMePost(v1ProvidersMePostRequest)



Crée le profil artisan de l'utilisateur authentifié. Le promeut PROVIDER s'il ne l'est pas déjà (US-P-01 : devenir prestataire sans créer un second compte) et émet un nouveau couple de tokens reflétant ce rôle.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final V1ProvidersMePostRequest v1ProvidersMePostRequest = ; // V1ProvidersMePostRequest | 

try {
    final response = api.v1ProvidersMePost(v1ProvidersMePostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1ProvidersMePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **v1ProvidersMePostRequest** | [**V1ProvidersMePostRequest**](V1ProvidersMePostRequest.md)|  | 

### Return type

[**V1ProvidersMePost200Response**](V1ProvidersMePost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProvidersMeStatsGet**
> V1ProvidersMeStatsGet200Response v1ProvidersMeStatsGet()



Tableau de bord de l'artisan authentifié (US-P-07/US-P-08) : totaux et série journalière sur 30 jours (vues, vues dédupliquées, contacts, ratio vue→contact), jours à zéro inclus. `searchImpressions`/`avgSearchPosition` sont absents : aucun module `search` n'existe encore pour les alimenter (BE-43).

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();

try {
    final response = api.v1ProvidersMeStatsGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1ProvidersMeStatsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**V1ProvidersMeStatsGet200Response**](V1ProvidersMeStatsGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProvidersSearchGet**
> V1ProvidersSearchGet200Response v1ProvidersSearchGet(governorate, category, delegation, verified, minRating, availability, cursor, limit, debug)



Recherche d’artisans : catégorie/gouvernorat/délégation/vérifié/note/disponibilité, tri par score de ranking calculé, pagination par curseur. Mode debug via ?debug=true.

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final String governorate = governorate_example; // String | 
final String category = category_example; // String | 
final String delegation = delegation_example; // String | 
final String verified = verified_example; // String | 
final num minRating = 8.14; // num | 
final String availability = availability_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 
final String debug = debug_example; // String | 

try {
    final response = api.v1ProvidersSearchGet(governorate, category, delegation, verified, minRating, availability, cursor, limit, debug);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1ProvidersSearchGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **governorate** | **String**|  | 
 **category** | **String**|  | [optional] 
 **delegation** | **String**|  | [optional] 
 **verified** | **String**|  | [optional] 
 **minRating** | **num**|  | [optional] 
 **availability** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]
 **debug** | **String**|  | [optional] 

### Return type

[**V1ProvidersSearchGet200Response**](V1ProvidersSearchGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProvidersSlugGet**
> V1ProvidersSlugGet200Response v1ProvidersSlugGet(slug)



Fiche artisan publique — profil, catégories, offres tarifées, zones de couverture, galerie, agrégat d’avis. Jamais de numéro de téléphone (voir POST /contact-events, BE-21).

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final String slug = slug_example; // String | 

try {
    final response = api.v1ProvidersSlugGet(slug);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1ProvidersSlugGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **slug** | **String**|  | 

### Return type

[**V1ProvidersSlugGet200Response**](V1ProvidersSlugGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1ProvidersSlugReviewsGet**
> V1ProvidersSlugReviewsGet200Response v1ProvidersSlugReviewsGet(slug, cursor, limit)



Avis PUBLISHED d’un artisan, triés par date décroissante, pagination par curseur. Nom de l’auteur anonymisé (\"Utilisateur supprimé\") si le compte a été supprimé. Sous-notes et réponse de l’artisan hors périmètre (voir backlog).

### Example
```dart
import 'package:sanaya_api_client/api.dart';

final api = SanayaApiClient().getDefaultApi();
final String slug = slug_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.v1ProvidersSlugReviewsGet(slug, cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->v1ProvidersSlugReviewsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **slug** | **String**|  | 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**V1ProvidersSlugReviewsGet200Response**](V1ProvidersSlugReviewsGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


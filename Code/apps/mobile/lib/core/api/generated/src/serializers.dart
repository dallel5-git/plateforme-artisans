//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:sanaya/core/api/generated/src/date_serializer.dart';
import 'package:sanaya/core/api/generated/src/model/date.dart';
import 'package:sanaya/core/api/generated/src/model/shared_enums.dart';

import 'package:sanaya/core/api/generated/src/model/auth_tokens.dart';
import 'package:sanaya/core/api/generated/src/model/auth_tokens_input.dart';
import 'package:sanaya/core/api/generated/src/model/category_tree_node.dart';
import 'package:sanaya/core/api/generated/src/model/category_tree_node_input.dart';
import 'package:sanaya/core/api/generated/src/model/contact_event_response.dart';
import 'package:sanaya/core/api/generated/src/model/contact_event_response_input.dart';
import 'package:sanaya/core/api/generated/src/model/v1_auth_logout_post200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_auth_me_get200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_auth_otp_request_post200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_auth_otp_request_post_request.dart';
import 'package:sanaya/core/api/generated/src/model/v1_auth_otp_verify_post200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_auth_otp_verify_post200_response_user.dart';
import 'package:sanaya/core/api/generated/src/model/v1_auth_otp_verify_post_request.dart';
import 'package:sanaya/core/api/generated/src/model/v1_auth_refresh_post_request.dart';
import 'package:sanaya/core/api/generated/src/model/v1_categories_get200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_contact_events_post_request.dart';
import 'package:sanaya/core/api/generated/src/model/v1_favorites_get200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_favorites_get200_response_items_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_favorites_provider_id_put200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_governorates_get200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_governorates_get200_response_governorates_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_governorates_id_delegations_get200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_governorates_id_delegations_get200_response_delegations_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_health_get200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_health_get503_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_media_id_process_post200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_media_presign_post200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_media_presign_post_request.dart';
import 'package:sanaya/core/api/generated/src/model/v1_profile_views_post_request.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_id_reviews_post200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_id_reviews_post_request.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_categories_put200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_categories_put200_response_categories_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_categories_put_request.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_categories_put_request_categories_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_coverage_areas_put200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_coverage_areas_put200_response_coverage_areas_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_coverage_areas_put_request.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_coverage_areas_put_request_coverage_areas_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_patch_request.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_portfolio_post200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_portfolio_post_request.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_post200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_post200_response_provider.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_post_request.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_stats_get200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_stats_get200_response_series_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_stats_get200_response_totals.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_search_get200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_search_get200_response_items_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_search_get200_response_items_inner_categories_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_search_get200_response_items_inner_match_reason.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_get200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_get200_response_base_delegation.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_get200_response_base_governorate.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_get200_response_categories_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_get200_response_coverage_areas_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_get200_response_coverage_areas_inner_delegation.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_get200_response_gallery_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_get200_response_offerings_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_get200_response_offerings_inner_category.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_get200_response_review_aggregate.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_get200_response_review_aggregate_breakdown.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_reviews_get200_response.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_reviews_get200_response_items_inner.dart';

part 'serializers.g.dart';

@SerializersFor([
  AuthTokens,
  AuthTokensInput,
  CategoryTreeNode,
  CategoryTreeNodeInput,
  ContactEventResponse,
  ContactEventResponseInput,
  V1AuthLogoutPost200Response,
  V1AuthMeGet200Response,
  V1AuthOtpRequestPost200Response,
  V1AuthOtpRequestPostRequest,
  V1AuthOtpVerifyPost200Response,
  V1AuthOtpVerifyPost200ResponseUser,
  V1AuthOtpVerifyPostRequest,
  V1AuthRefreshPostRequest,
  V1CategoriesGet200Response,
  V1ContactEventsPostRequest,
  V1FavoritesGet200Response,
  V1FavoritesGet200ResponseItemsInner,
  V1FavoritesProviderIdPut200Response,
  V1GovernoratesGet200Response,
  V1GovernoratesGet200ResponseGovernoratesInner,
  V1GovernoratesIdDelegationsGet200Response,
  V1GovernoratesIdDelegationsGet200ResponseDelegationsInner,
  V1HealthGet200Response,
  V1HealthGet503Response,
  V1MediaIdProcessPost200Response,
  V1MediaPresignPost200Response,
  V1MediaPresignPostRequest,
  V1ProfileViewsPostRequest,
  V1ProvidersIdReviewsPost200Response,
  V1ProvidersIdReviewsPostRequest,
  V1ProvidersMeCategoriesPut200Response,
  V1ProvidersMeCategoriesPut200ResponseCategoriesInner,
  V1ProvidersMeCategoriesPutRequest,
  V1ProvidersMeCategoriesPutRequestCategoriesInner,
  V1ProvidersMeCoverageAreasPut200Response,
  V1ProvidersMeCoverageAreasPut200ResponseCoverageAreasInner,
  V1ProvidersMeCoverageAreasPutRequest,
  V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner,
  V1ProvidersMePatchRequest,
  V1ProvidersMePortfolioPost200Response,
  V1ProvidersMePortfolioPostRequest,
  V1ProvidersMePost200Response,
  V1ProvidersMePost200ResponseProvider,
  V1ProvidersMePostRequest,
  V1ProvidersMeStatsGet200Response,
  V1ProvidersMeStatsGet200ResponseSeriesInner,
  V1ProvidersMeStatsGet200ResponseTotals,
  V1ProvidersSearchGet200Response,
  V1ProvidersSearchGet200ResponseItemsInner,
  V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner,
  V1ProvidersSearchGet200ResponseItemsInnerMatchReason,
  V1ProvidersSlugGet200Response,
  V1ProvidersSlugGet200ResponseBaseDelegation,
  V1ProvidersSlugGet200ResponseBaseGovernorate,
  V1ProvidersSlugGet200ResponseCategoriesInner,
  V1ProvidersSlugGet200ResponseCoverageAreasInner,
  V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation,
  V1ProvidersSlugGet200ResponseGalleryInner,
  V1ProvidersSlugGet200ResponseOfferingsInner,
  V1ProvidersSlugGet200ResponseOfferingsInnerCategory,
  V1ProvidersSlugGet200ResponseReviewAggregate,
  V1ProvidersSlugGet200ResponseReviewAggregateBreakdown,
  V1ProvidersSlugReviewsGet200Response,
  V1ProvidersSlugReviewsGet200ResponseItemsInner,
])
Serializers serializers =
    (_$serializers.toBuilder()
          ..add(const OneOfSerializer())
          ..add(const AnyOfSerializer())
          ..add(const DateSerializer())
          ..add(Iso8601DateTimeSerializer()))
        .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

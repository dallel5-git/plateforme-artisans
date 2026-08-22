// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add(CategoryTreeNode.serializer)
      ..add(CategoryTreeNodeInput.serializer)
      ..add(V1AuthLogoutPost200Response.serializer)
      ..add(V1AuthLogoutPost200ResponseStatusEnum.serializer)
      ..add(V1AuthMeGet200Response.serializer)
      ..add(V1AuthMeGet200ResponseStatusEnum.serializer)
      ..add(V1AuthOtpRequestPost200Response.serializer)
      ..add(V1AuthOtpRequestPost200ResponseStatusEnum.serializer)
      ..add(V1AuthOtpRequestPostRequest.serializer)
      ..add(V1AuthOtpVerifyPost200Response.serializer)
      ..add(V1AuthOtpVerifyPost200ResponseUser.serializer)
      ..add(V1AuthOtpVerifyPost200ResponseUserRolesEnum.serializer)
      ..add(V1AuthOtpVerifyPost200ResponseUserStatusEnum.serializer)
      ..add(V1AuthOtpVerifyPostRequest.serializer)
      ..add(V1AuthRefreshPost200Response.serializer)
      ..add(V1AuthRefreshPostRequest.serializer)
      ..add(V1CategoriesGet200Response.serializer)
      ..add(V1ContactEventsPost200Response.serializer)
      ..add(V1ContactEventsPost200ResponseChannelEnum.serializer)
      ..add(V1ContactEventsPostRequest.serializer)
      ..add(V1ContactEventsPostRequestChannelEnum.serializer)
      ..add(V1ContactEventsPostRequestSourceScreenEnum.serializer)
      ..add(V1FavoritesGet200Response.serializer)
      ..add(V1FavoritesGet200ResponseItemsInner.serializer)
      ..add(
          V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum.serializer)
      ..add(V1FavoritesProviderIdPut200Response.serializer)
      ..add(V1GovernoratesGet200Response.serializer)
      ..add(V1GovernoratesGet200ResponseGovernoratesInner.serializer)
      ..add(V1GovernoratesIdDelegationsGet200Response.serializer)
      ..add(
          V1GovernoratesIdDelegationsGet200ResponseDelegationsInner.serializer)
      ..add(V1HealthGet200Response.serializer)
      ..add(V1HealthGet200ResponseDbEnum.serializer)
      ..add(V1HealthGet200ResponseRedisEnum.serializer)
      ..add(V1HealthGet200ResponseStatusEnum.serializer)
      ..add(V1HealthGet503Response.serializer)
      ..add(V1HealthGet503ResponseDbEnum.serializer)
      ..add(V1HealthGet503ResponseRedisEnum.serializer)
      ..add(V1HealthGet503ResponseStatusEnum.serializer)
      ..add(V1MediaIdProcessPost200Response.serializer)
      ..add(V1MediaPresignPost200Response.serializer)
      ..add(V1MediaPresignPostRequest.serializer)
      ..add(V1ProvidersIdReviewsPost200Response.serializer)
      ..add(V1ProvidersIdReviewsPostRequest.serializer)
      ..add(V1ProvidersMeCategoriesPut200Response.serializer)
      ..add(V1ProvidersMeCategoriesPut200ResponseCategoriesInner.serializer)
      ..add(V1ProvidersMeCategoriesPutRequest.serializer)
      ..add(V1ProvidersMeCategoriesPutRequestCategoriesInner.serializer)
      ..add(V1ProvidersMeCoverageAreasPut200Response.serializer)
      ..add(
          V1ProvidersMeCoverageAreasPut200ResponseCoverageAreasInner.serializer)
      ..add(V1ProvidersMeCoverageAreasPutRequest.serializer)
      ..add(V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner.serializer)
      ..add(V1ProvidersMePatchRequest.serializer)
      ..add(V1ProvidersMePatchRequestAvailabilityStatusEnum.serializer)
      ..add(V1ProvidersMePatchRequestPublicationStatusEnum.serializer)
      ..add(V1ProvidersMePortfolioPost200Response.serializer)
      ..add(V1ProvidersMePortfolioPostRequest.serializer)
      ..add(V1ProvidersMePost200Response.serializer)
      ..add(V1ProvidersMePost200ResponseProvider.serializer)
      ..add(
          V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum.serializer)
      ..add(
          V1ProvidersMePost200ResponseProviderPublicationStatusEnum.serializer)
      ..add(V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum.serializer)
      ..add(V1ProvidersMePostRequest.serializer)
      ..add(V1ProvidersMePostRequestSpokenLanguagesEnum.serializer)
      ..add(V1ProvidersSearchGet200Response.serializer)
      ..add(V1ProvidersSearchGet200ResponseItemsInner.serializer)
      ..add(V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum
          .serializer)
      ..add(V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner.serializer)
      ..add(V1ProvidersSearchGet200ResponseItemsInnerMatchReason.serializer)
      ..add(V1ProvidersSlugGet200Response.serializer)
      ..add(V1ProvidersSlugGet200ResponseAvailabilityStatusEnum.serializer)
      ..add(V1ProvidersSlugGet200ResponseBaseDelegation.serializer)
      ..add(V1ProvidersSlugGet200ResponseBaseGovernorate.serializer)
      ..add(V1ProvidersSlugGet200ResponseCategoriesInner.serializer)
      ..add(V1ProvidersSlugGet200ResponseCoverageAreasInner.serializer)
      ..add(
          V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation.serializer)
      ..add(V1ProvidersSlugGet200ResponseGalleryInner.serializer)
      ..add(V1ProvidersSlugGet200ResponseOfferingsInner.serializer)
      ..add(V1ProvidersSlugGet200ResponseOfferingsInnerCategory.serializer)
      ..add(V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum.serializer)
      ..add(V1ProvidersSlugGet200ResponseReviewAggregate.serializer)
      ..add(V1ProvidersSlugGet200ResponseReviewAggregateBreakdown.serializer)
      ..add(V1ProvidersSlugReviewsGet200Response.serializer)
      ..add(V1ProvidersSlugReviewsGet200ResponseItemsInner.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CategoryTreeNode)]),
          () => ListBuilder<CategoryTreeNode>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CategoryTreeNode)]),
          () => ListBuilder<CategoryTreeNode>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(CategoryTreeNodeInput)]),
          () => ListBuilder<CategoryTreeNodeInput>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(V1AuthOtpVerifyPost200ResponseUserRolesEnum)
          ]),
          () => ListBuilder<V1AuthOtpVerifyPost200ResponseUserRolesEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(V1AuthOtpVerifyPost200ResponseUserRolesEnum)
          ]),
          () => ListBuilder<V1AuthOtpVerifyPost200ResponseUserRolesEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(V1FavoritesGet200ResponseItemsInner)]),
          () => ListBuilder<V1FavoritesGet200ResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(V1GovernoratesGet200ResponseGovernoratesInner)
          ]),
          () => ListBuilder<V1GovernoratesGet200ResponseGovernoratesInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(
                V1GovernoratesIdDelegationsGet200ResponseDelegationsInner)
          ]),
          () => ListBuilder<
              V1GovernoratesIdDelegationsGet200ResponseDelegationsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(V1ProvidersMeCategoriesPut200ResponseCategoriesInner)
          ]),
          () => ListBuilder<
              V1ProvidersMeCategoriesPut200ResponseCategoriesInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(V1ProvidersMeCategoriesPutRequestCategoriesInner)
          ]),
          () => ListBuilder<V1ProvidersMeCategoriesPutRequestCategoriesInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(
                V1ProvidersMeCoverageAreasPut200ResponseCoverageAreasInner)
          ]),
          () => ListBuilder<
              V1ProvidersMeCoverageAreasPut200ResponseCoverageAreasInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(
                V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner)
          ]),
          () => ListBuilder<
              V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(
                V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum)
          ]),
          () => ListBuilder<
              V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(
                V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum)
          ]),
          () => ListBuilder<
              V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(V1ProvidersSlugGet200ResponseCategoriesInner)
          ]),
          () => ListBuilder<V1ProvidersSlugGet200ResponseCategoriesInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(V1ProvidersSlugGet200ResponseOfferingsInner)
          ]),
          () => ListBuilder<V1ProvidersSlugGet200ResponseOfferingsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(V1ProvidersSlugGet200ResponseCoverageAreasInner)
          ]),
          () => ListBuilder<V1ProvidersSlugGet200ResponseCoverageAreasInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(V1ProvidersSlugGet200ResponseGalleryInner)
          ]),
          () => ListBuilder<V1ProvidersSlugGet200ResponseGalleryInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(V1ProvidersMePostRequestSpokenLanguagesEnum)
          ]),
          () => ListBuilder<V1ProvidersMePostRequestSpokenLanguagesEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(V1ProvidersSearchGet200ResponseItemsInner)
          ]),
          () => ListBuilder<V1ProvidersSearchGet200ResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(
                V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner)
          ]),
          () => ListBuilder<
              V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(V1ProvidersSlugReviewsGet200ResponseItemsInner)
          ]),
          () => ListBuilder<V1ProvidersSlugReviewsGet200ResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sanaya_api_client/src/model/v1_providers_slug_get200_response_gallery_inner.dart';
import 'package:sanaya_api_client/src/model/v1_providers_slug_get200_response_offerings_inner.dart';
import 'package:sanaya_api_client/src/model/v1_providers_slug_get200_response_base_governorate.dart';
import 'package:sanaya_api_client/src/model/v1_providers_slug_get200_response_review_aggregate.dart';
import 'package:built_collection/built_collection.dart';
import 'package:sanaya_api_client/src/model/v1_providers_slug_get200_response_categories_inner.dart';
import 'package:sanaya_api_client/src/model/v1_providers_slug_get200_response_base_delegation.dart';
import 'package:sanaya_api_client/src/model/v1_providers_slug_get200_response_coverage_areas_inner.dart';
import 'package:built_value/built_value.dart';
import 'shared_enums.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_slug_get200_response.g.dart';

/// V1ProvidersSlugGet200Response
///
/// Properties:
/// * [id]
/// * [slug]
/// * [businessName]
/// * [headline]
/// * [bio]
/// * [yearsExperience]
/// * [spokenLanguages]
/// * [baseGovernorate]
/// * [baseDelegation]
/// * [latitude]
/// * [longitude]
/// * [isVerified]
/// * [availabilityStatus]
/// * [availableAgainAt]
/// * [acceptsEmergency]
/// * [completionScore]
/// * [categories]
/// * [offerings]
/// * [coverageAreas]
/// * [gallery]
/// * [reviewAggregate]
@BuiltValue()
abstract class V1ProvidersSlugGet200Response
    implements
        Built<V1ProvidersSlugGet200Response,
            V1ProvidersSlugGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'businessName')
  String get businessName;

  @BuiltValueField(wireName: r'headline')
  String get headline;

  @BuiltValueField(wireName: r'bio')
  String get bio;

  @BuiltValueField(wireName: r'yearsExperience')
  int get yearsExperience;

  @BuiltValueField(wireName: r'spokenLanguages')
  BuiltList<V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>
      get spokenLanguages;
  // enum spokenLanguagesEnum {  FR,  AR,  EN,  };

  @BuiltValueField(wireName: r'baseGovernorate')
  V1ProvidersSlugGet200ResponseBaseGovernorate get baseGovernorate;

  @BuiltValueField(wireName: r'baseDelegation')
  V1ProvidersSlugGet200ResponseBaseDelegation get baseDelegation;

  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'isVerified')
  bool get isVerified;

  @BuiltValueField(wireName: r'availabilityStatus')
  V1ProvidersSlugGet200ResponseAvailabilityStatusEnum get availabilityStatus;
  // enum availabilityStatusEnum {  AVAILABLE,  BUSY,  ON_HOLIDAY,  };

  @BuiltValueField(wireName: r'availableAgainAt')
  DateTime get availableAgainAt;

  @BuiltValueField(wireName: r'acceptsEmergency')
  bool get acceptsEmergency;

  @BuiltValueField(wireName: r'completionScore')
  int get completionScore;

  @BuiltValueField(wireName: r'categories')
  BuiltList<V1ProvidersSlugGet200ResponseCategoriesInner> get categories;

  @BuiltValueField(wireName: r'offerings')
  BuiltList<V1ProvidersSlugGet200ResponseOfferingsInner> get offerings;

  @BuiltValueField(wireName: r'coverageAreas')
  BuiltList<V1ProvidersSlugGet200ResponseCoverageAreasInner> get coverageAreas;

  @BuiltValueField(wireName: r'gallery')
  BuiltList<V1ProvidersSlugGet200ResponseGalleryInner> get gallery;

  @BuiltValueField(wireName: r'reviewAggregate')
  V1ProvidersSlugGet200ResponseReviewAggregate get reviewAggregate;

  V1ProvidersSlugGet200Response._();

  factory V1ProvidersSlugGet200Response(
          [void updates(V1ProvidersSlugGet200ResponseBuilder b)]) =
      _$V1ProvidersSlugGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersSlugGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersSlugGet200Response> get serializer =>
      _$V1ProvidersSlugGet200ResponseSerializer();
}

class _$V1ProvidersSlugGet200ResponseSerializer
    implements PrimitiveSerializer<V1ProvidersSlugGet200Response> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersSlugGet200Response,
    _$V1ProvidersSlugGet200Response
  ];

  @override
  final String wireName = r'V1ProvidersSlugGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersSlugGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
    yield r'businessName';
    yield serializers.serialize(
      object.businessName,
      specifiedType: const FullType(String),
    );
    yield r'headline';
    yield serializers.serialize(
      object.headline,
      specifiedType: const FullType(String),
    );
    yield r'bio';
    yield serializers.serialize(
      object.bio,
      specifiedType: const FullType(String),
    );
    yield r'yearsExperience';
    yield serializers.serialize(
      object.yearsExperience,
      specifiedType: const FullType(int),
    );
    yield r'spokenLanguages';
    yield serializers.serialize(
      object.spokenLanguages,
      specifiedType: const FullType(BuiltList,
          [FullType(V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum)]),
    );
    yield r'baseGovernorate';
    yield serializers.serialize(
      object.baseGovernorate,
      specifiedType:
          const FullType(V1ProvidersSlugGet200ResponseBaseGovernorate),
    );
    yield r'baseDelegation';
    yield serializers.serialize(
      object.baseDelegation,
      specifiedType:
          const FullType(V1ProvidersSlugGet200ResponseBaseDelegation),
    );
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
    yield r'isVerified';
    yield serializers.serialize(
      object.isVerified,
      specifiedType: const FullType(bool),
    );
    yield r'availabilityStatus';
    yield serializers.serialize(
      object.availabilityStatus,
      specifiedType:
          const FullType(V1ProvidersSlugGet200ResponseAvailabilityStatusEnum),
    );
    yield r'availableAgainAt';
    yield serializers.serialize(
      object.availableAgainAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'acceptsEmergency';
    yield serializers.serialize(
      object.acceptsEmergency,
      specifiedType: const FullType(bool),
    );
    yield r'completionScore';
    yield serializers.serialize(
      object.completionScore,
      specifiedType: const FullType(int),
    );
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(
          BuiltList, [FullType(V1ProvidersSlugGet200ResponseCategoriesInner)]),
    );
    yield r'offerings';
    yield serializers.serialize(
      object.offerings,
      specifiedType: const FullType(
          BuiltList, [FullType(V1ProvidersSlugGet200ResponseOfferingsInner)]),
    );
    yield r'coverageAreas';
    yield serializers.serialize(
      object.coverageAreas,
      specifiedType: const FullType(BuiltList,
          [FullType(V1ProvidersSlugGet200ResponseCoverageAreasInner)]),
    );
    yield r'gallery';
    yield serializers.serialize(
      object.gallery,
      specifiedType: const FullType(
          BuiltList, [FullType(V1ProvidersSlugGet200ResponseGalleryInner)]),
    );
    yield r'reviewAggregate';
    yield serializers.serialize(
      object.reviewAggregate,
      specifiedType:
          const FullType(V1ProvidersSlugGet200ResponseReviewAggregate),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersSlugGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required V1ProvidersSlugGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        case r'businessName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.businessName = valueDes;
          break;
        case r'headline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.headline = valueDes;
          break;
        case r'bio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bio = valueDes;
          break;
        case r'yearsExperience':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.yearsExperience = valueDes;
          break;
        case r'spokenLanguages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType(V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum)
            ]),
          ) as BuiltList<
              V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>;
          result.spokenLanguages.replace(valueDes);
          break;
        case r'baseGovernorate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(V1ProvidersSlugGet200ResponseBaseGovernorate),
          ) as V1ProvidersSlugGet200ResponseBaseGovernorate;
          result.baseGovernorate = valueDes.toBuilder();
          break;
        case r'baseDelegation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(V1ProvidersSlugGet200ResponseBaseDelegation),
          ) as V1ProvidersSlugGet200ResponseBaseDelegation;
          result.baseDelegation = valueDes.toBuilder();
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.longitude = valueDes;
          break;
        case r'isVerified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isVerified = valueDes;
          break;
        case r'availabilityStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1ProvidersSlugGet200ResponseAvailabilityStatusEnum),
          ) as V1ProvidersSlugGet200ResponseAvailabilityStatusEnum;
          result.availabilityStatus = valueDes;
          break;
        case r'availableAgainAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.availableAgainAt = valueDes;
          break;
        case r'acceptsEmergency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.acceptsEmergency = valueDes;
          break;
        case r'completionScore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.completionScore = valueDes;
          break;
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(V1ProvidersSlugGet200ResponseCategoriesInner)]),
          ) as BuiltList<V1ProvidersSlugGet200ResponseCategoriesInner>;
          result.categories.replace(valueDes);
          break;
        case r'offerings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(V1ProvidersSlugGet200ResponseOfferingsInner)]),
          ) as BuiltList<V1ProvidersSlugGet200ResponseOfferingsInner>;
          result.offerings.replace(valueDes);
          break;
        case r'coverageAreas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(V1ProvidersSlugGet200ResponseCoverageAreasInner)]),
          ) as BuiltList<V1ProvidersSlugGet200ResponseCoverageAreasInner>;
          result.coverageAreas.replace(valueDes);
          break;
        case r'gallery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(V1ProvidersSlugGet200ResponseGalleryInner)]),
          ) as BuiltList<V1ProvidersSlugGet200ResponseGalleryInner>;
          result.gallery.replace(valueDes);
          break;
        case r'reviewAggregate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(V1ProvidersSlugGet200ResponseReviewAggregate),
          ) as V1ProvidersSlugGet200ResponseReviewAggregate;
          result.reviewAggregate = valueDes.toBuilder();
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersSlugGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersSlugGet200ResponseBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class V1ProvidersSlugGet200ResponseAvailabilityStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'AVAILABLE')
  static const V1ProvidersSlugGet200ResponseAvailabilityStatusEnum AVAILABLE =
      _$v1ProvidersSlugGet200ResponseAvailabilityStatusEnum_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'BUSY')
  static const V1ProvidersSlugGet200ResponseAvailabilityStatusEnum BUSY =
      _$v1ProvidersSlugGet200ResponseAvailabilityStatusEnum_BUSY;
  @BuiltValueEnumConst(wireName: r'ON_HOLIDAY')
  static const V1ProvidersSlugGet200ResponseAvailabilityStatusEnum ON_HOLIDAY =
      _$v1ProvidersSlugGet200ResponseAvailabilityStatusEnum_ON_HOLIDAY;

  static Serializer<V1ProvidersSlugGet200ResponseAvailabilityStatusEnum>
      get serializer =>
          _$v1ProvidersSlugGet200ResponseAvailabilityStatusEnumSerializer;

  const V1ProvidersSlugGet200ResponseAvailabilityStatusEnum._(String name)
      : super(name);

  static BuiltSet<V1ProvidersSlugGet200ResponseAvailabilityStatusEnum>
      get values => _$v1ProvidersSlugGet200ResponseAvailabilityStatusEnumValues;
  static V1ProvidersSlugGet200ResponseAvailabilityStatusEnum valueOf(
          String name) =>
      _$v1ProvidersSlugGet200ResponseAvailabilityStatusEnumValueOf(name);
}

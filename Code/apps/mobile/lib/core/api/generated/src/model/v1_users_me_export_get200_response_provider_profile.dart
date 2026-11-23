//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_users_me_export_get200_response_provider_profile_offerings_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_users_me_export_get200_response_provider_profile_coverage_areas_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_users_me_export_get200_response_provider_profile_categories_inner.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_users_me_export_get200_response_provider_profile.g.dart';

/// V1UsersMeExportGet200ResponseProviderProfile
///
/// Properties:
/// * [id]
/// * [slug]
/// * [businessName]
/// * [headline]
/// * [bio]
/// * [yearsExperience]
/// * [whatsappPhone]
/// * [publicPhone]
/// * [spokenLanguages]
/// * [baseGovernorate]
/// * [baseDelegation]
/// * [publicationStatus]
/// * [availabilityStatus]
/// * [isVerified]
/// * [verifiedAt]
/// * [ratingAvg]
/// * [ratingCount]
/// * [categories]
/// * [offerings]
/// * [coverageAreas]
/// * [portfolioCount]
@BuiltValue()
abstract class V1UsersMeExportGet200ResponseProviderProfile
    implements
        Built<V1UsersMeExportGet200ResponseProviderProfile,
            V1UsersMeExportGet200ResponseProviderProfileBuilder> {
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

  @BuiltValueField(wireName: r'whatsappPhone')
  String get whatsappPhone;

  @BuiltValueField(wireName: r'publicPhone')
  String get publicPhone;

  @BuiltValueField(wireName: r'spokenLanguages')
  BuiltList<String> get spokenLanguages;

  @BuiltValueField(wireName: r'baseGovernorate')
  String get baseGovernorate;

  @BuiltValueField(wireName: r'baseDelegation')
  String get baseDelegation;

  @BuiltValueField(wireName: r'publicationStatus')
  String get publicationStatus;

  @BuiltValueField(wireName: r'availabilityStatus')
  String get availabilityStatus;

  @BuiltValueField(wireName: r'isVerified')
  bool get isVerified;

  @BuiltValueField(wireName: r'verifiedAt')
  DateTime get verifiedAt;

  @BuiltValueField(wireName: r'ratingAvg')
  num get ratingAvg;

  @BuiltValueField(wireName: r'ratingCount')
  int get ratingCount;

  @BuiltValueField(wireName: r'categories')
  BuiltList<V1UsersMeExportGet200ResponseProviderProfileCategoriesInner>
      get categories;

  @BuiltValueField(wireName: r'offerings')
  BuiltList<V1UsersMeExportGet200ResponseProviderProfileOfferingsInner>
      get offerings;

  @BuiltValueField(wireName: r'coverageAreas')
  BuiltList<V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner>
      get coverageAreas;

  @BuiltValueField(wireName: r'portfolioCount')
  int get portfolioCount;

  V1UsersMeExportGet200ResponseProviderProfile._();

  factory V1UsersMeExportGet200ResponseProviderProfile(
          [void updates(
              V1UsersMeExportGet200ResponseProviderProfileBuilder b)]) =
      _$V1UsersMeExportGet200ResponseProviderProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1UsersMeExportGet200ResponseProviderProfileBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1UsersMeExportGet200ResponseProviderProfile>
      get serializer =>
          _$V1UsersMeExportGet200ResponseProviderProfileSerializer();
}

class _$V1UsersMeExportGet200ResponseProviderProfileSerializer
    implements
        PrimitiveSerializer<V1UsersMeExportGet200ResponseProviderProfile> {
  @override
  final Iterable<Type> types = const [
    V1UsersMeExportGet200ResponseProviderProfile,
    _$V1UsersMeExportGet200ResponseProviderProfile
  ];

  @override
  final String wireName = r'V1UsersMeExportGet200ResponseProviderProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1UsersMeExportGet200ResponseProviderProfile object, {
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
    yield r'whatsappPhone';
    yield serializers.serialize(
      object.whatsappPhone,
      specifiedType: const FullType(String),
    );
    yield r'publicPhone';
    yield serializers.serialize(
      object.publicPhone,
      specifiedType: const FullType(String),
    );
    yield r'spokenLanguages';
    yield serializers.serialize(
      object.spokenLanguages,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'baseGovernorate';
    yield serializers.serialize(
      object.baseGovernorate,
      specifiedType: const FullType(String),
    );
    yield r'baseDelegation';
    yield serializers.serialize(
      object.baseDelegation,
      specifiedType: const FullType(String),
    );
    yield r'publicationStatus';
    yield serializers.serialize(
      object.publicationStatus,
      specifiedType: const FullType(String),
    );
    yield r'availabilityStatus';
    yield serializers.serialize(
      object.availabilityStatus,
      specifiedType: const FullType(String),
    );
    yield r'isVerified';
    yield serializers.serialize(
      object.isVerified,
      specifiedType: const FullType(bool),
    );
    yield r'verifiedAt';
    yield serializers.serialize(
      object.verifiedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'ratingAvg';
    yield serializers.serialize(
      object.ratingAvg,
      specifiedType: const FullType(num),
    );
    yield r'ratingCount';
    yield serializers.serialize(
      object.ratingCount,
      specifiedType: const FullType(int),
    );
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [
        FullType(V1UsersMeExportGet200ResponseProviderProfileCategoriesInner)
      ]),
    );
    yield r'offerings';
    yield serializers.serialize(
      object.offerings,
      specifiedType: const FullType(BuiltList, [
        FullType(V1UsersMeExportGet200ResponseProviderProfileOfferingsInner)
      ]),
    );
    yield r'coverageAreas';
    yield serializers.serialize(
      object.coverageAreas,
      specifiedType: const FullType(BuiltList, [
        FullType(V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner)
      ]),
    );
    yield r'portfolioCount';
    yield serializers.serialize(
      object.portfolioCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1UsersMeExportGet200ResponseProviderProfile object, {
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
    required V1UsersMeExportGet200ResponseProviderProfileBuilder result,
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
        case r'whatsappPhone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.whatsappPhone = valueDes;
          break;
        case r'publicPhone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.publicPhone = valueDes;
          break;
        case r'spokenLanguages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.spokenLanguages.replace(valueDes);
          break;
        case r'baseGovernorate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.baseGovernorate = valueDes;
          break;
        case r'baseDelegation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.baseDelegation = valueDes;
          break;
        case r'publicationStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.publicationStatus = valueDes;
          break;
        case r'availabilityStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.availabilityStatus = valueDes;
          break;
        case r'isVerified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isVerified = valueDes;
          break;
        case r'verifiedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.verifiedAt = valueDes;
          break;
        case r'ratingAvg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.ratingAvg = valueDes;
          break;
        case r'ratingCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ratingCount = valueDes;
          break;
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType(
                  V1UsersMeExportGet200ResponseProviderProfileCategoriesInner)
            ]),
          ) as BuiltList<
              V1UsersMeExportGet200ResponseProviderProfileCategoriesInner>;
          result.categories.replace(valueDes);
          break;
        case r'offerings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType(
                  V1UsersMeExportGet200ResponseProviderProfileOfferingsInner)
            ]),
          ) as BuiltList<
              V1UsersMeExportGet200ResponseProviderProfileOfferingsInner>;
          result.offerings.replace(valueDes);
          break;
        case r'coverageAreas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType(
                  V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner)
            ]),
          ) as BuiltList<
              V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner>;
          result.coverageAreas.replace(valueDes);
          break;
        case r'portfolioCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.portfolioCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1UsersMeExportGet200ResponseProviderProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1UsersMeExportGet200ResponseProviderProfileBuilder();
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

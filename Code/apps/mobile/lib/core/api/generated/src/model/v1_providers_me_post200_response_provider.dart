//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'shared_enums.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_post200_response_provider.g.dart';

/// V1ProvidersMePost200ResponseProvider
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
/// * [baseGovernorateId]
/// * [baseDelegationId]
/// * [latitude]
/// * [longitude]
/// * [publicationStatus]
/// * [availabilityStatus]
/// * [availableAgainAt]
/// * [acceptsEmergency]
/// * [workingHours]
/// * [isVerified]
/// * [verifiedAt]
/// * [ratingAvg]
/// * [ratingCount]
/// * [totalProfileViews]
/// * [totalContacts]
/// * [completionScore]
/// * [rankingScore]
/// * [lastActiveAt]
/// * [createdAt]
/// * [updatedAt]
@BuiltValue()
abstract class V1ProvidersMePost200ResponseProvider
    implements
        Built<
          V1ProvidersMePost200ResponseProvider,
          V1ProvidersMePost200ResponseProviderBuilder
        > {
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
  BuiltList<V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>
  get spokenLanguages;
  // enum spokenLanguagesEnum {  FR,  AR,  EN,  };

  @BuiltValueField(wireName: r'baseGovernorateId')
  String get baseGovernorateId;

  @BuiltValueField(wireName: r'baseDelegationId')
  String get baseDelegationId;

  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'publicationStatus')
  V1ProvidersMePost200ResponseProviderPublicationStatusEnum
  get publicationStatus;
  // enum publicationStatusEnum {  DRAFT,  PUBLISHED,  HIDDEN,  SUSPENDED,  };

  @BuiltValueField(wireName: r'availabilityStatus')
  V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum
  get availabilityStatus;
  // enum availabilityStatusEnum {  AVAILABLE,  BUSY,  ON_HOLIDAY,  };

  @BuiltValueField(wireName: r'availableAgainAt')
  DateTime get availableAgainAt;

  @BuiltValueField(wireName: r'acceptsEmergency')
  bool get acceptsEmergency;

  @BuiltValueField(wireName: r'workingHours')
  JsonObject get workingHours;

  @BuiltValueField(wireName: r'isVerified')
  bool get isVerified;

  @BuiltValueField(wireName: r'verifiedAt')
  DateTime get verifiedAt;

  @BuiltValueField(wireName: r'ratingAvg')
  num get ratingAvg;

  @BuiltValueField(wireName: r'ratingCount')
  int get ratingCount;

  @BuiltValueField(wireName: r'totalProfileViews')
  int get totalProfileViews;

  @BuiltValueField(wireName: r'totalContacts')
  int get totalContacts;

  @BuiltValueField(wireName: r'completionScore')
  int get completionScore;

  @BuiltValueField(wireName: r'rankingScore')
  num get rankingScore;

  @BuiltValueField(wireName: r'lastActiveAt')
  DateTime get lastActiveAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  V1ProvidersMePost200ResponseProvider._();

  factory V1ProvidersMePost200ResponseProvider([
    void updates(V1ProvidersMePost200ResponseProviderBuilder b),
  ]) = _$V1ProvidersMePost200ResponseProvider;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMePost200ResponseProviderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMePost200ResponseProvider> get serializer =>
      _$V1ProvidersMePost200ResponseProviderSerializer();
}

class _$V1ProvidersMePost200ResponseProviderSerializer
    implements PrimitiveSerializer<V1ProvidersMePost200ResponseProvider> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMePost200ResponseProvider,
    _$V1ProvidersMePost200ResponseProvider,
  ];

  @override
  final String wireName = r'V1ProvidersMePost200ResponseProvider';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMePost200ResponseProvider object, {
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
      specifiedType: const FullType(BuiltList, [
        FullType(V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum),
      ]),
    );
    yield r'baseGovernorateId';
    yield serializers.serialize(
      object.baseGovernorateId,
      specifiedType: const FullType(String),
    );
    yield r'baseDelegationId';
    yield serializers.serialize(
      object.baseDelegationId,
      specifiedType: const FullType(String),
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
    yield r'publicationStatus';
    yield serializers.serialize(
      object.publicationStatus,
      specifiedType: const FullType(
        V1ProvidersMePost200ResponseProviderPublicationStatusEnum,
      ),
    );
    yield r'availabilityStatus';
    yield serializers.serialize(
      object.availabilityStatus,
      specifiedType: const FullType(
        V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum,
      ),
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
    yield r'workingHours';
    yield serializers.serialize(
      object.workingHours,
      specifiedType: const FullType(JsonObject),
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
    yield r'totalProfileViews';
    yield serializers.serialize(
      object.totalProfileViews,
      specifiedType: const FullType(int),
    );
    yield r'totalContacts';
    yield serializers.serialize(
      object.totalContacts,
      specifiedType: const FullType(int),
    );
    yield r'completionScore';
    yield serializers.serialize(
      object.completionScore,
      specifiedType: const FullType(int),
    );
    yield r'rankingScore';
    yield serializers.serialize(
      object.rankingScore,
      specifiedType: const FullType(num),
    );
    yield r'lastActiveAt';
    yield serializers.serialize(
      object.lastActiveAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMePost200ResponseProvider object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required V1ProvidersMePost200ResponseProviderBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'slug':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.slug = valueDes;
          break;
        case r'businessName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.businessName = valueDes;
          break;
        case r'headline':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.headline = valueDes;
          break;
        case r'bio':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.bio = valueDes;
          break;
        case r'yearsExperience':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )
                  as int;
          result.yearsExperience = valueDes;
          break;
        case r'whatsappPhone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.whatsappPhone = valueDes;
          break;
        case r'publicPhone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.publicPhone = valueDes;
          break;
        case r'spokenLanguages':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum,
                      ),
                    ]),
                  )
                  as BuiltList<
                    V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum
                  >;
          result.spokenLanguages.replace(valueDes);
          break;
        case r'baseGovernorateId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.baseGovernorateId = valueDes;
          break;
        case r'baseDelegationId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.baseDelegationId = valueDes;
          break;
        case r'latitude':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(num),
                  )
                  as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(num),
                  )
                  as num;
          result.longitude = valueDes;
          break;
        case r'publicationStatus':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      V1ProvidersMePost200ResponseProviderPublicationStatusEnum,
                    ),
                  )
                  as V1ProvidersMePost200ResponseProviderPublicationStatusEnum;
          result.publicationStatus = valueDes;
          break;
        case r'availabilityStatus':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum,
                    ),
                  )
                  as V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum;
          result.availabilityStatus = valueDes;
          break;
        case r'availableAgainAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.availableAgainAt = valueDes;
          break;
        case r'acceptsEmergency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.acceptsEmergency = valueDes;
          break;
        case r'workingHours':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(JsonObject),
                  )
                  as JsonObject;
          result.workingHours = valueDes;
          break;
        case r'isVerified':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.isVerified = valueDes;
          break;
        case r'verifiedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.verifiedAt = valueDes;
          break;
        case r'ratingAvg':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(num),
                  )
                  as num;
          result.ratingAvg = valueDes;
          break;
        case r'ratingCount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )
                  as int;
          result.ratingCount = valueDes;
          break;
        case r'totalProfileViews':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )
                  as int;
          result.totalProfileViews = valueDes;
          break;
        case r'totalContacts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )
                  as int;
          result.totalContacts = valueDes;
          break;
        case r'completionScore':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )
                  as int;
          result.completionScore = valueDes;
          break;
        case r'rankingScore':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(num),
                  )
                  as num;
          result.rankingScore = valueDes;
          break;
        case r'lastActiveAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.lastActiveAt = valueDes;
          break;
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMePost200ResponseProvider deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMePost200ResponseProviderBuilder();
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

class V1ProvidersMePost200ResponseProviderPublicationStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const V1ProvidersMePost200ResponseProviderPublicationStatusEnum DRAFT =
      _$v1ProvidersMePost200ResponseProviderPublicationStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'PUBLISHED')
  static const V1ProvidersMePost200ResponseProviderPublicationStatusEnum
  PUBLISHED =
      _$v1ProvidersMePost200ResponseProviderPublicationStatusEnum_PUBLISHED;
  @BuiltValueEnumConst(wireName: r'HIDDEN')
  static const V1ProvidersMePost200ResponseProviderPublicationStatusEnum
  HIDDEN = _$v1ProvidersMePost200ResponseProviderPublicationStatusEnum_HIDDEN;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const V1ProvidersMePost200ResponseProviderPublicationStatusEnum
  SUSPENDED =
      _$v1ProvidersMePost200ResponseProviderPublicationStatusEnum_SUSPENDED;

  static Serializer<V1ProvidersMePost200ResponseProviderPublicationStatusEnum>
  get serializer =>
      _$v1ProvidersMePost200ResponseProviderPublicationStatusEnumSerializer;

  const V1ProvidersMePost200ResponseProviderPublicationStatusEnum._(String name)
    : super(name);

  static BuiltSet<V1ProvidersMePost200ResponseProviderPublicationStatusEnum>
  get values =>
      _$v1ProvidersMePost200ResponseProviderPublicationStatusEnumValues;
  static V1ProvidersMePost200ResponseProviderPublicationStatusEnum valueOf(
    String name,
  ) => _$v1ProvidersMePost200ResponseProviderPublicationStatusEnumValueOf(name);
}

class V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'AVAILABLE')
  static const V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum
  AVAILABLE =
      _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnum_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'BUSY')
  static const V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum BUSY =
      _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnum_BUSY;
  @BuiltValueEnumConst(wireName: r'ON_HOLIDAY')
  static const V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum
  ON_HOLIDAY =
      _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnum_ON_HOLIDAY;

  static Serializer<V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum>
  get serializer =>
      _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnumSerializer;

  const V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum._(
    String name,
  ) : super(name);

  static BuiltSet<V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum>
  get values =>
      _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnumValues;
  static V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum valueOf(
    String name,
  ) =>
      _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnumValueOf(name);
}

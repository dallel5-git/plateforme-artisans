//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_patch_request.g.dart';

/// V1ProvidersMePatchRequest
///
/// Properties:
/// * [businessName]
/// * [headline]
/// * [bio]
/// * [yearsExperience]
/// * [whatsappPhone]
/// * [publicPhone]
/// * [availabilityStatus]
/// * [availableAgainAt]
/// * [acceptsEmergency]
/// * [workingHours]
/// * [publicationStatus]
@BuiltValue()
abstract class V1ProvidersMePatchRequest
    implements
        Built<V1ProvidersMePatchRequest, V1ProvidersMePatchRequestBuilder> {
  @BuiltValueField(wireName: r'businessName')
  String? get businessName;

  @BuiltValueField(wireName: r'headline')
  String? get headline;

  @BuiltValueField(wireName: r'bio')
  String? get bio;

  @BuiltValueField(wireName: r'yearsExperience')
  int? get yearsExperience;

  @BuiltValueField(wireName: r'whatsappPhone')
  String? get whatsappPhone;

  @BuiltValueField(wireName: r'publicPhone')
  String? get publicPhone;

  @BuiltValueField(wireName: r'availabilityStatus')
  V1ProvidersMePatchRequestAvailabilityStatusEnum? get availabilityStatus;
  // enum availabilityStatusEnum {  AVAILABLE,  BUSY,  ON_HOLIDAY,  };

  @BuiltValueField(wireName: r'availableAgainAt')
  JsonObject? get availableAgainAt;

  @BuiltValueField(wireName: r'acceptsEmergency')
  bool? get acceptsEmergency;

  @BuiltValueField(wireName: r'workingHours')
  BuiltMap<String, JsonObject?>? get workingHours;

  @BuiltValueField(wireName: r'publicationStatus')
  V1ProvidersMePatchRequestPublicationStatusEnum? get publicationStatus;
  // enum publicationStatusEnum {  DRAFT,  PUBLISHED,  };

  V1ProvidersMePatchRequest._();

  factory V1ProvidersMePatchRequest(
          [void updates(V1ProvidersMePatchRequestBuilder b)]) =
      _$V1ProvidersMePatchRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMePatchRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMePatchRequest> get serializer =>
      _$V1ProvidersMePatchRequestSerializer();
}

class _$V1ProvidersMePatchRequestSerializer
    implements PrimitiveSerializer<V1ProvidersMePatchRequest> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMePatchRequest,
    _$V1ProvidersMePatchRequest
  ];

  @override
  final String wireName = r'V1ProvidersMePatchRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMePatchRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.businessName != null) {
      yield r'businessName';
      yield serializers.serialize(
        object.businessName,
        specifiedType: const FullType(String),
      );
    }
    if (object.headline != null) {
      yield r'headline';
      yield serializers.serialize(
        object.headline,
        specifiedType: const FullType(String),
      );
    }
    if (object.bio != null) {
      yield r'bio';
      yield serializers.serialize(
        object.bio,
        specifiedType: const FullType(String),
      );
    }
    if (object.yearsExperience != null) {
      yield r'yearsExperience';
      yield serializers.serialize(
        object.yearsExperience,
        specifiedType: const FullType(int),
      );
    }
    if (object.whatsappPhone != null) {
      yield r'whatsappPhone';
      yield serializers.serialize(
        object.whatsappPhone,
        specifiedType: const FullType(String),
      );
    }
    if (object.publicPhone != null) {
      yield r'publicPhone';
      yield serializers.serialize(
        object.publicPhone,
        specifiedType: const FullType(String),
      );
    }
    if (object.availabilityStatus != null) {
      yield r'availabilityStatus';
      yield serializers.serialize(
        object.availabilityStatus,
        specifiedType:
            const FullType(V1ProvidersMePatchRequestAvailabilityStatusEnum),
      );
    }
    if (object.availableAgainAt != null) {
      yield r'availableAgainAt';
      yield serializers.serialize(
        object.availableAgainAt,
        specifiedType: const FullType(JsonObject),
      );
    }
    if (object.acceptsEmergency != null) {
      yield r'acceptsEmergency';
      yield serializers.serialize(
        object.acceptsEmergency,
        specifiedType: const FullType(bool),
      );
    }
    if (object.workingHours != null) {
      yield r'workingHours';
      yield serializers.serialize(
        object.workingHours,
        specifiedType: const FullType(
            BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.publicationStatus != null) {
      yield r'publicationStatus';
      yield serializers.serialize(
        object.publicationStatus,
        specifiedType:
            const FullType(V1ProvidersMePatchRequestPublicationStatusEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMePatchRequest object, {
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
    required V1ProvidersMePatchRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'availabilityStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(V1ProvidersMePatchRequestAvailabilityStatusEnum),
          ) as V1ProvidersMePatchRequestAvailabilityStatusEnum;
          result.availabilityStatus = valueDes;
          break;
        case r'availableAgainAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.availableAgainAt = valueDes;
          break;
        case r'acceptsEmergency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.acceptsEmergency = valueDes;
          break;
        case r'workingHours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.workingHours.replace(valueDes);
          break;
        case r'publicationStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(V1ProvidersMePatchRequestPublicationStatusEnum),
          ) as V1ProvidersMePatchRequestPublicationStatusEnum;
          result.publicationStatus = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMePatchRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMePatchRequestBuilder();
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

class V1ProvidersMePatchRequestAvailabilityStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'AVAILABLE')
  static const V1ProvidersMePatchRequestAvailabilityStatusEnum AVAILABLE =
      _$v1ProvidersMePatchRequestAvailabilityStatusEnum_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'BUSY')
  static const V1ProvidersMePatchRequestAvailabilityStatusEnum BUSY =
      _$v1ProvidersMePatchRequestAvailabilityStatusEnum_BUSY;
  @BuiltValueEnumConst(wireName: r'ON_HOLIDAY')
  static const V1ProvidersMePatchRequestAvailabilityStatusEnum ON_HOLIDAY =
      _$v1ProvidersMePatchRequestAvailabilityStatusEnum_ON_HOLIDAY;

  static Serializer<V1ProvidersMePatchRequestAvailabilityStatusEnum>
      get serializer =>
          _$v1ProvidersMePatchRequestAvailabilityStatusEnumSerializer;

  const V1ProvidersMePatchRequestAvailabilityStatusEnum._(String name)
      : super(name);

  static BuiltSet<V1ProvidersMePatchRequestAvailabilityStatusEnum> get values =>
      _$v1ProvidersMePatchRequestAvailabilityStatusEnumValues;
  static V1ProvidersMePatchRequestAvailabilityStatusEnum valueOf(String name) =>
      _$v1ProvidersMePatchRequestAvailabilityStatusEnumValueOf(name);
}

class V1ProvidersMePatchRequestPublicationStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const V1ProvidersMePatchRequestPublicationStatusEnum DRAFT =
      _$v1ProvidersMePatchRequestPublicationStatusEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'PUBLISHED')
  static const V1ProvidersMePatchRequestPublicationStatusEnum PUBLISHED =
      _$v1ProvidersMePatchRequestPublicationStatusEnum_PUBLISHED;

  static Serializer<V1ProvidersMePatchRequestPublicationStatusEnum>
      get serializer =>
          _$v1ProvidersMePatchRequestPublicationStatusEnumSerializer;

  const V1ProvidersMePatchRequestPublicationStatusEnum._(String name)
      : super(name);

  static BuiltSet<V1ProvidersMePatchRequestPublicationStatusEnum> get values =>
      _$v1ProvidersMePatchRequestPublicationStatusEnumValues;
  static V1ProvidersMePatchRequestPublicationStatusEnum valueOf(String name) =>
      _$v1ProvidersMePatchRequestPublicationStatusEnumValueOf(name);
}

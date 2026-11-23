//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sanaya/core/api/generated/src/model/v1_admin_verifications_id_get200_response_provider_user.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_admin_verifications_id_get200_response_provider.g.dart';

/// V1AdminVerificationsIdGet200ResponseProvider
///
/// Properties:
/// * [id]
/// * [businessName]
/// * [slug]
/// * [headline]
/// * [baseGovernorateId]
/// * [isVerified]
/// * [verificationStatus]
/// * [user]
@BuiltValue()
abstract class V1AdminVerificationsIdGet200ResponseProvider
    implements
        Built<V1AdminVerificationsIdGet200ResponseProvider,
            V1AdminVerificationsIdGet200ResponseProviderBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'businessName')
  String get businessName;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'headline')
  String get headline;

  @BuiltValueField(wireName: r'baseGovernorateId')
  String get baseGovernorateId;

  @BuiltValueField(wireName: r'isVerified')
  bool get isVerified;

  @BuiltValueField(wireName: r'verificationStatus')
  V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
      get verificationStatus;
  // enum verificationStatusEnum {  NOT_SUBMITTED,  PENDING,  MORE_INFO_REQUIRED,  APPROVED,  REJECTED,  };

  @BuiltValueField(wireName: r'user')
  V1AdminVerificationsIdGet200ResponseProviderUser get user;

  V1AdminVerificationsIdGet200ResponseProvider._();

  factory V1AdminVerificationsIdGet200ResponseProvider(
          [void updates(
              V1AdminVerificationsIdGet200ResponseProviderBuilder b)]) =
      _$V1AdminVerificationsIdGet200ResponseProvider;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1AdminVerificationsIdGet200ResponseProviderBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AdminVerificationsIdGet200ResponseProvider>
      get serializer =>
          _$V1AdminVerificationsIdGet200ResponseProviderSerializer();
}

class _$V1AdminVerificationsIdGet200ResponseProviderSerializer
    implements
        PrimitiveSerializer<V1AdminVerificationsIdGet200ResponseProvider> {
  @override
  final Iterable<Type> types = const [
    V1AdminVerificationsIdGet200ResponseProvider,
    _$V1AdminVerificationsIdGet200ResponseProvider
  ];

  @override
  final String wireName = r'V1AdminVerificationsIdGet200ResponseProvider';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AdminVerificationsIdGet200ResponseProvider object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'businessName';
    yield serializers.serialize(
      object.businessName,
      specifiedType: const FullType(String),
    );
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
    yield r'headline';
    yield serializers.serialize(
      object.headline,
      specifiedType: const FullType(String),
    );
    yield r'baseGovernorateId';
    yield serializers.serialize(
      object.baseGovernorateId,
      specifiedType: const FullType(String),
    );
    yield r'isVerified';
    yield serializers.serialize(
      object.isVerified,
      specifiedType: const FullType(bool),
    );
    yield r'verificationStatus';
    yield serializers.serialize(
      object.verificationStatus,
      specifiedType: const FullType(
          V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType:
          const FullType(V1AdminVerificationsIdGet200ResponseProviderUser),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AdminVerificationsIdGet200ResponseProvider object, {
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
    required V1AdminVerificationsIdGet200ResponseProviderBuilder result,
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
        case r'businessName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.businessName = valueDes;
          break;
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        case r'headline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.headline = valueDes;
          break;
        case r'baseGovernorateId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.baseGovernorateId = valueDes;
          break;
        case r'isVerified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isVerified = valueDes;
          break;
        case r'verificationStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum),
          ) as V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum;
          result.verificationStatus = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1AdminVerificationsIdGet200ResponseProviderUser),
          ) as V1AdminVerificationsIdGet200ResponseProviderUser;
          result.user = valueDes.toBuilder();
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1AdminVerificationsIdGet200ResponseProvider deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1AdminVerificationsIdGet200ResponseProviderBuilder();
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

class V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'NOT_SUBMITTED')
  static const V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
      NOT_SUBMITTED =
      _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_NOT_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING')
  static const V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
      PENDING =
      _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'MORE_INFO_REQUIRED')
  static const V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
      MORE_INFO_REQUIRED =
      _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_MORE_INFO_REQUIRED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
      APPROVED =
      _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
      REJECTED =
      _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_REJECTED;

  static Serializer<
          V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum>
      get serializer =>
          _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnumSerializer;

  const V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum._(
      String name)
      : super(name);

  static BuiltSet<
          V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum>
      get values =>
          _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnumValues;
  static V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum valueOf(
          String name) =>
      _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnumValueOf(
          name);
}

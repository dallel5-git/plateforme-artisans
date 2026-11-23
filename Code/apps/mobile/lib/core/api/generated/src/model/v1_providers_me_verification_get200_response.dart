//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_verification_get200_response_current_request.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_verification_get200_response.g.dart';

/// V1ProvidersMeVerificationGet200Response
///
/// Properties:
/// * [verificationStatus]
/// * [isVerified]
/// * [currentRequest]
@BuiltValue()
abstract class V1ProvidersMeVerificationGet200Response
    implements
        Built<V1ProvidersMeVerificationGet200Response,
            V1ProvidersMeVerificationGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'verificationStatus')
  V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
      get verificationStatus;
  // enum verificationStatusEnum {  NOT_SUBMITTED,  PENDING,  MORE_INFO_REQUIRED,  APPROVED,  REJECTED,  };

  @BuiltValueField(wireName: r'isVerified')
  bool get isVerified;

  @BuiltValueField(wireName: r'currentRequest')
  V1ProvidersMeVerificationGet200ResponseCurrentRequest get currentRequest;

  V1ProvidersMeVerificationGet200Response._();

  factory V1ProvidersMeVerificationGet200Response(
          [void updates(V1ProvidersMeVerificationGet200ResponseBuilder b)]) =
      _$V1ProvidersMeVerificationGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMeVerificationGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeVerificationGet200Response> get serializer =>
      _$V1ProvidersMeVerificationGet200ResponseSerializer();
}

class _$V1ProvidersMeVerificationGet200ResponseSerializer
    implements PrimitiveSerializer<V1ProvidersMeVerificationGet200Response> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeVerificationGet200Response,
    _$V1ProvidersMeVerificationGet200Response
  ];

  @override
  final String wireName = r'V1ProvidersMeVerificationGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeVerificationGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'verificationStatus';
    yield serializers.serialize(
      object.verificationStatus,
      specifiedType: const FullType(
          V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum),
    );
    yield r'isVerified';
    yield serializers.serialize(
      object.isVerified,
      specifiedType: const FullType(bool),
    );
    yield r'currentRequest';
    yield serializers.serialize(
      object.currentRequest,
      specifiedType:
          const FullType(V1ProvidersMeVerificationGet200ResponseCurrentRequest),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeVerificationGet200Response object, {
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
    required V1ProvidersMeVerificationGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'verificationStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum),
          ) as V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum;
          result.verificationStatus = valueDes;
          break;
        case r'isVerified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isVerified = valueDes;
          break;
        case r'currentRequest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1ProvidersMeVerificationGet200ResponseCurrentRequest),
          ) as V1ProvidersMeVerificationGet200ResponseCurrentRequest;
          result.currentRequest = valueDes.toBuilder();
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMeVerificationGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeVerificationGet200ResponseBuilder();
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

class V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'NOT_SUBMITTED')
  static const V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
      NOT_SUBMITTED =
      _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_NOT_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING')
  static const V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
      PENDING =
      _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'MORE_INFO_REQUIRED')
  static const V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
      MORE_INFO_REQUIRED =
      _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_MORE_INFO_REQUIRED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
      APPROVED =
      _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
      REJECTED =
      _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_REJECTED;

  static Serializer<
          V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum>
      get serializer =>
          _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnumSerializer;

  const V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum._(
      String name)
      : super(name);

  static BuiltSet<V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum>
      get values =>
          _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnumValues;
  static V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum valueOf(
          String name) =>
      _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnumValueOf(
          name);
}

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_verification_submit_post200_response.g.dart';

/// V1ProvidersMeVerificationSubmitPost200Response
///
/// Properties:
/// * [requestId]
/// * [status]
/// * [submittedAt]
@BuiltValue()
abstract class V1ProvidersMeVerificationSubmitPost200Response
    implements
        Built<V1ProvidersMeVerificationSubmitPost200Response,
            V1ProvidersMeVerificationSubmitPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'requestId')
  String get requestId;

  @BuiltValueField(wireName: r'status')
  V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum get status;
  // enum statusEnum {  NOT_SUBMITTED,  PENDING,  MORE_INFO_REQUIRED,  APPROVED,  REJECTED,  };

  @BuiltValueField(wireName: r'submittedAt')
  DateTime get submittedAt;

  V1ProvidersMeVerificationSubmitPost200Response._();

  factory V1ProvidersMeVerificationSubmitPost200Response(
          [void updates(
              V1ProvidersMeVerificationSubmitPost200ResponseBuilder b)]) =
      _$V1ProvidersMeVerificationSubmitPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1ProvidersMeVerificationSubmitPost200ResponseBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeVerificationSubmitPost200Response>
      get serializer =>
          _$V1ProvidersMeVerificationSubmitPost200ResponseSerializer();
}

class _$V1ProvidersMeVerificationSubmitPost200ResponseSerializer
    implements
        PrimitiveSerializer<V1ProvidersMeVerificationSubmitPost200Response> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeVerificationSubmitPost200Response,
    _$V1ProvidersMeVerificationSubmitPost200Response
  ];

  @override
  final String wireName = r'V1ProvidersMeVerificationSubmitPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeVerificationSubmitPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'requestId';
    yield serializers.serialize(
      object.requestId,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
          V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum),
    );
    yield r'submittedAt';
    yield serializers.serialize(
      object.submittedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeVerificationSubmitPost200Response object, {
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
    required V1ProvidersMeVerificationSubmitPost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'requestId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.requestId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum),
          ) as V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'submittedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.submittedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMeVerificationSubmitPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeVerificationSubmitPost200ResponseBuilder();
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

class V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'NOT_SUBMITTED')
  static const V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum
      NOT_SUBMITTED =
      _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_NOT_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING')
  static const V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum
      PENDING =
      _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'MORE_INFO_REQUIRED')
  static const V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum
      MORE_INFO_REQUIRED =
      _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_MORE_INFO_REQUIRED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum
      APPROVED =
      _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum
      REJECTED =
      _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_REJECTED;

  static Serializer<V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum>
      get serializer =>
          _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnumSerializer;

  const V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum._(String name)
      : super(name);

  static BuiltSet<V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum>
      get values =>
          _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnumValues;
  static V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum valueOf(
          String name) =>
      _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnumValueOf(name);
}

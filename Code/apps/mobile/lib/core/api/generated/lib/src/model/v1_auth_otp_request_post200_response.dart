//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_auth_otp_request_post200_response.g.dart';

/// V1AuthOtpRequestPost200Response
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class V1AuthOtpRequestPost200Response
    implements
        Built<V1AuthOtpRequestPost200Response,
            V1AuthOtpRequestPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'status')
  V1AuthOtpRequestPost200ResponseStatusEnum get status;
  // enum statusEnum {  sent,  };

  V1AuthOtpRequestPost200Response._();

  factory V1AuthOtpRequestPost200Response(
          [void updates(V1AuthOtpRequestPost200ResponseBuilder b)]) =
      _$V1AuthOtpRequestPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1AuthOtpRequestPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AuthOtpRequestPost200Response> get serializer =>
      _$V1AuthOtpRequestPost200ResponseSerializer();
}

class _$V1AuthOtpRequestPost200ResponseSerializer
    implements PrimitiveSerializer<V1AuthOtpRequestPost200Response> {
  @override
  final Iterable<Type> types = const [
    V1AuthOtpRequestPost200Response,
    _$V1AuthOtpRequestPost200Response
  ];

  @override
  final String wireName = r'V1AuthOtpRequestPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AuthOtpRequestPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(V1AuthOtpRequestPost200ResponseStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AuthOtpRequestPost200Response object, {
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
    required V1AuthOtpRequestPost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(V1AuthOtpRequestPost200ResponseStatusEnum),
          ) as V1AuthOtpRequestPost200ResponseStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1AuthOtpRequestPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1AuthOtpRequestPost200ResponseBuilder();
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

class V1AuthOtpRequestPost200ResponseStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'sent')
  static const V1AuthOtpRequestPost200ResponseStatusEnum sent =
      _$v1AuthOtpRequestPost200ResponseStatusEnum_sent;

  static Serializer<V1AuthOtpRequestPost200ResponseStatusEnum> get serializer =>
      _$v1AuthOtpRequestPost200ResponseStatusEnumSerializer;

  const V1AuthOtpRequestPost200ResponseStatusEnum._(String name) : super(name);

  static BuiltSet<V1AuthOtpRequestPost200ResponseStatusEnum> get values =>
      _$v1AuthOtpRequestPost200ResponseStatusEnumValues;
  static V1AuthOtpRequestPost200ResponseStatusEnum valueOf(String name) =>
      _$v1AuthOtpRequestPost200ResponseStatusEnumValueOf(name);
}

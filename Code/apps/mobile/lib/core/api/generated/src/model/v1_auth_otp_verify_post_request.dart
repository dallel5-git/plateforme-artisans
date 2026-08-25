//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_auth_otp_verify_post_request.g.dart';

/// V1AuthOtpVerifyPostRequest
///
/// Properties:
/// * [phone]
/// * [code]
@BuiltValue()
abstract class V1AuthOtpVerifyPostRequest
    implements
        Built<V1AuthOtpVerifyPostRequest, V1AuthOtpVerifyPostRequestBuilder> {
  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'code')
  String get code;

  V1AuthOtpVerifyPostRequest._();

  factory V1AuthOtpVerifyPostRequest(
          [void updates(V1AuthOtpVerifyPostRequestBuilder b)]) =
      _$V1AuthOtpVerifyPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1AuthOtpVerifyPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AuthOtpVerifyPostRequest> get serializer =>
      _$V1AuthOtpVerifyPostRequestSerializer();
}

class _$V1AuthOtpVerifyPostRequestSerializer
    implements PrimitiveSerializer<V1AuthOtpVerifyPostRequest> {
  @override
  final Iterable<Type> types = const [
    V1AuthOtpVerifyPostRequest,
    _$V1AuthOtpVerifyPostRequest
  ];

  @override
  final String wireName = r'V1AuthOtpVerifyPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AuthOtpVerifyPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AuthOtpVerifyPostRequest object, {
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
    required V1AuthOtpVerifyPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1AuthOtpVerifyPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1AuthOtpVerifyPostRequestBuilder();
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

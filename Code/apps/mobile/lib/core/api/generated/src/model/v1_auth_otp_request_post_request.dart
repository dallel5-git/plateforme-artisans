//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_auth_otp_request_post_request.g.dart';

/// V1AuthOtpRequestPostRequest
///
/// Properties:
/// * [phone]
@BuiltValue()
abstract class V1AuthOtpRequestPostRequest
    implements
        Built<V1AuthOtpRequestPostRequest, V1AuthOtpRequestPostRequestBuilder> {
  @BuiltValueField(wireName: r'phone')
  String get phone;

  V1AuthOtpRequestPostRequest._();

  factory V1AuthOtpRequestPostRequest([
    void updates(V1AuthOtpRequestPostRequestBuilder b),
  ]) = _$V1AuthOtpRequestPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1AuthOtpRequestPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AuthOtpRequestPostRequest> get serializer =>
      _$V1AuthOtpRequestPostRequestSerializer();
}

class _$V1AuthOtpRequestPostRequestSerializer
    implements PrimitiveSerializer<V1AuthOtpRequestPostRequest> {
  @override
  final Iterable<Type> types = const [
    V1AuthOtpRequestPostRequest,
    _$V1AuthOtpRequestPostRequest,
  ];

  @override
  final String wireName = r'V1AuthOtpRequestPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AuthOtpRequestPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AuthOtpRequestPostRequest object, {
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
    required V1AuthOtpRequestPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.phone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1AuthOtpRequestPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1AuthOtpRequestPostRequestBuilder();
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

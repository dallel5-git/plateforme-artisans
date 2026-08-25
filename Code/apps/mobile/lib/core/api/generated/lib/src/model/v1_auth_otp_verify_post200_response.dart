//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sanaya_api_client/src/model/v1_auth_otp_verify_post200_response_user.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_auth_otp_verify_post200_response.g.dart';

/// V1AuthOtpVerifyPost200Response
///
/// Properties:
/// * [accessToken]
/// * [refreshToken]
/// * [user]
@BuiltValue()
abstract class V1AuthOtpVerifyPost200Response
    implements
        Built<V1AuthOtpVerifyPost200Response,
            V1AuthOtpVerifyPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'accessToken')
  String get accessToken;

  @BuiltValueField(wireName: r'refreshToken')
  String get refreshToken;

  @BuiltValueField(wireName: r'user')
  V1AuthOtpVerifyPost200ResponseUser get user;

  V1AuthOtpVerifyPost200Response._();

  factory V1AuthOtpVerifyPost200Response(
          [void updates(V1AuthOtpVerifyPost200ResponseBuilder b)]) =
      _$V1AuthOtpVerifyPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1AuthOtpVerifyPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AuthOtpVerifyPost200Response> get serializer =>
      _$V1AuthOtpVerifyPost200ResponseSerializer();
}

class _$V1AuthOtpVerifyPost200ResponseSerializer
    implements PrimitiveSerializer<V1AuthOtpVerifyPost200Response> {
  @override
  final Iterable<Type> types = const [
    V1AuthOtpVerifyPost200Response,
    _$V1AuthOtpVerifyPost200Response
  ];

  @override
  final String wireName = r'V1AuthOtpVerifyPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AuthOtpVerifyPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accessToken';
    yield serializers.serialize(
      object.accessToken,
      specifiedType: const FullType(String),
    );
    yield r'refreshToken';
    yield serializers.serialize(
      object.refreshToken,
      specifiedType: const FullType(String),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(V1AuthOtpVerifyPost200ResponseUser),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AuthOtpVerifyPost200Response object, {
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
    required V1AuthOtpVerifyPost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accessToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accessToken = valueDes;
          break;
        case r'refreshToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refreshToken = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(V1AuthOtpVerifyPost200ResponseUser),
          ) as V1AuthOtpVerifyPost200ResponseUser;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1AuthOtpVerifyPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1AuthOtpVerifyPost200ResponseBuilder();
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

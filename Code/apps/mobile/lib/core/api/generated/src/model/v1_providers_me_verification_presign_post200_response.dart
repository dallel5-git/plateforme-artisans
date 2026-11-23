//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_verification_presign_post200_response.g.dart';

/// V1ProvidersMeVerificationPresignPost200Response
///
/// Properties:
/// * [mediaId]
/// * [uploadUrl]
/// * [expiresAt]
@BuiltValue()
abstract class V1ProvidersMeVerificationPresignPost200Response
    implements
        Built<V1ProvidersMeVerificationPresignPost200Response,
            V1ProvidersMeVerificationPresignPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'mediaId')
  String get mediaId;

  @BuiltValueField(wireName: r'uploadUrl')
  String get uploadUrl;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  V1ProvidersMeVerificationPresignPost200Response._();

  factory V1ProvidersMeVerificationPresignPost200Response(
          [void updates(
              V1ProvidersMeVerificationPresignPost200ResponseBuilder b)]) =
      _$V1ProvidersMeVerificationPresignPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1ProvidersMeVerificationPresignPost200ResponseBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeVerificationPresignPost200Response>
      get serializer =>
          _$V1ProvidersMeVerificationPresignPost200ResponseSerializer();
}

class _$V1ProvidersMeVerificationPresignPost200ResponseSerializer
    implements
        PrimitiveSerializer<V1ProvidersMeVerificationPresignPost200Response> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeVerificationPresignPost200Response,
    _$V1ProvidersMeVerificationPresignPost200Response
  ];

  @override
  final String wireName = r'V1ProvidersMeVerificationPresignPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeVerificationPresignPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'mediaId';
    yield serializers.serialize(
      object.mediaId,
      specifiedType: const FullType(String),
    );
    yield r'uploadUrl';
    yield serializers.serialize(
      object.uploadUrl,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeVerificationPresignPost200Response object, {
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
    required V1ProvidersMeVerificationPresignPost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'mediaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mediaId = valueDes;
          break;
        case r'uploadUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uploadUrl = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMeVerificationPresignPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeVerificationPresignPost200ResponseBuilder();
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

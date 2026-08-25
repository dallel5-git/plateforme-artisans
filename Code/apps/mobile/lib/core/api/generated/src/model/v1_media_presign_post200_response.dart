//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_media_presign_post200_response.g.dart';

/// V1MediaPresignPost200Response
///
/// Properties:
/// * [mediaId]
/// * [uploadUrl]
/// * [expiresAt]
@BuiltValue()
abstract class V1MediaPresignPost200Response
    implements
        Built<
          V1MediaPresignPost200Response,
          V1MediaPresignPost200ResponseBuilder
        > {
  @BuiltValueField(wireName: r'mediaId')
  String get mediaId;

  @BuiltValueField(wireName: r'uploadUrl')
  String get uploadUrl;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  V1MediaPresignPost200Response._();

  factory V1MediaPresignPost200Response([
    void updates(V1MediaPresignPost200ResponseBuilder b),
  ]) = _$V1MediaPresignPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1MediaPresignPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1MediaPresignPost200Response> get serializer =>
      _$V1MediaPresignPost200ResponseSerializer();
}

class _$V1MediaPresignPost200ResponseSerializer
    implements PrimitiveSerializer<V1MediaPresignPost200Response> {
  @override
  final Iterable<Type> types = const [
    V1MediaPresignPost200Response,
    _$V1MediaPresignPost200Response,
  ];

  @override
  final String wireName = r'V1MediaPresignPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1MediaPresignPost200Response object, {
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
    V1MediaPresignPost200Response object, {
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
    required V1MediaPresignPost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'mediaId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.mediaId = valueDes;
          break;
        case r'uploadUrl':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.uploadUrl = valueDes;
          break;
        case r'expiresAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
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
  V1MediaPresignPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1MediaPresignPost200ResponseBuilder();
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

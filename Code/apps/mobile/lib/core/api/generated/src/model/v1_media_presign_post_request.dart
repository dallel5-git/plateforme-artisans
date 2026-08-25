//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_media_presign_post_request.g.dart';

/// V1MediaPresignPostRequest
///
/// Properties:
/// * [filename]
/// * [mimeType]
/// * [sizeBytes]
@BuiltValue()
abstract class V1MediaPresignPostRequest
    implements
        Built<V1MediaPresignPostRequest, V1MediaPresignPostRequestBuilder> {
  @BuiltValueField(wireName: r'filename')
  String get filename;

  @BuiltValueField(wireName: r'mimeType')
  String get mimeType;

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  V1MediaPresignPostRequest._();

  factory V1MediaPresignPostRequest([
    void updates(V1MediaPresignPostRequestBuilder b),
  ]) = _$V1MediaPresignPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1MediaPresignPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1MediaPresignPostRequest> get serializer =>
      _$V1MediaPresignPostRequestSerializer();
}

class _$V1MediaPresignPostRequestSerializer
    implements PrimitiveSerializer<V1MediaPresignPostRequest> {
  @override
  final Iterable<Type> types = const [
    V1MediaPresignPostRequest,
    _$V1MediaPresignPostRequest,
  ];

  @override
  final String wireName = r'V1MediaPresignPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1MediaPresignPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'filename';
    yield serializers.serialize(
      object.filename,
      specifiedType: const FullType(String),
    );
    yield r'mimeType';
    yield serializers.serialize(
      object.mimeType,
      specifiedType: const FullType(String),
    );
    yield r'sizeBytes';
    yield serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1MediaPresignPostRequest object, {
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
    required V1MediaPresignPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'filename':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.filename = valueDes;
          break;
        case r'mimeType':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.mimeType = valueDes;
          break;
        case r'sizeBytes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )
                  as int;
          result.sizeBytes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1MediaPresignPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1MediaPresignPostRequestBuilder();
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

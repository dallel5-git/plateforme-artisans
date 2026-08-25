//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_media_id_process_post200_response.g.dart';

/// V1MediaIdProcessPost200Response
///
/// Properties:
/// * [id]
/// * [publicUrl]
/// * [thumbUrl]
/// * [cardUrl]
/// * [fullUrl]
/// * [width]
/// * [height]
@BuiltValue()
abstract class V1MediaIdProcessPost200Response
    implements
        Built<V1MediaIdProcessPost200Response,
            V1MediaIdProcessPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'publicUrl')
  String get publicUrl;

  @BuiltValueField(wireName: r'thumbUrl')
  String get thumbUrl;

  @BuiltValueField(wireName: r'cardUrl')
  String get cardUrl;

  @BuiltValueField(wireName: r'fullUrl')
  String get fullUrl;

  @BuiltValueField(wireName: r'width')
  int get width;

  @BuiltValueField(wireName: r'height')
  int get height;

  V1MediaIdProcessPost200Response._();

  factory V1MediaIdProcessPost200Response(
          [void updates(V1MediaIdProcessPost200ResponseBuilder b)]) =
      _$V1MediaIdProcessPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1MediaIdProcessPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1MediaIdProcessPost200Response> get serializer =>
      _$V1MediaIdProcessPost200ResponseSerializer();
}

class _$V1MediaIdProcessPost200ResponseSerializer
    implements PrimitiveSerializer<V1MediaIdProcessPost200Response> {
  @override
  final Iterable<Type> types = const [
    V1MediaIdProcessPost200Response,
    _$V1MediaIdProcessPost200Response
  ];

  @override
  final String wireName = r'V1MediaIdProcessPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1MediaIdProcessPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'publicUrl';
    yield serializers.serialize(
      object.publicUrl,
      specifiedType: const FullType(String),
    );
    yield r'thumbUrl';
    yield serializers.serialize(
      object.thumbUrl,
      specifiedType: const FullType(String),
    );
    yield r'cardUrl';
    yield serializers.serialize(
      object.cardUrl,
      specifiedType: const FullType(String),
    );
    yield r'fullUrl';
    yield serializers.serialize(
      object.fullUrl,
      specifiedType: const FullType(String),
    );
    yield r'width';
    yield serializers.serialize(
      object.width,
      specifiedType: const FullType(int),
    );
    yield r'height';
    yield serializers.serialize(
      object.height,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1MediaIdProcessPost200Response object, {
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
    required V1MediaIdProcessPost200ResponseBuilder result,
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
        case r'publicUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.publicUrl = valueDes;
          break;
        case r'thumbUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.thumbUrl = valueDes;
          break;
        case r'cardUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cardUrl = valueDes;
          break;
        case r'fullUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullUrl = valueDes;
          break;
        case r'width':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.width = valueDes;
          break;
        case r'height':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.height = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1MediaIdProcessPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1MediaIdProcessPost200ResponseBuilder();
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

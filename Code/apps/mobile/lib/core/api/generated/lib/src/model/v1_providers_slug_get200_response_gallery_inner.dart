//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sanaya_api_client/src/model/v1_providers_slug_get200_response_coverage_areas_inner_delegation.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_slug_get200_response_gallery_inner.g.dart';

/// V1ProvidersSlugGet200ResponseGalleryInner
///
/// Properties:
/// * [id]
/// * [url]
/// * [width]
/// * [height]
/// * [blurhash]
/// * [caption]
/// * [category]
@BuiltValue()
abstract class V1ProvidersSlugGet200ResponseGalleryInner
    implements
        Built<V1ProvidersSlugGet200ResponseGalleryInner,
            V1ProvidersSlugGet200ResponseGalleryInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'width')
  int get width;

  @BuiltValueField(wireName: r'height')
  int get height;

  @BuiltValueField(wireName: r'blurhash')
  String get blurhash;

  @BuiltValueField(wireName: r'caption')
  String get caption;

  @BuiltValueField(wireName: r'category')
  V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation get category;

  V1ProvidersSlugGet200ResponseGalleryInner._();

  factory V1ProvidersSlugGet200ResponseGalleryInner(
          [void updates(V1ProvidersSlugGet200ResponseGalleryInnerBuilder b)]) =
      _$V1ProvidersSlugGet200ResponseGalleryInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersSlugGet200ResponseGalleryInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersSlugGet200ResponseGalleryInner> get serializer =>
      _$V1ProvidersSlugGet200ResponseGalleryInnerSerializer();
}

class _$V1ProvidersSlugGet200ResponseGalleryInnerSerializer
    implements PrimitiveSerializer<V1ProvidersSlugGet200ResponseGalleryInner> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersSlugGet200ResponseGalleryInner,
    _$V1ProvidersSlugGet200ResponseGalleryInner
  ];

  @override
  final String wireName = r'V1ProvidersSlugGet200ResponseGalleryInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersSlugGet200ResponseGalleryInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
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
    yield r'blurhash';
    yield serializers.serialize(
      object.blurhash,
      specifiedType: const FullType(String),
    );
    yield r'caption';
    yield serializers.serialize(
      object.caption,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(
          V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersSlugGet200ResponseGalleryInner object, {
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
    required V1ProvidersSlugGet200ResponseGalleryInnerBuilder result,
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
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
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
        case r'blurhash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.blurhash = valueDes;
          break;
        case r'caption':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.caption = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation),
          ) as V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation;
          result.category.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersSlugGet200ResponseGalleryInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersSlugGet200ResponseGalleryInnerBuilder();
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

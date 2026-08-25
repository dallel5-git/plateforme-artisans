//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_search_get200_response_items_inner_categories_inner.g.dart';

/// V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner
///
/// Properties:
/// * [slug]
/// * [nameFr]
/// * [nameAr]
/// * [isPrimary]
@BuiltValue()
abstract class V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner
    implements
        Built<V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner,
            V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerBuilder> {
  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'nameFr')
  String get nameFr;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'isPrimary')
  bool get isPrimary;

  V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner._();

  factory V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner(
      [void updates(
          V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerBuilder
              b)]) = _$V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner>
      get serializer =>
          _$V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerSerializer();
}

class _$V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner,
    _$V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner
  ];

  @override
  final String wireName =
      r'V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
    yield r'nameFr';
    yield serializers.serialize(
      object.nameFr,
      specifiedType: const FullType(String),
    );
    yield r'nameAr';
    yield serializers.serialize(
      object.nameAr,
      specifiedType: const FullType(String),
    );
    yield r'isPrimary';
    yield serializers.serialize(
      object.isPrimary,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner object, {
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
    required V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerBuilder
        result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        case r'nameFr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nameFr = valueDes;
          break;
        case r'nameAr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nameAr = valueDes;
          break;
        case r'isPrimary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isPrimary = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerBuilder();
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

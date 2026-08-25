//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/category_tree_node.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_categories_get200_response.g.dart';

/// V1CategoriesGet200Response
///
/// Properties:
/// * [categories]
@BuiltValue()
abstract class V1CategoriesGet200Response
    implements
        Built<V1CategoriesGet200Response, V1CategoriesGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'categories')
  BuiltList<CategoryTreeNode> get categories;

  V1CategoriesGet200Response._();

  factory V1CategoriesGet200Response([
    void updates(V1CategoriesGet200ResponseBuilder b),
  ]) = _$V1CategoriesGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1CategoriesGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1CategoriesGet200Response> get serializer =>
      _$V1CategoriesGet200ResponseSerializer();
}

class _$V1CategoriesGet200ResponseSerializer
    implements PrimitiveSerializer<V1CategoriesGet200Response> {
  @override
  final Iterable<Type> types = const [
    V1CategoriesGet200Response,
    _$V1CategoriesGet200Response,
  ];

  @override
  final String wireName = r'V1CategoriesGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1CategoriesGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [FullType(CategoryTreeNode)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1CategoriesGet200Response object, {
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
    required V1CategoriesGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categories':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CategoryTreeNode),
                    ]),
                  )
                  as BuiltList<CategoryTreeNode>;
          result.categories.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1CategoriesGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1CategoriesGet200ResponseBuilder();
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

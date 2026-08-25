//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'category_tree_node.g.dart';

/// CategoryTreeNode
///
/// Properties:
/// * [id]
/// * [slug]
/// * [nameFr]
/// * [nameAr]
/// * [descriptionFr]
/// * [descriptionAr]
/// * [iconKey]
/// * [colorHex]
/// * [sortOrder]
/// * [children]
@BuiltValue()
abstract class CategoryTreeNode
    implements Built<CategoryTreeNode, CategoryTreeNodeBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'nameFr')
  String get nameFr;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'descriptionFr')
  String get descriptionFr;

  @BuiltValueField(wireName: r'descriptionAr')
  String get descriptionAr;

  @BuiltValueField(wireName: r'iconKey')
  String get iconKey;

  @BuiltValueField(wireName: r'colorHex')
  String get colorHex;

  @BuiltValueField(wireName: r'sortOrder')
  int get sortOrder;

  @BuiltValueField(wireName: r'children')
  BuiltList<CategoryTreeNode> get children;

  CategoryTreeNode._();

  factory CategoryTreeNode([void updates(CategoryTreeNodeBuilder b)]) =
      _$CategoryTreeNode;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CategoryTreeNodeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CategoryTreeNode> get serializer =>
      _$CategoryTreeNodeSerializer();
}

class _$CategoryTreeNodeSerializer
    implements PrimitiveSerializer<CategoryTreeNode> {
  @override
  final Iterable<Type> types = const [CategoryTreeNode, _$CategoryTreeNode];

  @override
  final String wireName = r'CategoryTreeNode';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CategoryTreeNode object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    yield r'descriptionFr';
    yield serializers.serialize(
      object.descriptionFr,
      specifiedType: const FullType(String),
    );
    yield r'descriptionAr';
    yield serializers.serialize(
      object.descriptionAr,
      specifiedType: const FullType(String),
    );
    yield r'iconKey';
    yield serializers.serialize(
      object.iconKey,
      specifiedType: const FullType(String),
    );
    yield r'colorHex';
    yield serializers.serialize(
      object.colorHex,
      specifiedType: const FullType(String),
    );
    yield r'sortOrder';
    yield serializers.serialize(
      object.sortOrder,
      specifiedType: const FullType(int),
    );
    yield r'children';
    yield serializers.serialize(
      object.children,
      specifiedType: const FullType(BuiltList, [FullType(CategoryTreeNode)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CategoryTreeNode object, {
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
    required CategoryTreeNodeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'slug':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.slug = valueDes;
          break;
        case r'nameFr':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.nameFr = valueDes;
          break;
        case r'nameAr':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.nameAr = valueDes;
          break;
        case r'descriptionFr':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.descriptionFr = valueDes;
          break;
        case r'descriptionAr':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.descriptionAr = valueDes;
          break;
        case r'iconKey':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.iconKey = valueDes;
          break;
        case r'colorHex':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.colorHex = valueDes;
          break;
        case r'sortOrder':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )
                  as int;
          result.sortOrder = valueDes;
          break;
        case r'children':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CategoryTreeNode),
                    ]),
                  )
                  as BuiltList<CategoryTreeNode>;
          result.children.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CategoryTreeNode deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CategoryTreeNodeBuilder();
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

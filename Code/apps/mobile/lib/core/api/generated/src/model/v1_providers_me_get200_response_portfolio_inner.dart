//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_get200_response_portfolio_inner.g.dart';

/// V1ProvidersMeGet200ResponsePortfolioInner
///
/// Properties:
/// * [id]
/// * [mediaId]
/// * [categoryId]
/// * [caption]
/// * [sortOrder]
@BuiltValue()
abstract class V1ProvidersMeGet200ResponsePortfolioInner
    implements
        Built<V1ProvidersMeGet200ResponsePortfolioInner,
            V1ProvidersMeGet200ResponsePortfolioInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'mediaId')
  String get mediaId;

  @BuiltValueField(wireName: r'categoryId')
  String get categoryId;

  @BuiltValueField(wireName: r'caption')
  String get caption;

  @BuiltValueField(wireName: r'sortOrder')
  int get sortOrder;

  V1ProvidersMeGet200ResponsePortfolioInner._();

  factory V1ProvidersMeGet200ResponsePortfolioInner(
          [void updates(V1ProvidersMeGet200ResponsePortfolioInnerBuilder b)]) =
      _$V1ProvidersMeGet200ResponsePortfolioInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMeGet200ResponsePortfolioInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeGet200ResponsePortfolioInner> get serializer =>
      _$V1ProvidersMeGet200ResponsePortfolioInnerSerializer();
}

class _$V1ProvidersMeGet200ResponsePortfolioInnerSerializer
    implements PrimitiveSerializer<V1ProvidersMeGet200ResponsePortfolioInner> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeGet200ResponsePortfolioInner,
    _$V1ProvidersMeGet200ResponsePortfolioInner
  ];

  @override
  final String wireName = r'V1ProvidersMeGet200ResponsePortfolioInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeGet200ResponsePortfolioInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'mediaId';
    yield serializers.serialize(
      object.mediaId,
      specifiedType: const FullType(String),
    );
    yield r'categoryId';
    yield serializers.serialize(
      object.categoryId,
      specifiedType: const FullType(String),
    );
    yield r'caption';
    yield serializers.serialize(
      object.caption,
      specifiedType: const FullType(String),
    );
    yield r'sortOrder';
    yield serializers.serialize(
      object.sortOrder,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeGet200ResponsePortfolioInner object, {
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
    required V1ProvidersMeGet200ResponsePortfolioInnerBuilder result,
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
        case r'mediaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mediaId = valueDes;
          break;
        case r'categoryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoryId = valueDes;
          break;
        case r'caption':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.caption = valueDes;
          break;
        case r'sortOrder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sortOrder = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMeGet200ResponsePortfolioInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeGet200ResponsePortfolioInnerBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_post200_response_provider_portfolio_inner.g.dart';

/// V1ProvidersMePost200ResponseProviderPortfolioInner
///
/// Properties:
/// * [id]
/// * [mediaId]
/// * [categoryId]
/// * [caption]
/// * [sortOrder]
@BuiltValue()
abstract class V1ProvidersMePost200ResponseProviderPortfolioInner
    implements
        Built<V1ProvidersMePost200ResponseProviderPortfolioInner,
            V1ProvidersMePost200ResponseProviderPortfolioInnerBuilder> {
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

  V1ProvidersMePost200ResponseProviderPortfolioInner._();

  factory V1ProvidersMePost200ResponseProviderPortfolioInner(
          [void updates(
              V1ProvidersMePost200ResponseProviderPortfolioInnerBuilder b)]) =
      _$V1ProvidersMePost200ResponseProviderPortfolioInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1ProvidersMePost200ResponseProviderPortfolioInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMePost200ResponseProviderPortfolioInner>
      get serializer =>
          _$V1ProvidersMePost200ResponseProviderPortfolioInnerSerializer();
}

class _$V1ProvidersMePost200ResponseProviderPortfolioInnerSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersMePost200ResponseProviderPortfolioInner> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMePost200ResponseProviderPortfolioInner,
    _$V1ProvidersMePost200ResponseProviderPortfolioInner
  ];

  @override
  final String wireName = r'V1ProvidersMePost200ResponseProviderPortfolioInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMePost200ResponseProviderPortfolioInner object, {
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
    V1ProvidersMePost200ResponseProviderPortfolioInner object, {
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
    required V1ProvidersMePost200ResponseProviderPortfolioInnerBuilder result,
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
  V1ProvidersMePost200ResponseProviderPortfolioInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMePost200ResponseProviderPortfolioInnerBuilder();
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

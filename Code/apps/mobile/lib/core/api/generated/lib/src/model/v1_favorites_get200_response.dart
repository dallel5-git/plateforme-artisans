//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sanaya_api_client/src/model/v1_favorites_get200_response_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_favorites_get200_response.g.dart';

/// V1FavoritesGet200Response
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class V1FavoritesGet200Response
    implements
        Built<V1FavoritesGet200Response, V1FavoritesGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<V1FavoritesGet200ResponseItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String get nextCursor;

  V1FavoritesGet200Response._();

  factory V1FavoritesGet200Response(
          [void updates(V1FavoritesGet200ResponseBuilder b)]) =
      _$V1FavoritesGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1FavoritesGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1FavoritesGet200Response> get serializer =>
      _$V1FavoritesGet200ResponseSerializer();
}

class _$V1FavoritesGet200ResponseSerializer
    implements PrimitiveSerializer<V1FavoritesGet200Response> {
  @override
  final Iterable<Type> types = const [
    V1FavoritesGet200Response,
    _$V1FavoritesGet200Response
  ];

  @override
  final String wireName = r'V1FavoritesGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1FavoritesGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(
          BuiltList, [FullType(V1FavoritesGet200ResponseItemsInner)]),
    );
    yield r'nextCursor';
    yield serializers.serialize(
      object.nextCursor,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1FavoritesGet200Response object, {
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
    required V1FavoritesGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(V1FavoritesGet200ResponseItemsInner)]),
          ) as BuiltList<V1FavoritesGet200ResponseItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'nextCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nextCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1FavoritesGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1FavoritesGet200ResponseBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_favorites_provider_id_put200_response.g.dart';

/// V1FavoritesProviderIdPut200Response
///
/// Properties:
/// * [providerId]
/// * [createdAt]
@BuiltValue()
abstract class V1FavoritesProviderIdPut200Response
    implements
        Built<V1FavoritesProviderIdPut200Response,
            V1FavoritesProviderIdPut200ResponseBuilder> {
  @BuiltValueField(wireName: r'providerId')
  String get providerId;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  V1FavoritesProviderIdPut200Response._();

  factory V1FavoritesProviderIdPut200Response(
          [void updates(V1FavoritesProviderIdPut200ResponseBuilder b)]) =
      _$V1FavoritesProviderIdPut200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1FavoritesProviderIdPut200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1FavoritesProviderIdPut200Response> get serializer =>
      _$V1FavoritesProviderIdPut200ResponseSerializer();
}

class _$V1FavoritesProviderIdPut200ResponseSerializer
    implements PrimitiveSerializer<V1FavoritesProviderIdPut200Response> {
  @override
  final Iterable<Type> types = const [
    V1FavoritesProviderIdPut200Response,
    _$V1FavoritesProviderIdPut200Response
  ];

  @override
  final String wireName = r'V1FavoritesProviderIdPut200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1FavoritesProviderIdPut200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'providerId';
    yield serializers.serialize(
      object.providerId,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1FavoritesProviderIdPut200Response object, {
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
    required V1FavoritesProviderIdPut200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'providerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerId = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1FavoritesProviderIdPut200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1FavoritesProviderIdPut200ResponseBuilder();
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

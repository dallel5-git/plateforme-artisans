//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_categories_put_request_categories_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_categories_put_request.g.dart';

/// V1ProvidersMeCategoriesPutRequest
///
/// Properties:
/// * [categories]
@BuiltValue()
abstract class V1ProvidersMeCategoriesPutRequest
    implements
        Built<V1ProvidersMeCategoriesPutRequest,
            V1ProvidersMeCategoriesPutRequestBuilder> {
  @BuiltValueField(wireName: r'categories')
  BuiltList<V1ProvidersMeCategoriesPutRequestCategoriesInner> get categories;

  V1ProvidersMeCategoriesPutRequest._();

  factory V1ProvidersMeCategoriesPutRequest(
          [void updates(V1ProvidersMeCategoriesPutRequestBuilder b)]) =
      _$V1ProvidersMeCategoriesPutRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMeCategoriesPutRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeCategoriesPutRequest> get serializer =>
      _$V1ProvidersMeCategoriesPutRequestSerializer();
}

class _$V1ProvidersMeCategoriesPutRequestSerializer
    implements PrimitiveSerializer<V1ProvidersMeCategoriesPutRequest> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeCategoriesPutRequest,
    _$V1ProvidersMeCategoriesPutRequest
  ];

  @override
  final String wireName = r'V1ProvidersMeCategoriesPutRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeCategoriesPutRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList,
          [FullType(V1ProvidersMeCategoriesPutRequestCategoriesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeCategoriesPutRequest object, {
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
    required V1ProvidersMeCategoriesPutRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(V1ProvidersMeCategoriesPutRequestCategoriesInner)]),
          ) as BuiltList<V1ProvidersMeCategoriesPutRequestCategoriesInner>;
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
  V1ProvidersMeCategoriesPutRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeCategoriesPutRequestBuilder();
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

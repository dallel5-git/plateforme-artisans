//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_post200_response_provider_categories_inner.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_categories_put200_response.g.dart';

/// V1ProvidersMeCategoriesPut200Response
///
/// Properties:
/// * [categories]
/// * [completionScore]
@BuiltValue()
abstract class V1ProvidersMeCategoriesPut200Response
    implements
        Built<V1ProvidersMeCategoriesPut200Response,
            V1ProvidersMeCategoriesPut200ResponseBuilder> {
  @BuiltValueField(wireName: r'categories')
  BuiltList<V1ProvidersMePost200ResponseProviderCategoriesInner> get categories;

  @BuiltValueField(wireName: r'completionScore')
  int get completionScore;

  V1ProvidersMeCategoriesPut200Response._();

  factory V1ProvidersMeCategoriesPut200Response(
          [void updates(V1ProvidersMeCategoriesPut200ResponseBuilder b)]) =
      _$V1ProvidersMeCategoriesPut200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMeCategoriesPut200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeCategoriesPut200Response> get serializer =>
      _$V1ProvidersMeCategoriesPut200ResponseSerializer();
}

class _$V1ProvidersMeCategoriesPut200ResponseSerializer
    implements PrimitiveSerializer<V1ProvidersMeCategoriesPut200Response> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeCategoriesPut200Response,
    _$V1ProvidersMeCategoriesPut200Response
  ];

  @override
  final String wireName = r'V1ProvidersMeCategoriesPut200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeCategoriesPut200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList,
          [FullType(V1ProvidersMePost200ResponseProviderCategoriesInner)]),
    );
    yield r'completionScore';
    yield serializers.serialize(
      object.completionScore,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeCategoriesPut200Response object, {
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
    required V1ProvidersMeCategoriesPut200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType(V1ProvidersMePost200ResponseProviderCategoriesInner)
            ]),
          ) as BuiltList<V1ProvidersMePost200ResponseProviderCategoriesInner>;
          result.categories.replace(valueDes);
          break;
        case r'completionScore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.completionScore = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMeCategoriesPut200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeCategoriesPut200ResponseBuilder();
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

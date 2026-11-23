//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_get200_response_categories_inner.g.dart';

/// V1ProvidersMeGet200ResponseCategoriesInner
///
/// Properties:
/// * [categoryId]
/// * [isPrimary]
/// * [yearsExperience]
@BuiltValue()
abstract class V1ProvidersMeGet200ResponseCategoriesInner
    implements
        Built<V1ProvidersMeGet200ResponseCategoriesInner,
            V1ProvidersMeGet200ResponseCategoriesInnerBuilder> {
  @BuiltValueField(wireName: r'categoryId')
  String get categoryId;

  @BuiltValueField(wireName: r'isPrimary')
  bool get isPrimary;

  @BuiltValueField(wireName: r'yearsExperience')
  int get yearsExperience;

  V1ProvidersMeGet200ResponseCategoriesInner._();

  factory V1ProvidersMeGet200ResponseCategoriesInner(
          [void updates(V1ProvidersMeGet200ResponseCategoriesInnerBuilder b)]) =
      _$V1ProvidersMeGet200ResponseCategoriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMeGet200ResponseCategoriesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeGet200ResponseCategoriesInner>
      get serializer =>
          _$V1ProvidersMeGet200ResponseCategoriesInnerSerializer();
}

class _$V1ProvidersMeGet200ResponseCategoriesInnerSerializer
    implements PrimitiveSerializer<V1ProvidersMeGet200ResponseCategoriesInner> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeGet200ResponseCategoriesInner,
    _$V1ProvidersMeGet200ResponseCategoriesInner
  ];

  @override
  final String wireName = r'V1ProvidersMeGet200ResponseCategoriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeGet200ResponseCategoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categoryId';
    yield serializers.serialize(
      object.categoryId,
      specifiedType: const FullType(String),
    );
    yield r'isPrimary';
    yield serializers.serialize(
      object.isPrimary,
      specifiedType: const FullType(bool),
    );
    yield r'yearsExperience';
    yield serializers.serialize(
      object.yearsExperience,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeGet200ResponseCategoriesInner object, {
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
    required V1ProvidersMeGet200ResponseCategoriesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categoryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoryId = valueDes;
          break;
        case r'isPrimary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isPrimary = valueDes;
          break;
        case r'yearsExperience':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.yearsExperience = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMeGet200ResponseCategoriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeGet200ResponseCategoriesInnerBuilder();
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

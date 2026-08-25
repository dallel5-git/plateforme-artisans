//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_slug_get200_response_categories_inner.g.dart';

/// V1ProvidersSlugGet200ResponseCategoriesInner
///
/// Properties:
/// * [slug]
/// * [nameFr]
/// * [nameAr]
/// * [isPrimary]
/// * [yearsExperience]
@BuiltValue()
abstract class V1ProvidersSlugGet200ResponseCategoriesInner
    implements
        Built<
          V1ProvidersSlugGet200ResponseCategoriesInner,
          V1ProvidersSlugGet200ResponseCategoriesInnerBuilder
        > {
  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'nameFr')
  String get nameFr;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'isPrimary')
  bool get isPrimary;

  @BuiltValueField(wireName: r'yearsExperience')
  int get yearsExperience;

  V1ProvidersSlugGet200ResponseCategoriesInner._();

  factory V1ProvidersSlugGet200ResponseCategoriesInner([
    void updates(V1ProvidersSlugGet200ResponseCategoriesInnerBuilder b),
  ]) = _$V1ProvidersSlugGet200ResponseCategoriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    V1ProvidersSlugGet200ResponseCategoriesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersSlugGet200ResponseCategoriesInner>
  get serializer => _$V1ProvidersSlugGet200ResponseCategoriesInnerSerializer();
}

class _$V1ProvidersSlugGet200ResponseCategoriesInnerSerializer
    implements
        PrimitiveSerializer<V1ProvidersSlugGet200ResponseCategoriesInner> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersSlugGet200ResponseCategoriesInner,
    _$V1ProvidersSlugGet200ResponseCategoriesInner,
  ];

  @override
  final String wireName = r'V1ProvidersSlugGet200ResponseCategoriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersSlugGet200ResponseCategoriesInner object, {
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
    yield r'yearsExperience';
    yield serializers.serialize(
      object.yearsExperience,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersSlugGet200ResponseCategoriesInner object, {
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
    required V1ProvidersSlugGet200ResponseCategoriesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'isPrimary':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.isPrimary = valueDes;
          break;
        case r'yearsExperience':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )
                  as int;
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
  V1ProvidersSlugGet200ResponseCategoriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersSlugGet200ResponseCategoriesInnerBuilder();
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

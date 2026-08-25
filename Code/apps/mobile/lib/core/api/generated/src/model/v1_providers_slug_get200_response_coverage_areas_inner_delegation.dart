//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_slug_get200_response_coverage_areas_inner_delegation.g.dart';

/// V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation
///
/// Properties:
/// * [slug]
/// * [nameFr]
/// * [nameAr]
@BuiltValue()
abstract class V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation
    implements
        Built<V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation,
            V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegationBuilder> {
  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'nameFr')
  String get nameFr;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation._();

  factory V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation(
          [void updates(
              V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegationBuilder
                  b)]) =
      _$V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegationBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation>
      get serializer =>
          _$V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegationSerializer();
}

class _$V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegationSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation,
    _$V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation
  ];

  @override
  final String wireName =
      r'V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation object, {
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
    required V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegationBuilder
        result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        case r'nameFr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nameFr = valueDes;
          break;
        case r'nameAr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nameAr = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegationBuilder();
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

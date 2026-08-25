//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_get200_response_coverage_areas_inner_delegation.dart';
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_get200_response_offerings_inner_category.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_slug_get200_response_coverage_areas_inner.g.dart';

/// V1ProvidersSlugGet200ResponseCoverageAreasInner
///
/// Properties:
/// * [governorate]
/// * [delegation]
/// * [travelFee]
@BuiltValue()
abstract class V1ProvidersSlugGet200ResponseCoverageAreasInner
    implements
        Built<
          V1ProvidersSlugGet200ResponseCoverageAreasInner,
          V1ProvidersSlugGet200ResponseCoverageAreasInnerBuilder
        > {
  @BuiltValueField(wireName: r'governorate')
  V1ProvidersSlugGet200ResponseOfferingsInnerCategory get governorate;

  @BuiltValueField(wireName: r'delegation')
  V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation get delegation;

  @BuiltValueField(wireName: r'travelFee')
  num get travelFee;

  V1ProvidersSlugGet200ResponseCoverageAreasInner._();

  factory V1ProvidersSlugGet200ResponseCoverageAreasInner([
    void updates(V1ProvidersSlugGet200ResponseCoverageAreasInnerBuilder b),
  ]) = _$V1ProvidersSlugGet200ResponseCoverageAreasInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    V1ProvidersSlugGet200ResponseCoverageAreasInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersSlugGet200ResponseCoverageAreasInner>
  get serializer =>
      _$V1ProvidersSlugGet200ResponseCoverageAreasInnerSerializer();
}

class _$V1ProvidersSlugGet200ResponseCoverageAreasInnerSerializer
    implements
        PrimitiveSerializer<V1ProvidersSlugGet200ResponseCoverageAreasInner> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersSlugGet200ResponseCoverageAreasInner,
    _$V1ProvidersSlugGet200ResponseCoverageAreasInner,
  ];

  @override
  final String wireName = r'V1ProvidersSlugGet200ResponseCoverageAreasInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersSlugGet200ResponseCoverageAreasInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'governorate';
    yield serializers.serialize(
      object.governorate,
      specifiedType: const FullType(
        V1ProvidersSlugGet200ResponseOfferingsInnerCategory,
      ),
    );
    yield r'delegation';
    yield serializers.serialize(
      object.delegation,
      specifiedType: const FullType(
        V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation,
      ),
    );
    yield r'travelFee';
    yield serializers.serialize(
      object.travelFee,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersSlugGet200ResponseCoverageAreasInner object, {
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
    required V1ProvidersSlugGet200ResponseCoverageAreasInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'governorate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      V1ProvidersSlugGet200ResponseOfferingsInnerCategory,
                    ),
                  )
                  as V1ProvidersSlugGet200ResponseOfferingsInnerCategory;
          result.governorate.replace(valueDes);
          break;
        case r'delegation':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation,
                    ),
                  )
                  as V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation;
          result.delegation.replace(valueDes);
          break;
        case r'travelFee':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(num),
                  )
                  as num;
          result.travelFee = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersSlugGet200ResponseCoverageAreasInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersSlugGet200ResponseCoverageAreasInnerBuilder();
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

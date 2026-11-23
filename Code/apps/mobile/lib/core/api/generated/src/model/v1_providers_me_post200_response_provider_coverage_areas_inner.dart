//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_post200_response_provider_coverage_areas_inner.g.dart';

/// V1ProvidersMePost200ResponseProviderCoverageAreasInner
///
/// Properties:
/// * [id]
/// * [governorateId]
/// * [delegationId]
/// * [travelFee]
@BuiltValue()
abstract class V1ProvidersMePost200ResponseProviderCoverageAreasInner
    implements
        Built<V1ProvidersMePost200ResponseProviderCoverageAreasInner,
            V1ProvidersMePost200ResponseProviderCoverageAreasInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'governorateId')
  String get governorateId;

  @BuiltValueField(wireName: r'delegationId')
  String get delegationId;

  @BuiltValueField(wireName: r'travelFee')
  num get travelFee;

  V1ProvidersMePost200ResponseProviderCoverageAreasInner._();

  factory V1ProvidersMePost200ResponseProviderCoverageAreasInner(
      [void updates(
          V1ProvidersMePost200ResponseProviderCoverageAreasInnerBuilder
              b)]) = _$V1ProvidersMePost200ResponseProviderCoverageAreasInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1ProvidersMePost200ResponseProviderCoverageAreasInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMePost200ResponseProviderCoverageAreasInner>
      get serializer =>
          _$V1ProvidersMePost200ResponseProviderCoverageAreasInnerSerializer();
}

class _$V1ProvidersMePost200ResponseProviderCoverageAreasInnerSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersMePost200ResponseProviderCoverageAreasInner> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMePost200ResponseProviderCoverageAreasInner,
    _$V1ProvidersMePost200ResponseProviderCoverageAreasInner
  ];

  @override
  final String wireName =
      r'V1ProvidersMePost200ResponseProviderCoverageAreasInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMePost200ResponseProviderCoverageAreasInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'governorateId';
    yield serializers.serialize(
      object.governorateId,
      specifiedType: const FullType(String),
    );
    yield r'delegationId';
    yield serializers.serialize(
      object.delegationId,
      specifiedType: const FullType(String),
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
    V1ProvidersMePost200ResponseProviderCoverageAreasInner object, {
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
    required V1ProvidersMePost200ResponseProviderCoverageAreasInnerBuilder
        result,
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
        case r'governorateId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.governorateId = valueDes;
          break;
        case r'delegationId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.delegationId = valueDes;
          break;
        case r'travelFee':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
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
  V1ProvidersMePost200ResponseProviderCoverageAreasInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1ProvidersMePost200ResponseProviderCoverageAreasInnerBuilder();
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

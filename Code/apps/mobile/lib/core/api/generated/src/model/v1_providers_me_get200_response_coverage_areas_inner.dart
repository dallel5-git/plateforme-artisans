//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_get200_response_coverage_areas_inner.g.dart';

/// V1ProvidersMeGet200ResponseCoverageAreasInner
///
/// Properties:
/// * [id]
/// * [governorateId]
/// * [delegationId]
/// * [travelFee]
@BuiltValue()
abstract class V1ProvidersMeGet200ResponseCoverageAreasInner
    implements
        Built<V1ProvidersMeGet200ResponseCoverageAreasInner,
            V1ProvidersMeGet200ResponseCoverageAreasInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'governorateId')
  String get governorateId;

  @BuiltValueField(wireName: r'delegationId')
  String get delegationId;

  @BuiltValueField(wireName: r'travelFee')
  num get travelFee;

  V1ProvidersMeGet200ResponseCoverageAreasInner._();

  factory V1ProvidersMeGet200ResponseCoverageAreasInner(
          [void updates(
              V1ProvidersMeGet200ResponseCoverageAreasInnerBuilder b)]) =
      _$V1ProvidersMeGet200ResponseCoverageAreasInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1ProvidersMeGet200ResponseCoverageAreasInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeGet200ResponseCoverageAreasInner>
      get serializer =>
          _$V1ProvidersMeGet200ResponseCoverageAreasInnerSerializer();
}

class _$V1ProvidersMeGet200ResponseCoverageAreasInnerSerializer
    implements
        PrimitiveSerializer<V1ProvidersMeGet200ResponseCoverageAreasInner> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeGet200ResponseCoverageAreasInner,
    _$V1ProvidersMeGet200ResponseCoverageAreasInner
  ];

  @override
  final String wireName = r'V1ProvidersMeGet200ResponseCoverageAreasInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeGet200ResponseCoverageAreasInner object, {
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
    V1ProvidersMeGet200ResponseCoverageAreasInner object, {
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
    required V1ProvidersMeGet200ResponseCoverageAreasInnerBuilder result,
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
  V1ProvidersMeGet200ResponseCoverageAreasInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeGet200ResponseCoverageAreasInnerBuilder();
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

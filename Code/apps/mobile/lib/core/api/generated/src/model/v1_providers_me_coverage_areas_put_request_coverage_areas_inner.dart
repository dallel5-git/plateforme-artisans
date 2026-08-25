//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_coverage_areas_put_request_coverage_areas_inner.g.dart';

/// V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner
///
/// Properties:
/// * [governorateId]
/// * [delegationId]
/// * [travelFee]
@BuiltValue()
abstract class V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner
    implements
        Built<
          V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner,
          V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerBuilder
        > {
  @BuiltValueField(wireName: r'governorateId')
  String get governorateId;

  @BuiltValueField(wireName: r'delegationId')
  String? get delegationId;

  @BuiltValueField(wireName: r'travelFee')
  int? get travelFee;

  V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner._();

  factory V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner([
    void updates(
      V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerBuilder b,
    ),
  ]) = _$V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner>
  get serializer =>
      _$V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerSerializer();
}

class _$V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerSerializer
    implements
        PrimitiveSerializer<
          V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner
        > {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner,
    _$V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner,
  ];

  @override
  final String wireName =
      r'V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'governorateId';
    yield serializers.serialize(
      object.governorateId,
      specifiedType: const FullType(String),
    );
    if (object.delegationId != null) {
      yield r'delegationId';
      yield serializers.serialize(
        object.delegationId,
        specifiedType: const FullType(String),
      );
    }
    if (object.travelFee != null) {
      yield r'travelFee';
      yield serializers.serialize(
        object.travelFee,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner object, {
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
    required V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'governorateId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.governorateId = valueDes;
          break;
        case r'delegationId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.delegationId = valueDes;
          break;
        case r'travelFee':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )
                  as int;
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
  V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerBuilder();
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

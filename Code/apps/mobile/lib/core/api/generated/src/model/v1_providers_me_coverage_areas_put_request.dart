//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_coverage_areas_put_request_coverage_areas_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_coverage_areas_put_request.g.dart';

/// V1ProvidersMeCoverageAreasPutRequest
///
/// Properties:
/// * [coverageAreas]
@BuiltValue()
abstract class V1ProvidersMeCoverageAreasPutRequest
    implements
        Built<V1ProvidersMeCoverageAreasPutRequest,
            V1ProvidersMeCoverageAreasPutRequestBuilder> {
  @BuiltValueField(wireName: r'coverageAreas')
  BuiltList<V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner>
      get coverageAreas;

  V1ProvidersMeCoverageAreasPutRequest._();

  factory V1ProvidersMeCoverageAreasPutRequest(
          [void updates(V1ProvidersMeCoverageAreasPutRequestBuilder b)]) =
      _$V1ProvidersMeCoverageAreasPutRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMeCoverageAreasPutRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeCoverageAreasPutRequest> get serializer =>
      _$V1ProvidersMeCoverageAreasPutRequestSerializer();
}

class _$V1ProvidersMeCoverageAreasPutRequestSerializer
    implements PrimitiveSerializer<V1ProvidersMeCoverageAreasPutRequest> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeCoverageAreasPutRequest,
    _$V1ProvidersMeCoverageAreasPutRequest
  ];

  @override
  final String wireName = r'V1ProvidersMeCoverageAreasPutRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeCoverageAreasPutRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'coverageAreas';
    yield serializers.serialize(
      object.coverageAreas,
      specifiedType: const FullType(BuiltList,
          [FullType(V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeCoverageAreasPutRequest object, {
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
    required V1ProvidersMeCoverageAreasPutRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'coverageAreas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType(V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner)
            ]),
          ) as BuiltList<
              V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner>;
          result.coverageAreas.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMeCoverageAreasPutRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeCoverageAreasPutRequestBuilder();
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

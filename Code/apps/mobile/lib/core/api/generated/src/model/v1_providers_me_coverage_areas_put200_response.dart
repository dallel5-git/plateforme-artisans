//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_coverage_areas_put200_response_coverage_areas_inner.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_coverage_areas_put200_response.g.dart';

/// V1ProvidersMeCoverageAreasPut200Response
///
/// Properties:
/// * [coverageAreas]
/// * [completionScore]
@BuiltValue()
abstract class V1ProvidersMeCoverageAreasPut200Response
    implements
        Built<V1ProvidersMeCoverageAreasPut200Response,
            V1ProvidersMeCoverageAreasPut200ResponseBuilder> {
  @BuiltValueField(wireName: r'coverageAreas')
  BuiltList<V1ProvidersMeCoverageAreasPut200ResponseCoverageAreasInner>
      get coverageAreas;

  @BuiltValueField(wireName: r'completionScore')
  int get completionScore;

  V1ProvidersMeCoverageAreasPut200Response._();

  factory V1ProvidersMeCoverageAreasPut200Response(
          [void updates(V1ProvidersMeCoverageAreasPut200ResponseBuilder b)]) =
      _$V1ProvidersMeCoverageAreasPut200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMeCoverageAreasPut200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeCoverageAreasPut200Response> get serializer =>
      _$V1ProvidersMeCoverageAreasPut200ResponseSerializer();
}

class _$V1ProvidersMeCoverageAreasPut200ResponseSerializer
    implements PrimitiveSerializer<V1ProvidersMeCoverageAreasPut200Response> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeCoverageAreasPut200Response,
    _$V1ProvidersMeCoverageAreasPut200Response
  ];

  @override
  final String wireName = r'V1ProvidersMeCoverageAreasPut200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeCoverageAreasPut200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'coverageAreas';
    yield serializers.serialize(
      object.coverageAreas,
      specifiedType: const FullType(BuiltList, [
        FullType(V1ProvidersMeCoverageAreasPut200ResponseCoverageAreasInner)
      ]),
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
    V1ProvidersMeCoverageAreasPut200Response object, {
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
    required V1ProvidersMeCoverageAreasPut200ResponseBuilder result,
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
              FullType(
                  V1ProvidersMeCoverageAreasPut200ResponseCoverageAreasInner)
            ]),
          ) as BuiltList<
              V1ProvidersMeCoverageAreasPut200ResponseCoverageAreasInner>;
          result.coverageAreas.replace(valueDes);
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
  V1ProvidersMeCoverageAreasPut200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeCoverageAreasPut200ResponseBuilder();
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

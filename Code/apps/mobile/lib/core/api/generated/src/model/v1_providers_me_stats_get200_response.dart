//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_stats_get200_response_series_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_stats_get200_response_totals.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_stats_get200_response.g.dart';

/// V1ProvidersMeStatsGet200Response
///
/// Properties:
/// * [totals]
/// * [series]
@BuiltValue()
abstract class V1ProvidersMeStatsGet200Response
    implements
        Built<V1ProvidersMeStatsGet200Response,
            V1ProvidersMeStatsGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'totals')
  V1ProvidersMeStatsGet200ResponseTotals get totals;

  @BuiltValueField(wireName: r'series')
  BuiltList<V1ProvidersMeStatsGet200ResponseSeriesInner> get series;

  V1ProvidersMeStatsGet200Response._();

  factory V1ProvidersMeStatsGet200Response(
          [void updates(V1ProvidersMeStatsGet200ResponseBuilder b)]) =
      _$V1ProvidersMeStatsGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMeStatsGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeStatsGet200Response> get serializer =>
      _$V1ProvidersMeStatsGet200ResponseSerializer();
}

class _$V1ProvidersMeStatsGet200ResponseSerializer
    implements PrimitiveSerializer<V1ProvidersMeStatsGet200Response> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeStatsGet200Response,
    _$V1ProvidersMeStatsGet200Response
  ];

  @override
  final String wireName = r'V1ProvidersMeStatsGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeStatsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'totals';
    yield serializers.serialize(
      object.totals,
      specifiedType: const FullType(V1ProvidersMeStatsGet200ResponseTotals),
    );
    yield r'series';
    yield serializers.serialize(
      object.series,
      specifiedType: const FullType(
          BuiltList, [FullType(V1ProvidersMeStatsGet200ResponseSeriesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeStatsGet200Response object, {
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
    required V1ProvidersMeStatsGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'totals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(V1ProvidersMeStatsGet200ResponseTotals),
          ) as V1ProvidersMeStatsGet200ResponseTotals;
          result.totals = valueDes.toBuilder();
          break;
        case r'series':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(V1ProvidersMeStatsGet200ResponseSeriesInner)]),
          ) as BuiltList<V1ProvidersMeStatsGet200ResponseSeriesInner>;
          result.series.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMeStatsGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeStatsGet200ResponseBuilder();
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

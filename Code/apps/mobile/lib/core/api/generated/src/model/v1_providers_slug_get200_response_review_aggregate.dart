//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_get200_response_review_aggregate_breakdown.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_slug_get200_response_review_aggregate.g.dart';

/// V1ProvidersSlugGet200ResponseReviewAggregate
///
/// Properties:
/// * [average]
/// * [count]
/// * [breakdown]
@BuiltValue()
abstract class V1ProvidersSlugGet200ResponseReviewAggregate
    implements
        Built<
          V1ProvidersSlugGet200ResponseReviewAggregate,
          V1ProvidersSlugGet200ResponseReviewAggregateBuilder
        > {
  @BuiltValueField(wireName: r'average')
  num get average;

  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'breakdown')
  V1ProvidersSlugGet200ResponseReviewAggregateBreakdown get breakdown;

  V1ProvidersSlugGet200ResponseReviewAggregate._();

  factory V1ProvidersSlugGet200ResponseReviewAggregate([
    void updates(V1ProvidersSlugGet200ResponseReviewAggregateBuilder b),
  ]) = _$V1ProvidersSlugGet200ResponseReviewAggregate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    V1ProvidersSlugGet200ResponseReviewAggregateBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersSlugGet200ResponseReviewAggregate>
  get serializer => _$V1ProvidersSlugGet200ResponseReviewAggregateSerializer();
}

class _$V1ProvidersSlugGet200ResponseReviewAggregateSerializer
    implements
        PrimitiveSerializer<V1ProvidersSlugGet200ResponseReviewAggregate> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersSlugGet200ResponseReviewAggregate,
    _$V1ProvidersSlugGet200ResponseReviewAggregate,
  ];

  @override
  final String wireName = r'V1ProvidersSlugGet200ResponseReviewAggregate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersSlugGet200ResponseReviewAggregate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'average';
    yield serializers.serialize(
      object.average,
      specifiedType: const FullType(num),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'breakdown';
    yield serializers.serialize(
      object.breakdown,
      specifiedType: const FullType(
        V1ProvidersSlugGet200ResponseReviewAggregateBreakdown,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersSlugGet200ResponseReviewAggregate object, {
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
    required V1ProvidersSlugGet200ResponseReviewAggregateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'average':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(num),
                  )
                  as num;
          result.average = valueDes;
          break;
        case r'count':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )
                  as int;
          result.count = valueDes;
          break;
        case r'breakdown':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      V1ProvidersSlugGet200ResponseReviewAggregateBreakdown,
                    ),
                  )
                  as V1ProvidersSlugGet200ResponseReviewAggregateBreakdown;
          result.breakdown = valueDes.toBuilder();
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersSlugGet200ResponseReviewAggregate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersSlugGet200ResponseReviewAggregateBuilder();
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

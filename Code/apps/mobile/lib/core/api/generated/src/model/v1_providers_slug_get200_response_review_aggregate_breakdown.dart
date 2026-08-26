//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_slug_get200_response_review_aggregate_breakdown.g.dart';

/// V1ProvidersSlugGet200ResponseReviewAggregateBreakdown
///
/// Properties:
/// * [n1]
/// * [n2]
/// * [n3]
/// * [n4]
/// * [n5]
@BuiltValue()
abstract class V1ProvidersSlugGet200ResponseReviewAggregateBreakdown
    implements
        Built<V1ProvidersSlugGet200ResponseReviewAggregateBreakdown,
            V1ProvidersSlugGet200ResponseReviewAggregateBreakdownBuilder> {
  @BuiltValueField(wireName: r'1')
  int get n1;

  @BuiltValueField(wireName: r'2')
  int get n2;

  @BuiltValueField(wireName: r'3')
  int get n3;

  @BuiltValueField(wireName: r'4')
  int get n4;

  @BuiltValueField(wireName: r'5')
  int get n5;

  V1ProvidersSlugGet200ResponseReviewAggregateBreakdown._();

  factory V1ProvidersSlugGet200ResponseReviewAggregateBreakdown(
      [void updates(
          V1ProvidersSlugGet200ResponseReviewAggregateBreakdownBuilder
              b)]) = _$V1ProvidersSlugGet200ResponseReviewAggregateBreakdown;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1ProvidersSlugGet200ResponseReviewAggregateBreakdownBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersSlugGet200ResponseReviewAggregateBreakdown>
      get serializer =>
          _$V1ProvidersSlugGet200ResponseReviewAggregateBreakdownSerializer();
}

class _$V1ProvidersSlugGet200ResponseReviewAggregateBreakdownSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersSlugGet200ResponseReviewAggregateBreakdown> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersSlugGet200ResponseReviewAggregateBreakdown,
    _$V1ProvidersSlugGet200ResponseReviewAggregateBreakdown
  ];

  @override
  final String wireName =
      r'V1ProvidersSlugGet200ResponseReviewAggregateBreakdown';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersSlugGet200ResponseReviewAggregateBreakdown object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'1';
    yield serializers.serialize(
      object.n1,
      specifiedType: const FullType(int),
    );
    yield r'2';
    yield serializers.serialize(
      object.n2,
      specifiedType: const FullType(int),
    );
    yield r'3';
    yield serializers.serialize(
      object.n3,
      specifiedType: const FullType(int),
    );
    yield r'4';
    yield serializers.serialize(
      object.n4,
      specifiedType: const FullType(int),
    );
    yield r'5';
    yield serializers.serialize(
      object.n5,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersSlugGet200ResponseReviewAggregateBreakdown object, {
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
    required V1ProvidersSlugGet200ResponseReviewAggregateBreakdownBuilder
        result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'1':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.n1 = valueDes;
          break;
        case r'2':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.n2 = valueDes;
          break;
        case r'3':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.n3 = valueDes;
          break;
        case r'4':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.n4 = valueDes;
          break;
        case r'5':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.n5 = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersSlugGet200ResponseReviewAggregateBreakdown deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1ProvidersSlugGet200ResponseReviewAggregateBreakdownBuilder();
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

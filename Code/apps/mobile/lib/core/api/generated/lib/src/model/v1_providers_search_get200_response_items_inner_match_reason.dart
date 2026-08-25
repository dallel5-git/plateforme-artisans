//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_search_get200_response_items_inner_match_reason.g.dart';

/// V1ProvidersSearchGet200ResponseItemsInnerMatchReason
///
/// Properties:
/// * [geo]
/// * [rating]
/// * [trust]
/// * [completion]
/// * [responsiveness]
/// * [plan]
/// * [penalty]
@BuiltValue()
abstract class V1ProvidersSearchGet200ResponseItemsInnerMatchReason
    implements
        Built<V1ProvidersSearchGet200ResponseItemsInnerMatchReason,
            V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder> {
  @BuiltValueField(wireName: r'geo')
  num get geo;

  @BuiltValueField(wireName: r'rating')
  num get rating;

  @BuiltValueField(wireName: r'trust')
  num get trust;

  @BuiltValueField(wireName: r'completion')
  num get completion;

  @BuiltValueField(wireName: r'responsiveness')
  num get responsiveness;

  @BuiltValueField(wireName: r'plan')
  num get plan;

  @BuiltValueField(wireName: r'penalty')
  num get penalty;

  V1ProvidersSearchGet200ResponseItemsInnerMatchReason._();

  factory V1ProvidersSearchGet200ResponseItemsInnerMatchReason(
          [void updates(
              V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder b)]) =
      _$V1ProvidersSearchGet200ResponseItemsInnerMatchReason;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersSearchGet200ResponseItemsInnerMatchReason>
      get serializer =>
          _$V1ProvidersSearchGet200ResponseItemsInnerMatchReasonSerializer();
}

class _$V1ProvidersSearchGet200ResponseItemsInnerMatchReasonSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersSearchGet200ResponseItemsInnerMatchReason> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersSearchGet200ResponseItemsInnerMatchReason,
    _$V1ProvidersSearchGet200ResponseItemsInnerMatchReason
  ];

  @override
  final String wireName =
      r'V1ProvidersSearchGet200ResponseItemsInnerMatchReason';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersSearchGet200ResponseItemsInnerMatchReason object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'geo';
    yield serializers.serialize(
      object.geo,
      specifiedType: const FullType(num),
    );
    yield r'rating';
    yield serializers.serialize(
      object.rating,
      specifiedType: const FullType(num),
    );
    yield r'trust';
    yield serializers.serialize(
      object.trust,
      specifiedType: const FullType(num),
    );
    yield r'completion';
    yield serializers.serialize(
      object.completion,
      specifiedType: const FullType(num),
    );
    yield r'responsiveness';
    yield serializers.serialize(
      object.responsiveness,
      specifiedType: const FullType(num),
    );
    yield r'plan';
    yield serializers.serialize(
      object.plan,
      specifiedType: const FullType(num),
    );
    yield r'penalty';
    yield serializers.serialize(
      object.penalty,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersSearchGet200ResponseItemsInnerMatchReason object, {
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
    required V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'geo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.geo = valueDes;
          break;
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.rating = valueDes;
          break;
        case r'trust':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.trust = valueDes;
          break;
        case r'completion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.completion = valueDes;
          break;
        case r'responsiveness':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.responsiveness = valueDes;
          break;
        case r'plan':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.plan = valueDes;
          break;
        case r'penalty':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.penalty = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersSearchGet200ResponseItemsInnerMatchReason deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_admin_verifications_get200_response_items_inner_reviewed_by.g.dart';

/// V1AdminVerificationsGet200ResponseItemsInnerReviewedBy
///
/// Properties:
/// * [id]
/// * [phone]
@BuiltValue()
abstract class V1AdminVerificationsGet200ResponseItemsInnerReviewedBy
    implements
        Built<V1AdminVerificationsGet200ResponseItemsInnerReviewedBy,
            V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'phone')
  String get phone;

  V1AdminVerificationsGet200ResponseItemsInnerReviewedBy._();

  factory V1AdminVerificationsGet200ResponseItemsInnerReviewedBy(
      [void updates(
          V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder
              b)]) = _$V1AdminVerificationsGet200ResponseItemsInnerReviewedBy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AdminVerificationsGet200ResponseItemsInnerReviewedBy>
      get serializer =>
          _$V1AdminVerificationsGet200ResponseItemsInnerReviewedBySerializer();
}

class _$V1AdminVerificationsGet200ResponseItemsInnerReviewedBySerializer
    implements
        PrimitiveSerializer<
            V1AdminVerificationsGet200ResponseItemsInnerReviewedBy> {
  @override
  final Iterable<Type> types = const [
    V1AdminVerificationsGet200ResponseItemsInnerReviewedBy,
    _$V1AdminVerificationsGet200ResponseItemsInnerReviewedBy
  ];

  @override
  final String wireName =
      r'V1AdminVerificationsGet200ResponseItemsInnerReviewedBy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AdminVerificationsGet200ResponseItemsInnerReviewedBy object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AdminVerificationsGet200ResponseItemsInnerReviewedBy object, {
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
    required V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder
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
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1AdminVerificationsGet200ResponseItemsInnerReviewedBy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder();
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

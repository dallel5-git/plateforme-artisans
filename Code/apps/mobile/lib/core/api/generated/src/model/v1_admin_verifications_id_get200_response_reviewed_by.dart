//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_admin_verifications_id_get200_response_reviewed_by.g.dart';

/// V1AdminVerificationsIdGet200ResponseReviewedBy
///
/// Properties:
/// * [id]
/// * [phone]
@BuiltValue()
abstract class V1AdminVerificationsIdGet200ResponseReviewedBy
    implements
        Built<V1AdminVerificationsIdGet200ResponseReviewedBy,
            V1AdminVerificationsIdGet200ResponseReviewedByBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'phone')
  String get phone;

  V1AdminVerificationsIdGet200ResponseReviewedBy._();

  factory V1AdminVerificationsIdGet200ResponseReviewedBy(
          [void updates(
              V1AdminVerificationsIdGet200ResponseReviewedByBuilder b)]) =
      _$V1AdminVerificationsIdGet200ResponseReviewedBy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1AdminVerificationsIdGet200ResponseReviewedByBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AdminVerificationsIdGet200ResponseReviewedBy>
      get serializer =>
          _$V1AdminVerificationsIdGet200ResponseReviewedBySerializer();
}

class _$V1AdminVerificationsIdGet200ResponseReviewedBySerializer
    implements
        PrimitiveSerializer<V1AdminVerificationsIdGet200ResponseReviewedBy> {
  @override
  final Iterable<Type> types = const [
    V1AdminVerificationsIdGet200ResponseReviewedBy,
    _$V1AdminVerificationsIdGet200ResponseReviewedBy
  ];

  @override
  final String wireName = r'V1AdminVerificationsIdGet200ResponseReviewedBy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AdminVerificationsIdGet200ResponseReviewedBy object, {
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
    V1AdminVerificationsIdGet200ResponseReviewedBy object, {
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
    required V1AdminVerificationsIdGet200ResponseReviewedByBuilder result,
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
  V1AdminVerificationsIdGet200ResponseReviewedBy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1AdminVerificationsIdGet200ResponseReviewedByBuilder();
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

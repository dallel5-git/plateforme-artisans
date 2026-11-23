//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_admin_verifications_id_review_post200_response.g.dart';

/// V1AdminVerificationsIdReviewPost200Response
///
/// Properties:
/// * [id]
/// * [status]
/// * [reviewedAt]
/// * [reviewedById]
/// * [isVerified]
/// * [rejectionReason]
/// * [internalNote]
@BuiltValue()
abstract class V1AdminVerificationsIdReviewPost200Response
    implements
        Built<V1AdminVerificationsIdReviewPost200Response,
            V1AdminVerificationsIdReviewPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  V1AdminVerificationsIdReviewPost200ResponseStatusEnum get status;
  // enum statusEnum {  NOT_SUBMITTED,  PENDING,  MORE_INFO_REQUIRED,  APPROVED,  REJECTED,  };

  @BuiltValueField(wireName: r'reviewedAt')
  DateTime get reviewedAt;

  @BuiltValueField(wireName: r'reviewedById')
  String get reviewedById;

  @BuiltValueField(wireName: r'isVerified')
  bool get isVerified;

  @BuiltValueField(wireName: r'rejectionReason')
  String get rejectionReason;

  @BuiltValueField(wireName: r'internalNote')
  String get internalNote;

  V1AdminVerificationsIdReviewPost200Response._();

  factory V1AdminVerificationsIdReviewPost200Response(
          [void updates(
              V1AdminVerificationsIdReviewPost200ResponseBuilder b)]) =
      _$V1AdminVerificationsIdReviewPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1AdminVerificationsIdReviewPost200ResponseBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AdminVerificationsIdReviewPost200Response>
      get serializer =>
          _$V1AdminVerificationsIdReviewPost200ResponseSerializer();
}

class _$V1AdminVerificationsIdReviewPost200ResponseSerializer
    implements
        PrimitiveSerializer<V1AdminVerificationsIdReviewPost200Response> {
  @override
  final Iterable<Type> types = const [
    V1AdminVerificationsIdReviewPost200Response,
    _$V1AdminVerificationsIdReviewPost200Response
  ];

  @override
  final String wireName = r'V1AdminVerificationsIdReviewPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AdminVerificationsIdReviewPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType:
          const FullType(V1AdminVerificationsIdReviewPost200ResponseStatusEnum),
    );
    yield r'reviewedAt';
    yield serializers.serialize(
      object.reviewedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'reviewedById';
    yield serializers.serialize(
      object.reviewedById,
      specifiedType: const FullType(String),
    );
    yield r'isVerified';
    yield serializers.serialize(
      object.isVerified,
      specifiedType: const FullType(bool),
    );
    yield r'rejectionReason';
    yield serializers.serialize(
      object.rejectionReason,
      specifiedType: const FullType(String),
    );
    yield r'internalNote';
    yield serializers.serialize(
      object.internalNote,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AdminVerificationsIdReviewPost200Response object, {
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
    required V1AdminVerificationsIdReviewPost200ResponseBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1AdminVerificationsIdReviewPost200ResponseStatusEnum),
          ) as V1AdminVerificationsIdReviewPost200ResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'reviewedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.reviewedAt = valueDes;
          break;
        case r'reviewedById':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reviewedById = valueDes;
          break;
        case r'isVerified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isVerified = valueDes;
          break;
        case r'rejectionReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.rejectionReason = valueDes;
          break;
        case r'internalNote':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.internalNote = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1AdminVerificationsIdReviewPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1AdminVerificationsIdReviewPost200ResponseBuilder();
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

class V1AdminVerificationsIdReviewPost200ResponseStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'NOT_SUBMITTED')
  static const V1AdminVerificationsIdReviewPost200ResponseStatusEnum
      NOT_SUBMITTED =
      _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_NOT_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING')
  static const V1AdminVerificationsIdReviewPost200ResponseStatusEnum PENDING =
      _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'MORE_INFO_REQUIRED')
  static const V1AdminVerificationsIdReviewPost200ResponseStatusEnum
      MORE_INFO_REQUIRED =
      _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_MORE_INFO_REQUIRED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const V1AdminVerificationsIdReviewPost200ResponseStatusEnum APPROVED =
      _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const V1AdminVerificationsIdReviewPost200ResponseStatusEnum REJECTED =
      _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_REJECTED;

  static Serializer<V1AdminVerificationsIdReviewPost200ResponseStatusEnum>
      get serializer =>
          _$v1AdminVerificationsIdReviewPost200ResponseStatusEnumSerializer;

  const V1AdminVerificationsIdReviewPost200ResponseStatusEnum._(String name)
      : super(name);

  static BuiltSet<V1AdminVerificationsIdReviewPost200ResponseStatusEnum>
      get values =>
          _$v1AdminVerificationsIdReviewPost200ResponseStatusEnumValues;
  static V1AdminVerificationsIdReviewPost200ResponseStatusEnum valueOf(
          String name) =>
      _$v1AdminVerificationsIdReviewPost200ResponseStatusEnumValueOf(name);
}

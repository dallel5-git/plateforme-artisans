//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_admin_verifications_id_review_post_request.g.dart';

/// V1AdminVerificationsIdReviewPostRequest
///
/// Properties:
/// * [status]
/// * [rejectionReason]
/// * [internalNote]
@BuiltValue()
abstract class V1AdminVerificationsIdReviewPostRequest
    implements
        Built<V1AdminVerificationsIdReviewPostRequest,
            V1AdminVerificationsIdReviewPostRequestBuilder> {
  @BuiltValueField(wireName: r'status')
  V1AdminVerificationsIdReviewPostRequestStatusEnum get status;
  // enum statusEnum {  APPROVED,  REJECTED,  MORE_INFO_REQUIRED,  };

  @BuiltValueField(wireName: r'rejectionReason')
  String? get rejectionReason;

  @BuiltValueField(wireName: r'internalNote')
  String? get internalNote;

  V1AdminVerificationsIdReviewPostRequest._();

  factory V1AdminVerificationsIdReviewPostRequest(
          [void updates(V1AdminVerificationsIdReviewPostRequestBuilder b)]) =
      _$V1AdminVerificationsIdReviewPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1AdminVerificationsIdReviewPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AdminVerificationsIdReviewPostRequest> get serializer =>
      _$V1AdminVerificationsIdReviewPostRequestSerializer();
}

class _$V1AdminVerificationsIdReviewPostRequestSerializer
    implements PrimitiveSerializer<V1AdminVerificationsIdReviewPostRequest> {
  @override
  final Iterable<Type> types = const [
    V1AdminVerificationsIdReviewPostRequest,
    _$V1AdminVerificationsIdReviewPostRequest
  ];

  @override
  final String wireName = r'V1AdminVerificationsIdReviewPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AdminVerificationsIdReviewPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType:
          const FullType(V1AdminVerificationsIdReviewPostRequestStatusEnum),
    );
    if (object.rejectionReason != null) {
      yield r'rejectionReason';
      yield serializers.serialize(
        object.rejectionReason,
        specifiedType: const FullType(String),
      );
    }
    if (object.internalNote != null) {
      yield r'internalNote';
      yield serializers.serialize(
        object.internalNote,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AdminVerificationsIdReviewPostRequest object, {
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
    required V1AdminVerificationsIdReviewPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1AdminVerificationsIdReviewPostRequestStatusEnum),
          ) as V1AdminVerificationsIdReviewPostRequestStatusEnum;
          result.status = valueDes;
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
  V1AdminVerificationsIdReviewPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1AdminVerificationsIdReviewPostRequestBuilder();
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

class V1AdminVerificationsIdReviewPostRequestStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const V1AdminVerificationsIdReviewPostRequestStatusEnum APPROVED =
      _$v1AdminVerificationsIdReviewPostRequestStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const V1AdminVerificationsIdReviewPostRequestStatusEnum REJECTED =
      _$v1AdminVerificationsIdReviewPostRequestStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'MORE_INFO_REQUIRED')
  static const V1AdminVerificationsIdReviewPostRequestStatusEnum
      MORE_INFO_REQUIRED =
      _$v1AdminVerificationsIdReviewPostRequestStatusEnum_MORE_INFO_REQUIRED;

  static Serializer<V1AdminVerificationsIdReviewPostRequestStatusEnum>
      get serializer =>
          _$v1AdminVerificationsIdReviewPostRequestStatusEnumSerializer;

  const V1AdminVerificationsIdReviewPostRequestStatusEnum._(String name)
      : super(name);

  static BuiltSet<V1AdminVerificationsIdReviewPostRequestStatusEnum>
      get values => _$v1AdminVerificationsIdReviewPostRequestStatusEnumValues;
  static V1AdminVerificationsIdReviewPostRequestStatusEnum valueOf(
          String name) =>
      _$v1AdminVerificationsIdReviewPostRequestStatusEnumValueOf(name);
}

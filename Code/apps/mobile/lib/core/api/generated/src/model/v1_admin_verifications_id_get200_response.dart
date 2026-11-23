//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sanaya/core/api/generated/src/model/v1_admin_verifications_id_get200_response_reviewed_by.dart';
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_admin_verifications_id_get200_response_documents_inner.dart';
import 'package:built_value/json_object.dart';
import 'package:sanaya/core/api/generated/src/model/v1_admin_verifications_id_get200_response_provider.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_admin_verifications_id_get200_response.g.dart';

/// V1AdminVerificationsIdGet200Response
///
/// Properties:
/// * [id]
/// * [providerId]
/// * [provider]
/// * [fullNameOnId]
/// * [status]
/// * [submittedAt]
/// * [reviewedAt]
/// * [reviewedBy]
/// * [rejectionReason]
/// * [internalNote]
/// * [expiresAt]
/// * [documents]
@BuiltValue()
abstract class V1AdminVerificationsIdGet200Response
    implements
        Built<V1AdminVerificationsIdGet200Response,
            V1AdminVerificationsIdGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'providerId')
  String get providerId;

  @BuiltValueField(wireName: r'provider')
  V1AdminVerificationsIdGet200ResponseProvider get provider;

  @BuiltValueField(wireName: r'fullNameOnId')
  String get fullNameOnId;

  @BuiltValueField(wireName: r'status')
  V1AdminVerificationsIdGet200ResponseStatusEnum get status;
  // enum statusEnum {  NOT_SUBMITTED,  PENDING,  MORE_INFO_REQUIRED,  APPROVED,  REJECTED,  };

  @BuiltValueField(wireName: r'submittedAt')
  DateTime get submittedAt;

  @BuiltValueField(wireName: r'reviewedAt')
  DateTime get reviewedAt;

  @BuiltValueField(wireName: r'reviewedBy')
  V1AdminVerificationsIdGet200ResponseReviewedBy get reviewedBy;

  @BuiltValueField(wireName: r'rejectionReason')
  String get rejectionReason;

  @BuiltValueField(wireName: r'internalNote')
  String get internalNote;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime? get expiresAt;

  @BuiltValueField(wireName: r'documents')
  BuiltList<V1AdminVerificationsIdGet200ResponseDocumentsInner> get documents;

  V1AdminVerificationsIdGet200Response._();

  factory V1AdminVerificationsIdGet200Response(
          [void updates(V1AdminVerificationsIdGet200ResponseBuilder b)]) =
      _$V1AdminVerificationsIdGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1AdminVerificationsIdGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AdminVerificationsIdGet200Response> get serializer =>
      _$V1AdminVerificationsIdGet200ResponseSerializer();
}

class _$V1AdminVerificationsIdGet200ResponseSerializer
    implements PrimitiveSerializer<V1AdminVerificationsIdGet200Response> {
  @override
  final Iterable<Type> types = const [
    V1AdminVerificationsIdGet200Response,
    _$V1AdminVerificationsIdGet200Response
  ];

  @override
  final String wireName = r'V1AdminVerificationsIdGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AdminVerificationsIdGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'providerId';
    yield serializers.serialize(
      object.providerId,
      specifiedType: const FullType(String),
    );
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType:
          const FullType(V1AdminVerificationsIdGet200ResponseProvider),
    );
    yield r'fullNameOnId';
    yield serializers.serialize(
      object.fullNameOnId,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType:
          const FullType(V1AdminVerificationsIdGet200ResponseStatusEnum),
    );
    yield r'submittedAt';
    yield serializers.serialize(
      object.submittedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'reviewedAt';
    yield serializers.serialize(
      object.reviewedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'reviewedBy';
    yield serializers.serialize(
      object.reviewedBy,
      specifiedType:
          const FullType(V1AdminVerificationsIdGet200ResponseReviewedBy),
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
    if (object.expiresAt != null) {
      yield r'expiresAt';
      yield serializers.serialize(
        object.expiresAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'documents';
    yield serializers.serialize(
      object.documents,
      specifiedType: const FullType(BuiltList,
          [FullType(V1AdminVerificationsIdGet200ResponseDocumentsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AdminVerificationsIdGet200Response object, {
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
    required V1AdminVerificationsIdGet200ResponseBuilder result,
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
        case r'providerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerId = valueDes;
          break;
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(V1AdminVerificationsIdGet200ResponseProvider),
          ) as V1AdminVerificationsIdGet200ResponseProvider;
          result.provider = valueDes.toBuilder();
          break;
        case r'fullNameOnId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullNameOnId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(V1AdminVerificationsIdGet200ResponseStatusEnum),
          ) as V1AdminVerificationsIdGet200ResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'submittedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.submittedAt = valueDes;
          break;
        case r'reviewedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.reviewedAt = valueDes;
          break;
        case r'reviewedBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(V1AdminVerificationsIdGet200ResponseReviewedBy),
          ) as V1AdminVerificationsIdGet200ResponseReviewedBy;
          result.reviewedBy.replace(valueDes);
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
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'documents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(V1AdminVerificationsIdGet200ResponseDocumentsInner)]),
          ) as BuiltList<V1AdminVerificationsIdGet200ResponseDocumentsInner>;
          result.documents.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1AdminVerificationsIdGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1AdminVerificationsIdGet200ResponseBuilder();
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

class V1AdminVerificationsIdGet200ResponseStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'NOT_SUBMITTED')
  static const V1AdminVerificationsIdGet200ResponseStatusEnum NOT_SUBMITTED =
      _$v1AdminVerificationsIdGet200ResponseStatusEnum_NOT_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING')
  static const V1AdminVerificationsIdGet200ResponseStatusEnum PENDING =
      _$v1AdminVerificationsIdGet200ResponseStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'MORE_INFO_REQUIRED')
  static const V1AdminVerificationsIdGet200ResponseStatusEnum
      MORE_INFO_REQUIRED =
      _$v1AdminVerificationsIdGet200ResponseStatusEnum_MORE_INFO_REQUIRED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const V1AdminVerificationsIdGet200ResponseStatusEnum APPROVED =
      _$v1AdminVerificationsIdGet200ResponseStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const V1AdminVerificationsIdGet200ResponseStatusEnum REJECTED =
      _$v1AdminVerificationsIdGet200ResponseStatusEnum_REJECTED;

  static Serializer<V1AdminVerificationsIdGet200ResponseStatusEnum>
      get serializer =>
          _$v1AdminVerificationsIdGet200ResponseStatusEnumSerializer;

  const V1AdminVerificationsIdGet200ResponseStatusEnum._(String name)
      : super(name);

  static BuiltSet<V1AdminVerificationsIdGet200ResponseStatusEnum> get values =>
      _$v1AdminVerificationsIdGet200ResponseStatusEnumValues;
  static V1AdminVerificationsIdGet200ResponseStatusEnum valueOf(String name) =>
      _$v1AdminVerificationsIdGet200ResponseStatusEnumValueOf(name);
}

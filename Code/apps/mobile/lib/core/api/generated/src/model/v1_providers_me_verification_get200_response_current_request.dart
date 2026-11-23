//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_verification_get200_response_current_request_documents_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_verification_get200_response_current_request.g.dart';

/// V1ProvidersMeVerificationGet200ResponseCurrentRequest
///
/// Properties:
/// * [id]
/// * [status]
/// * [fullNameOnId]
/// * [submittedAt]
/// * [reviewedAt]
/// * [rejectionReason]
/// * [documents]
@BuiltValue()
abstract class V1ProvidersMeVerificationGet200ResponseCurrentRequest
    implements
        Built<V1ProvidersMeVerificationGet200ResponseCurrentRequest,
            V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum get status;
  // enum statusEnum {  NOT_SUBMITTED,  PENDING,  MORE_INFO_REQUIRED,  APPROVED,  REJECTED,  };

  @BuiltValueField(wireName: r'fullNameOnId')
  String get fullNameOnId;

  @BuiltValueField(wireName: r'submittedAt')
  DateTime get submittedAt;

  @BuiltValueField(wireName: r'reviewedAt')
  DateTime get reviewedAt;

  @BuiltValueField(wireName: r'rejectionReason')
  String get rejectionReason;

  @BuiltValueField(wireName: r'documents')
  BuiltList<V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner>
      get documents;

  V1ProvidersMeVerificationGet200ResponseCurrentRequest._();

  factory V1ProvidersMeVerificationGet200ResponseCurrentRequest(
      [void updates(
          V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder
              b)]) = _$V1ProvidersMeVerificationGet200ResponseCurrentRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeVerificationGet200ResponseCurrentRequest>
      get serializer =>
          _$V1ProvidersMeVerificationGet200ResponseCurrentRequestSerializer();
}

class _$V1ProvidersMeVerificationGet200ResponseCurrentRequestSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersMeVerificationGet200ResponseCurrentRequest> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeVerificationGet200ResponseCurrentRequest,
    _$V1ProvidersMeVerificationGet200ResponseCurrentRequest
  ];

  @override
  final String wireName =
      r'V1ProvidersMeVerificationGet200ResponseCurrentRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeVerificationGet200ResponseCurrentRequest object, {
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
      specifiedType: const FullType(
          V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum),
    );
    yield r'fullNameOnId';
    yield serializers.serialize(
      object.fullNameOnId,
      specifiedType: const FullType(String),
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
    yield r'rejectionReason';
    yield serializers.serialize(
      object.rejectionReason,
      specifiedType: const FullType(String),
    );
    yield r'documents';
    yield serializers.serialize(
      object.documents,
      specifiedType: const FullType(BuiltList, [
        FullType(
            V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner)
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeVerificationGet200ResponseCurrentRequest object, {
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
    required V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum),
          ) as V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum;
          result.status = valueDes;
          break;
        case r'fullNameOnId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullNameOnId = valueDes;
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
        case r'rejectionReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.rejectionReason = valueDes;
          break;
        case r'documents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType(
                  V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner)
            ]),
          ) as BuiltList<
              V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner>;
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
  V1ProvidersMeVerificationGet200ResponseCurrentRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder();
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

class V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'NOT_SUBMITTED')
  static const V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum
      NOT_SUBMITTED =
      _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_NOT_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING')
  static const V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum
      PENDING =
      _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'MORE_INFO_REQUIRED')
  static const V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum
      MORE_INFO_REQUIRED =
      _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_MORE_INFO_REQUIRED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum
      APPROVED =
      _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum
      REJECTED =
      _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_REJECTED;

  static Serializer<
          V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum>
      get serializer =>
          _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnumSerializer;

  const V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum._(
      String name)
      : super(name);

  static BuiltSet<
          V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum>
      get values =>
          _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnumValues;
  static V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum valueOf(
          String name) =>
      _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnumValueOf(
          name);
}

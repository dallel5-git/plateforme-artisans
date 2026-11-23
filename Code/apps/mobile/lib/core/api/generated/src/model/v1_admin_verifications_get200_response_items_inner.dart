//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_admin_verifications_get200_response_items_inner_provider.dart';
import 'package:built_value/json_object.dart';
import 'package:sanaya/core/api/generated/src/model/v1_admin_verifications_get200_response_items_inner_documents_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_admin_verifications_get200_response_items_inner_reviewed_by.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_admin_verifications_get200_response_items_inner.g.dart';

/// V1AdminVerificationsGet200ResponseItemsInner
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
/// * [documentsCount]
/// * [documents]
@BuiltValue()
abstract class V1AdminVerificationsGet200ResponseItemsInner
    implements
        Built<V1AdminVerificationsGet200ResponseItemsInner,
            V1AdminVerificationsGet200ResponseItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'providerId')
  String get providerId;

  @BuiltValueField(wireName: r'provider')
  V1AdminVerificationsGet200ResponseItemsInnerProvider get provider;

  @BuiltValueField(wireName: r'fullNameOnId')
  String get fullNameOnId;

  @BuiltValueField(wireName: r'status')
  V1AdminVerificationsGet200ResponseItemsInnerStatusEnum get status;
  // enum statusEnum {  NOT_SUBMITTED,  PENDING,  MORE_INFO_REQUIRED,  APPROVED,  REJECTED,  };

  @BuiltValueField(wireName: r'submittedAt')
  DateTime get submittedAt;

  @BuiltValueField(wireName: r'reviewedAt')
  DateTime get reviewedAt;

  @BuiltValueField(wireName: r'reviewedBy')
  V1AdminVerificationsGet200ResponseItemsInnerReviewedBy get reviewedBy;

  @BuiltValueField(wireName: r'documentsCount')
  int get documentsCount;

  @BuiltValueField(wireName: r'documents')
  BuiltList<V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner>
      get documents;

  V1AdminVerificationsGet200ResponseItemsInner._();

  factory V1AdminVerificationsGet200ResponseItemsInner(
          [void updates(
              V1AdminVerificationsGet200ResponseItemsInnerBuilder b)]) =
      _$V1AdminVerificationsGet200ResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1AdminVerificationsGet200ResponseItemsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AdminVerificationsGet200ResponseItemsInner>
      get serializer =>
          _$V1AdminVerificationsGet200ResponseItemsInnerSerializer();
}

class _$V1AdminVerificationsGet200ResponseItemsInnerSerializer
    implements
        PrimitiveSerializer<V1AdminVerificationsGet200ResponseItemsInner> {
  @override
  final Iterable<Type> types = const [
    V1AdminVerificationsGet200ResponseItemsInner,
    _$V1AdminVerificationsGet200ResponseItemsInner
  ];

  @override
  final String wireName = r'V1AdminVerificationsGet200ResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AdminVerificationsGet200ResponseItemsInner object, {
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
          const FullType(V1AdminVerificationsGet200ResponseItemsInnerProvider),
    );
    yield r'fullNameOnId';
    yield serializers.serialize(
      object.fullNameOnId,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
          V1AdminVerificationsGet200ResponseItemsInnerStatusEnum),
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
      specifiedType: const FullType(
          V1AdminVerificationsGet200ResponseItemsInnerReviewedBy),
    );
    yield r'documentsCount';
    yield serializers.serialize(
      object.documentsCount,
      specifiedType: const FullType(int),
    );
    yield r'documents';
    yield serializers.serialize(
      object.documents,
      specifiedType: const FullType(BuiltList, [
        FullType(V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner)
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AdminVerificationsGet200ResponseItemsInner object, {
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
    required V1AdminVerificationsGet200ResponseItemsInnerBuilder result,
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
            specifiedType: const FullType(
                V1AdminVerificationsGet200ResponseItemsInnerProvider),
          ) as V1AdminVerificationsGet200ResponseItemsInnerProvider;
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
            specifiedType: const FullType(
                V1AdminVerificationsGet200ResponseItemsInnerStatusEnum),
          ) as V1AdminVerificationsGet200ResponseItemsInnerStatusEnum;
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
            specifiedType: const FullType(
                V1AdminVerificationsGet200ResponseItemsInnerReviewedBy),
          ) as V1AdminVerificationsGet200ResponseItemsInnerReviewedBy;
          result.reviewedBy = valueDes.toBuilder();
          break;
        case r'documentsCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.documentsCount = valueDes;
          break;
        case r'documents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType(
                  V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner)
            ]),
          ) as BuiltList<
              V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner>;
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
  V1AdminVerificationsGet200ResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1AdminVerificationsGet200ResponseItemsInnerBuilder();
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

class V1AdminVerificationsGet200ResponseItemsInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'NOT_SUBMITTED')
  static const V1AdminVerificationsGet200ResponseItemsInnerStatusEnum
      NOT_SUBMITTED =
      _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_NOT_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING')
  static const V1AdminVerificationsGet200ResponseItemsInnerStatusEnum PENDING =
      _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'MORE_INFO_REQUIRED')
  static const V1AdminVerificationsGet200ResponseItemsInnerStatusEnum
      MORE_INFO_REQUIRED =
      _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_MORE_INFO_REQUIRED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const V1AdminVerificationsGet200ResponseItemsInnerStatusEnum APPROVED =
      _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const V1AdminVerificationsGet200ResponseItemsInnerStatusEnum REJECTED =
      _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_REJECTED;

  static Serializer<V1AdminVerificationsGet200ResponseItemsInnerStatusEnum>
      get serializer =>
          _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnumSerializer;

  const V1AdminVerificationsGet200ResponseItemsInnerStatusEnum._(String name)
      : super(name);

  static BuiltSet<V1AdminVerificationsGet200ResponseItemsInnerStatusEnum>
      get values =>
          _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnumValues;
  static V1AdminVerificationsGet200ResponseItemsInnerStatusEnum valueOf(
          String name) =>
      _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnumValueOf(name);
}

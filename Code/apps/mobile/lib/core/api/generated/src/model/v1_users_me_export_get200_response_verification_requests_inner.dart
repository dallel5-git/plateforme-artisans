//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_users_me_export_get200_response_verification_requests_inner.g.dart';

/// V1UsersMeExportGet200ResponseVerificationRequestsInner
///
/// Properties:
/// * [id]
/// * [status]
/// * [submittedAt]
/// * [reviewedAt]
/// * [rejectionReason]
/// * [documentTypes]
@BuiltValue()
abstract class V1UsersMeExportGet200ResponseVerificationRequestsInner
    implements
        Built<V1UsersMeExportGet200ResponseVerificationRequestsInner,
            V1UsersMeExportGet200ResponseVerificationRequestsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'submittedAt')
  DateTime get submittedAt;

  @BuiltValueField(wireName: r'reviewedAt')
  DateTime get reviewedAt;

  @BuiltValueField(wireName: r'rejectionReason')
  String get rejectionReason;

  @BuiltValueField(wireName: r'documentTypes')
  BuiltList<String> get documentTypes;

  V1UsersMeExportGet200ResponseVerificationRequestsInner._();

  factory V1UsersMeExportGet200ResponseVerificationRequestsInner(
      [void updates(
          V1UsersMeExportGet200ResponseVerificationRequestsInnerBuilder
              b)]) = _$V1UsersMeExportGet200ResponseVerificationRequestsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1UsersMeExportGet200ResponseVerificationRequestsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1UsersMeExportGet200ResponseVerificationRequestsInner>
      get serializer =>
          _$V1UsersMeExportGet200ResponseVerificationRequestsInnerSerializer();
}

class _$V1UsersMeExportGet200ResponseVerificationRequestsInnerSerializer
    implements
        PrimitiveSerializer<
            V1UsersMeExportGet200ResponseVerificationRequestsInner> {
  @override
  final Iterable<Type> types = const [
    V1UsersMeExportGet200ResponseVerificationRequestsInner,
    _$V1UsersMeExportGet200ResponseVerificationRequestsInner
  ];

  @override
  final String wireName =
      r'V1UsersMeExportGet200ResponseVerificationRequestsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1UsersMeExportGet200ResponseVerificationRequestsInner object, {
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
    yield r'documentTypes';
    yield serializers.serialize(
      object.documentTypes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1UsersMeExportGet200ResponseVerificationRequestsInner object, {
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
    required V1UsersMeExportGet200ResponseVerificationRequestsInnerBuilder
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
            specifiedType: const FullType(String),
          ) as String;
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
        case r'rejectionReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.rejectionReason = valueDes;
          break;
        case r'documentTypes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.documentTypes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1UsersMeExportGet200ResponseVerificationRequestsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1UsersMeExportGet200ResponseVerificationRequestsInnerBuilder();
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

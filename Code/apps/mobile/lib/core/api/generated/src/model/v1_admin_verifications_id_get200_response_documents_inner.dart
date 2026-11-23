//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_admin_verifications_id_get200_response_documents_inner.g.dart';

/// V1AdminVerificationsIdGet200ResponseDocumentsInner
///
/// Properties:
/// * [id]
/// * [type]
/// * [mediaId]
/// * [downloadUrl]
/// * [expiresAt]
@BuiltValue()
abstract class V1AdminVerificationsIdGet200ResponseDocumentsInner
    implements
        Built<V1AdminVerificationsIdGet200ResponseDocumentsInner,
            V1AdminVerificationsIdGet200ResponseDocumentsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum get type;
  // enum typeEnum {  CIN_FRONT,  CIN_BACK,  SELFIE_WITH_ID,  PATENTE,  DIPLOMA,  INSURANCE,  OTHER,  };

  @BuiltValueField(wireName: r'mediaId')
  String get mediaId;

  @BuiltValueField(wireName: r'downloadUrl')
  String get downloadUrl;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  V1AdminVerificationsIdGet200ResponseDocumentsInner._();

  factory V1AdminVerificationsIdGet200ResponseDocumentsInner(
          [void updates(
              V1AdminVerificationsIdGet200ResponseDocumentsInnerBuilder b)]) =
      _$V1AdminVerificationsIdGet200ResponseDocumentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1AdminVerificationsIdGet200ResponseDocumentsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AdminVerificationsIdGet200ResponseDocumentsInner>
      get serializer =>
          _$V1AdminVerificationsIdGet200ResponseDocumentsInnerSerializer();
}

class _$V1AdminVerificationsIdGet200ResponseDocumentsInnerSerializer
    implements
        PrimitiveSerializer<
            V1AdminVerificationsIdGet200ResponseDocumentsInner> {
  @override
  final Iterable<Type> types = const [
    V1AdminVerificationsIdGet200ResponseDocumentsInner,
    _$V1AdminVerificationsIdGet200ResponseDocumentsInner
  ];

  @override
  final String wireName = r'V1AdminVerificationsIdGet200ResponseDocumentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AdminVerificationsIdGet200ResponseDocumentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(
          V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum),
    );
    yield r'mediaId';
    yield serializers.serialize(
      object.mediaId,
      specifiedType: const FullType(String),
    );
    yield r'downloadUrl';
    yield serializers.serialize(
      object.downloadUrl,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AdminVerificationsIdGet200ResponseDocumentsInner object, {
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
    required V1AdminVerificationsIdGet200ResponseDocumentsInnerBuilder result,
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum),
          ) as V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'mediaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mediaId = valueDes;
          break;
        case r'downloadUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.downloadUrl = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1AdminVerificationsIdGet200ResponseDocumentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1AdminVerificationsIdGet200ResponseDocumentsInnerBuilder();
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

class V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'CIN_FRONT')
  static const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
      CIN_FRONT =
      _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_CIN_FRONT;
  @BuiltValueEnumConst(wireName: r'CIN_BACK')
  static const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
      CIN_BACK =
      _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_CIN_BACK;
  @BuiltValueEnumConst(wireName: r'SELFIE_WITH_ID')
  static const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
      SELFIE_WITH_ID =
      _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_SELFIE_WITH_ID;
  @BuiltValueEnumConst(wireName: r'PATENTE')
  static const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
      PATENTE =
      _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_PATENTE;
  @BuiltValueEnumConst(wireName: r'DIPLOMA')
  static const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
      DIPLOMA =
      _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_DIPLOMA;
  @BuiltValueEnumConst(wireName: r'INSURANCE')
  static const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
      INSURANCE =
      _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_INSURANCE;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
      OTHER =
      _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_OTHER;

  static Serializer<V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum>
      get serializer =>
          _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnumSerializer;

  const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum._(
      String name)
      : super(name);

  static BuiltSet<V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum>
      get values =>
          _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnumValues;
  static V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum valueOf(
          String name) =>
      _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnumValueOf(name);
}

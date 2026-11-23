//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_verification_get200_response_current_request_documents_inner.g.dart';

/// V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner
///
/// Properties:
/// * [id]
/// * [mediaId]
/// * [type]
/// * [createdAt]
@BuiltValue()
abstract class V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner
    implements
        Built<
            V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner,
            V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'mediaId')
  String get mediaId;

  @BuiltValueField(wireName: r'type')
  V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
      get type;
  // enum typeEnum {  CIN_FRONT,  CIN_BACK,  SELFIE_WITH_ID,  PATENTE,  DIPLOMA,  INSURANCE,  OTHER,  };

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner._();

  factory V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner(
          [void updates(
              V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerBuilder
                  b)]) =
      _$V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerBuilder
              b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<
          V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner>
      get serializer =>
          _$V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerSerializer();
}

class _$V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner,
    _$V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner
  ];

  @override
  final String wireName =
      r'V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner
        object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'mediaId';
    yield serializers.serialize(
      object.mediaId,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(
          V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner
        object, {
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
    required V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerBuilder
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
        case r'mediaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mediaId = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum),
          ) as V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner
      deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerBuilder();
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

class V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'CIN_FRONT')
  static const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
      CIN_FRONT =
      _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_CIN_FRONT;
  @BuiltValueEnumConst(wireName: r'CIN_BACK')
  static const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
      CIN_BACK =
      _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_CIN_BACK;
  @BuiltValueEnumConst(wireName: r'SELFIE_WITH_ID')
  static const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
      SELFIE_WITH_ID =
      _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_SELFIE_WITH_ID;
  @BuiltValueEnumConst(wireName: r'PATENTE')
  static const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
      PATENTE =
      _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_PATENTE;
  @BuiltValueEnumConst(wireName: r'DIPLOMA')
  static const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
      DIPLOMA =
      _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_DIPLOMA;
  @BuiltValueEnumConst(wireName: r'INSURANCE')
  static const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
      INSURANCE =
      _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_INSURANCE;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
      OTHER =
      _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_OTHER;

  static Serializer<
          V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum>
      get serializer =>
          _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnumSerializer;

  const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum._(
      String name)
      : super(name);

  static BuiltSet<
          V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum>
      get values =>
          _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnumValues;
  static V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
      valueOf(String name) =>
          _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnumValueOf(
              name);
}

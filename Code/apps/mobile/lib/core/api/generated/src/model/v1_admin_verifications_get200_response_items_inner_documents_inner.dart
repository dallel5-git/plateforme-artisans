//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_admin_verifications_get200_response_items_inner_documents_inner.g.dart';

/// V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner
///
/// Properties:
/// * [id]
/// * [type]
@BuiltValue()
abstract class V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner
    implements
        Built<V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner,
            V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum get type;
  // enum typeEnum {  CIN_FRONT,  CIN_BACK,  SELFIE_WITH_ID,  PATENTE,  DIPLOMA,  INSURANCE,  OTHER,  };

  V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner._();

  factory V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner(
          [void updates(
              V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerBuilder
                  b)]) =
      _$V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerBuilder
              b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner>
      get serializer =>
          _$V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerSerializer();
}

class _$V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerSerializer
    implements
        PrimitiveSerializer<
            V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner> {
  @override
  final Iterable<Type> types = const [
    V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner,
    _$V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner
  ];

  @override
  final String wireName =
      r'V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner object, {
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
          V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner object, {
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
    required V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerBuilder
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum),
          ) as V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerBuilder();
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

class V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'CIN_FRONT')
  static const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
      CIN_FRONT =
      _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_CIN_FRONT;
  @BuiltValueEnumConst(wireName: r'CIN_BACK')
  static const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
      CIN_BACK =
      _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_CIN_BACK;
  @BuiltValueEnumConst(wireName: r'SELFIE_WITH_ID')
  static const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
      SELFIE_WITH_ID =
      _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_SELFIE_WITH_ID;
  @BuiltValueEnumConst(wireName: r'PATENTE')
  static const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
      PATENTE =
      _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_PATENTE;
  @BuiltValueEnumConst(wireName: r'DIPLOMA')
  static const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
      DIPLOMA =
      _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_DIPLOMA;
  @BuiltValueEnumConst(wireName: r'INSURANCE')
  static const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
      INSURANCE =
      _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_INSURANCE;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
      OTHER =
      _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_OTHER;

  static Serializer<
          V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum>
      get serializer =>
          _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnumSerializer;

  const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum._(
      String name)
      : super(name);

  static BuiltSet<
          V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum>
      get values =>
          _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnumValues;
  static V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum valueOf(
          String name) =>
      _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnumValueOf(
          name);
}

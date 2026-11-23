//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_verification_presign_post_request.g.dart';

/// V1ProvidersMeVerificationPresignPostRequest
///
/// Properties:
/// * [documentType]
/// * [mimeType]
/// * [sizeBytes]
@BuiltValue()
abstract class V1ProvidersMeVerificationPresignPostRequest
    implements
        Built<V1ProvidersMeVerificationPresignPostRequest,
            V1ProvidersMeVerificationPresignPostRequestBuilder> {
  @BuiltValueField(wireName: r'documentType')
  V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum get documentType;
  // enum documentTypeEnum {  CIN_FRONT,  CIN_BACK,  SELFIE_WITH_ID,  PATENTE,  DIPLOMA,  INSURANCE,  OTHER,  };

  @BuiltValueField(wireName: r'mimeType')
  V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum get mimeType;
  // enum mimeTypeEnum {  image/jpeg,  image/png,  };

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  V1ProvidersMeVerificationPresignPostRequest._();

  factory V1ProvidersMeVerificationPresignPostRequest(
          [void updates(
              V1ProvidersMeVerificationPresignPostRequestBuilder b)]) =
      _$V1ProvidersMeVerificationPresignPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMeVerificationPresignPostRequestBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeVerificationPresignPostRequest>
      get serializer =>
          _$V1ProvidersMeVerificationPresignPostRequestSerializer();
}

class _$V1ProvidersMeVerificationPresignPostRequestSerializer
    implements
        PrimitiveSerializer<V1ProvidersMeVerificationPresignPostRequest> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeVerificationPresignPostRequest,
    _$V1ProvidersMeVerificationPresignPostRequest
  ];

  @override
  final String wireName = r'V1ProvidersMeVerificationPresignPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeVerificationPresignPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'documentType';
    yield serializers.serialize(
      object.documentType,
      specifiedType: const FullType(
          V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum),
    );
    yield r'mimeType';
    yield serializers.serialize(
      object.mimeType,
      specifiedType: const FullType(
          V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum),
    );
    yield r'sizeBytes';
    yield serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeVerificationPresignPostRequest object, {
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
    required V1ProvidersMeVerificationPresignPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'documentType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum),
          ) as V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum;
          result.documentType = valueDes;
          break;
        case r'mimeType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum),
          ) as V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum;
          result.mimeType = valueDes;
          break;
        case r'sizeBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sizeBytes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMeVerificationPresignPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeVerificationPresignPostRequestBuilder();
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

class V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'CIN_FRONT')
  static const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
      CIN_FRONT =
      _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_CIN_FRONT;
  @BuiltValueEnumConst(wireName: r'CIN_BACK')
  static const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
      CIN_BACK =
      _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_CIN_BACK;
  @BuiltValueEnumConst(wireName: r'SELFIE_WITH_ID')
  static const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
      SELFIE_WITH_ID =
      _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_SELFIE_WITH_ID;
  @BuiltValueEnumConst(wireName: r'PATENTE')
  static const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
      PATENTE =
      _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_PATENTE;
  @BuiltValueEnumConst(wireName: r'DIPLOMA')
  static const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
      DIPLOMA =
      _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_DIPLOMA;
  @BuiltValueEnumConst(wireName: r'INSURANCE')
  static const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
      INSURANCE =
      _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_INSURANCE;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
      OTHER =
      _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_OTHER;

  static Serializer<V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum>
      get serializer =>
          _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnumSerializer;

  const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum._(
      String name)
      : super(name);

  static BuiltSet<V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum>
      get values =>
          _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnumValues;
  static V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum valueOf(
          String name) =>
      _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnumValueOf(
          name);
}

class V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'image/jpeg')
  static const V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum
      imageSlashJpeg =
      _$v1ProvidersMeVerificationPresignPostRequestMimeTypeEnum_imageSlashJpeg;
  @BuiltValueEnumConst(wireName: r'image/png')
  static const V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum
      imageSlashPng =
      _$v1ProvidersMeVerificationPresignPostRequestMimeTypeEnum_imageSlashPng;

  static Serializer<V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum>
      get serializer =>
          _$v1ProvidersMeVerificationPresignPostRequestMimeTypeEnumSerializer;

  const V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum._(String name)
      : super(name);

  static BuiltSet<V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum>
      get values =>
          _$v1ProvidersMeVerificationPresignPostRequestMimeTypeEnumValues;
  static V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum valueOf(
          String name) =>
      _$v1ProvidersMeVerificationPresignPostRequestMimeTypeEnumValueOf(name);
}

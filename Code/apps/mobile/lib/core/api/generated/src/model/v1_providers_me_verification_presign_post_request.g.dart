// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_verification_presign_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
    _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_CIN_FRONT =
    const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum._(
        'CIN_FRONT');
const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
    _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_CIN_BACK =
    const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum._(
        'CIN_BACK');
const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
    _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_SELFIE_WITH_ID =
    const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum._(
        'SELFIE_WITH_ID');
const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
    _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_PATENTE =
    const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum._(
        'PATENTE');
const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
    _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_DIPLOMA =
    const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum._(
        'DIPLOMA');
const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
    _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_INSURANCE =
    const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum._(
        'INSURANCE');
const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
    _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_OTHER =
    const V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum._(
        'OTHER');

V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
    _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnumValueOf(
        String name) {
  switch (name) {
    case 'CIN_FRONT':
      return _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_CIN_FRONT;
    case 'CIN_BACK':
      return _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_CIN_BACK;
    case 'SELFIE_WITH_ID':
      return _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_SELFIE_WITH_ID;
    case 'PATENTE':
      return _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_PATENTE;
    case 'DIPLOMA':
      return _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_DIPLOMA;
    case 'INSURANCE':
      return _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_INSURANCE;
    case 'OTHER':
      return _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum>
    _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnumValues =
    BuiltSet<
        V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum>(const <V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum>[
  _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_CIN_FRONT,
  _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_CIN_BACK,
  _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_SELFIE_WITH_ID,
  _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_PATENTE,
  _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_DIPLOMA,
  _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_INSURANCE,
  _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum_OTHER,
]);

const V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum
    _$v1ProvidersMeVerificationPresignPostRequestMimeTypeEnum_imageSlashJpeg =
    const V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum._(
        'imageSlashJpeg');
const V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum
    _$v1ProvidersMeVerificationPresignPostRequestMimeTypeEnum_imageSlashPng =
    const V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum._(
        'imageSlashPng');

V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum
    _$v1ProvidersMeVerificationPresignPostRequestMimeTypeEnumValueOf(
        String name) {
  switch (name) {
    case 'imageSlashJpeg':
      return _$v1ProvidersMeVerificationPresignPostRequestMimeTypeEnum_imageSlashJpeg;
    case 'imageSlashPng':
      return _$v1ProvidersMeVerificationPresignPostRequestMimeTypeEnum_imageSlashPng;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum>
    _$v1ProvidersMeVerificationPresignPostRequestMimeTypeEnumValues = BuiltSet<
        V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum>(const <V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum>[
  _$v1ProvidersMeVerificationPresignPostRequestMimeTypeEnum_imageSlashJpeg,
  _$v1ProvidersMeVerificationPresignPostRequestMimeTypeEnum_imageSlashPng,
]);

Serializer<V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum>
    _$v1ProvidersMeVerificationPresignPostRequestDocumentTypeEnumSerializer =
    _$V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnumSerializer();
Serializer<V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum>
    _$v1ProvidersMeVerificationPresignPostRequestMimeTypeEnumSerializer =
    _$V1ProvidersMeVerificationPresignPostRequestMimeTypeEnumSerializer();

class _$V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnumSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CIN_FRONT': 'CIN_FRONT',
    'CIN_BACK': 'CIN_BACK',
    'SELFIE_WITH_ID': 'SELFIE_WITH_ID',
    'PATENTE': 'PATENTE',
    'DIPLOMA': 'DIPLOMA',
    'INSURANCE': 'INSURANCE',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CIN_FRONT': 'CIN_FRONT',
    'CIN_BACK': 'CIN_BACK',
    'SELFIE_WITH_ID': 'SELFIE_WITH_ID',
    'PATENTE': 'PATENTE',
    'DIPLOMA': 'DIPLOMA',
    'INSURANCE': 'INSURANCE',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
  ];
  @override
  final String wireName =
      'V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum';

  @override
  Object serialize(Serializers serializers,
          V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ProvidersMeVerificationPresignPostRequestMimeTypeEnumSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'imageSlashJpeg': 'image/jpeg',
    'imageSlashPng': 'image/png',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'image/jpeg': 'imageSlashJpeg',
    'image/png': 'imageSlashPng',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum
  ];
  @override
  final String wireName =
      'V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum';

  @override
  Object serialize(Serializers serializers,
          V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ProvidersMeVerificationPresignPostRequest
    extends V1ProvidersMeVerificationPresignPostRequest {
  @override
  final V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum
      documentType;
  @override
  final V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum mimeType;
  @override
  final int sizeBytes;

  factory _$V1ProvidersMeVerificationPresignPostRequest(
          [void Function(V1ProvidersMeVerificationPresignPostRequestBuilder)?
              updates]) =>
      (V1ProvidersMeVerificationPresignPostRequestBuilder()..update(updates))
          ._build();

  _$V1ProvidersMeVerificationPresignPostRequest._(
      {required this.documentType,
      required this.mimeType,
      required this.sizeBytes})
      : super._();
  @override
  V1ProvidersMeVerificationPresignPostRequest rebuild(
          void Function(V1ProvidersMeVerificationPresignPostRequestBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeVerificationPresignPostRequestBuilder toBuilder() =>
      V1ProvidersMeVerificationPresignPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeVerificationPresignPostRequest &&
        documentType == other.documentType &&
        mimeType == other.mimeType &&
        sizeBytes == other.sizeBytes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, documentType.hashCode);
    _$hash = $jc(_$hash, mimeType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersMeVerificationPresignPostRequest')
          ..add('documentType', documentType)
          ..add('mimeType', mimeType)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class V1ProvidersMeVerificationPresignPostRequestBuilder
    implements
        Builder<V1ProvidersMeVerificationPresignPostRequest,
            V1ProvidersMeVerificationPresignPostRequestBuilder> {
  _$V1ProvidersMeVerificationPresignPostRequest? _$v;

  V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum? _documentType;
  V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum?
      get documentType => _$this._documentType;
  set documentType(
          V1ProvidersMeVerificationPresignPostRequestDocumentTypeEnum?
              documentType) =>
      _$this._documentType = documentType;

  V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum? _mimeType;
  V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum? get mimeType =>
      _$this._mimeType;
  set mimeType(
          V1ProvidersMeVerificationPresignPostRequestMimeTypeEnum? mimeType) =>
      _$this._mimeType = mimeType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  V1ProvidersMeVerificationPresignPostRequestBuilder() {
    V1ProvidersMeVerificationPresignPostRequest._defaults(this);
  }

  V1ProvidersMeVerificationPresignPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _documentType = $v.documentType;
      _mimeType = $v.mimeType;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeVerificationPresignPostRequest other) {
    _$v = other as _$V1ProvidersMeVerificationPresignPostRequest;
  }

  @override
  void update(
      void Function(V1ProvidersMeVerificationPresignPostRequestBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeVerificationPresignPostRequest build() => _build();

  _$V1ProvidersMeVerificationPresignPostRequest _build() {
    final _$result = _$v ??
        _$V1ProvidersMeVerificationPresignPostRequest._(
          documentType: BuiltValueNullFieldError.checkNotNull(documentType,
              r'V1ProvidersMeVerificationPresignPostRequest', 'documentType'),
          mimeType: BuiltValueNullFieldError.checkNotNull(mimeType,
              r'V1ProvidersMeVerificationPresignPostRequest', 'mimeType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(sizeBytes,
              r'V1ProvidersMeVerificationPresignPostRequest', 'sizeBytes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

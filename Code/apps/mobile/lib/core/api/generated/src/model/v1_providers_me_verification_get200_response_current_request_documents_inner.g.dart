// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_verification_get200_response_current_request_documents_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_CIN_FRONT =
    const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
        ._('CIN_FRONT');
const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_CIN_BACK =
    const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
        ._('CIN_BACK');
const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_SELFIE_WITH_ID =
    const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
        ._('SELFIE_WITH_ID');
const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_PATENTE =
    const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
        ._('PATENTE');
const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_DIPLOMA =
    const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
        ._('DIPLOMA');
const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_INSURANCE =
    const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
        ._('INSURANCE');
const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_OTHER =
    const V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
        ._('OTHER');

V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnumValueOf(
        String name) {
  switch (name) {
    case 'CIN_FRONT':
      return _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_CIN_FRONT;
    case 'CIN_BACK':
      return _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_CIN_BACK;
    case 'SELFIE_WITH_ID':
      return _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_SELFIE_WITH_ID;
    case 'PATENTE':
      return _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_PATENTE;
    case 'DIPLOMA':
      return _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_DIPLOMA;
    case 'INSURANCE':
      return _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_INSURANCE;
    case 'OTHER':
      return _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<
        V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum>
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnumValues =
    BuiltSet<
        V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum>(const <V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum>[
  _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_CIN_FRONT,
  _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_CIN_BACK,
  _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_SELFIE_WITH_ID,
  _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_PATENTE,
  _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_DIPLOMA,
  _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_INSURANCE,
  _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum_OTHER,
]);

Serializer<
        V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum>
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnumSerializer =
    _$V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnumSerializer();

class _$V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum> {
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
    V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
  ];
  @override
  final String wireName =
      'V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum';

  @override
  Object serialize(
          Serializers serializers,
          V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
              object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
      deserialize(Serializers serializers, Object serialized,
              {FullType specifiedType = FullType.unspecified}) =>
          V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
              .valueOf(_fromWire[serialized] ??
                  (serialized is String ? serialized : ''));
}

class _$V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner
    extends V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner {
  @override
  final String id;
  @override
  final String mediaId;
  @override
  final V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum
      type;
  @override
  final DateTime createdAt;

  factory _$V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner(
          [void Function(
                  V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerBuilder)?
              updates]) =>
      (V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerBuilder()
            ..update(updates))
          ._build();

  _$V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner._(
      {required this.id,
      required this.mediaId,
      required this.type,
      required this.createdAt})
      : super._();
  @override
  V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner rebuild(
          void Function(
                  V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerBuilder
      toBuilder() =>
          V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerBuilder()
            ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner &&
        id == other.id &&
        mediaId == other.mediaId &&
        type == other.type &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, mediaId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner')
          ..add('id', id)
          ..add('mediaId', mediaId)
          ..add('type', type)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerBuilder
    implements
        Builder<
            V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner,
            V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerBuilder> {
  _$V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _mediaId;
  String? get mediaId => _$this._mediaId;
  set mediaId(String? mediaId) => _$this._mediaId = mediaId;

  V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum?
      _type;
  V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum?
      get type => _$this._type;
  set type(
          V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerTypeEnum?
              type) =>
      _$this._type = type;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerBuilder() {
    V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner
        ._defaults(this);
  }

  V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerBuilder
      get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _mediaId = $v.mediaId;
      _type = $v.type;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
      V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner
          other) {
    _$v = other
        as _$V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner;
  }

  @override
  void update(
      void Function(
              V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner build() =>
      _build();

  _$V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner
      _build() {
    final _$result = _$v ??
        _$V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner',
              'id'),
          mediaId: BuiltValueNullFieldError.checkNotNull(
              mediaId,
              r'V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner',
              'mediaId'),
          type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner',
              'type'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner',
              'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

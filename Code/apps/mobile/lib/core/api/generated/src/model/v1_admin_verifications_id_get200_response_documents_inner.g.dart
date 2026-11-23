// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_admin_verifications_id_get200_response_documents_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
    _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_CIN_FRONT =
    const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum._(
        'CIN_FRONT');
const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
    _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_CIN_BACK =
    const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum._(
        'CIN_BACK');
const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
    _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_SELFIE_WITH_ID =
    const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum._(
        'SELFIE_WITH_ID');
const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
    _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_PATENTE =
    const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum._(
        'PATENTE');
const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
    _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_DIPLOMA =
    const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum._(
        'DIPLOMA');
const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
    _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_INSURANCE =
    const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum._(
        'INSURANCE');
const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
    _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_OTHER =
    const V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum._('OTHER');

V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
    _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnumValueOf(
        String name) {
  switch (name) {
    case 'CIN_FRONT':
      return _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_CIN_FRONT;
    case 'CIN_BACK':
      return _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_CIN_BACK;
    case 'SELFIE_WITH_ID':
      return _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_SELFIE_WITH_ID;
    case 'PATENTE':
      return _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_PATENTE;
    case 'DIPLOMA':
      return _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_DIPLOMA;
    case 'INSURANCE':
      return _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_INSURANCE;
    case 'OTHER':
      return _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum>
    _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnumValues =
    BuiltSet<
        V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum>(const <V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum>[
  _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_CIN_FRONT,
  _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_CIN_BACK,
  _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_SELFIE_WITH_ID,
  _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_PATENTE,
  _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_DIPLOMA,
  _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_INSURANCE,
  _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum_OTHER,
]);

Serializer<V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum>
    _$v1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnumSerializer =
    _$V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnumSerializer();

class _$V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<
            V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum> {
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
    V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum
  ];
  @override
  final String wireName =
      'V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1AdminVerificationsIdGet200ResponseDocumentsInner
    extends V1AdminVerificationsIdGet200ResponseDocumentsInner {
  @override
  final String id;
  @override
  final V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum type;
  @override
  final String mediaId;
  @override
  final String downloadUrl;
  @override
  final DateTime expiresAt;
  @override
  final bool isPurged;

  factory _$V1AdminVerificationsIdGet200ResponseDocumentsInner(
          [void Function(
                  V1AdminVerificationsIdGet200ResponseDocumentsInnerBuilder)?
              updates]) =>
      (V1AdminVerificationsIdGet200ResponseDocumentsInnerBuilder()
            ..update(updates))
          ._build();

  _$V1AdminVerificationsIdGet200ResponseDocumentsInner._(
      {required this.id,
      required this.type,
      required this.mediaId,
      required this.downloadUrl,
      required this.expiresAt,
      required this.isPurged})
      : super._();
  @override
  V1AdminVerificationsIdGet200ResponseDocumentsInner rebuild(
          void Function(
                  V1AdminVerificationsIdGet200ResponseDocumentsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1AdminVerificationsIdGet200ResponseDocumentsInnerBuilder toBuilder() =>
      V1AdminVerificationsIdGet200ResponseDocumentsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AdminVerificationsIdGet200ResponseDocumentsInner &&
        id == other.id &&
        type == other.type &&
        mediaId == other.mediaId &&
        downloadUrl == other.downloadUrl &&
        expiresAt == other.expiresAt &&
        isPurged == other.isPurged;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, mediaId.hashCode);
    _$hash = $jc(_$hash, downloadUrl.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, isPurged.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1AdminVerificationsIdGet200ResponseDocumentsInner')
          ..add('id', id)
          ..add('type', type)
          ..add('mediaId', mediaId)
          ..add('downloadUrl', downloadUrl)
          ..add('expiresAt', expiresAt)
          ..add('isPurged', isPurged))
        .toString();
  }
}

class V1AdminVerificationsIdGet200ResponseDocumentsInnerBuilder
    implements
        Builder<V1AdminVerificationsIdGet200ResponseDocumentsInner,
            V1AdminVerificationsIdGet200ResponseDocumentsInnerBuilder> {
  _$V1AdminVerificationsIdGet200ResponseDocumentsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum? _type;
  V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum? get type =>
      _$this._type;
  set type(V1AdminVerificationsIdGet200ResponseDocumentsInnerTypeEnum? type) =>
      _$this._type = type;

  String? _mediaId;
  String? get mediaId => _$this._mediaId;
  set mediaId(String? mediaId) => _$this._mediaId = mediaId;

  String? _downloadUrl;
  String? get downloadUrl => _$this._downloadUrl;
  set downloadUrl(String? downloadUrl) => _$this._downloadUrl = downloadUrl;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  bool? _isPurged;
  bool? get isPurged => _$this._isPurged;
  set isPurged(bool? isPurged) => _$this._isPurged = isPurged;

  V1AdminVerificationsIdGet200ResponseDocumentsInnerBuilder() {
    V1AdminVerificationsIdGet200ResponseDocumentsInner._defaults(this);
  }

  V1AdminVerificationsIdGet200ResponseDocumentsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _mediaId = $v.mediaId;
      _downloadUrl = $v.downloadUrl;
      _expiresAt = $v.expiresAt;
      _isPurged = $v.isPurged;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AdminVerificationsIdGet200ResponseDocumentsInner other) {
    _$v = other as _$V1AdminVerificationsIdGet200ResponseDocumentsInner;
  }

  @override
  void update(
      void Function(V1AdminVerificationsIdGet200ResponseDocumentsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AdminVerificationsIdGet200ResponseDocumentsInner build() => _build();

  _$V1AdminVerificationsIdGet200ResponseDocumentsInner _build() {
    final _$result = _$v ??
        _$V1AdminVerificationsIdGet200ResponseDocumentsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'V1AdminVerificationsIdGet200ResponseDocumentsInner', 'id'),
          type: BuiltValueNullFieldError.checkNotNull(type,
              r'V1AdminVerificationsIdGet200ResponseDocumentsInner', 'type'),
          mediaId: BuiltValueNullFieldError.checkNotNull(mediaId,
              r'V1AdminVerificationsIdGet200ResponseDocumentsInner', 'mediaId'),
          downloadUrl: BuiltValueNullFieldError.checkNotNull(
              downloadUrl,
              r'V1AdminVerificationsIdGet200ResponseDocumentsInner',
              'downloadUrl'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt,
              r'V1AdminVerificationsIdGet200ResponseDocumentsInner',
              'expiresAt'),
          isPurged: BuiltValueNullFieldError.checkNotNull(
              isPurged,
              r'V1AdminVerificationsIdGet200ResponseDocumentsInner',
              'isPurged'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

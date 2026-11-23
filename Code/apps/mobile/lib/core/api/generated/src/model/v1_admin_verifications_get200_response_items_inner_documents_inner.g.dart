// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_admin_verifications_get200_response_items_inner_documents_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
    _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_CIN_FRONT =
    const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum._(
        'CIN_FRONT');
const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
    _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_CIN_BACK =
    const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum._(
        'CIN_BACK');
const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
    _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_SELFIE_WITH_ID =
    const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum._(
        'SELFIE_WITH_ID');
const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
    _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_PATENTE =
    const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum._(
        'PATENTE');
const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
    _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_DIPLOMA =
    const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum._(
        'DIPLOMA');
const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
    _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_INSURANCE =
    const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum._(
        'INSURANCE');
const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
    _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_OTHER =
    const V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum._(
        'OTHER');

V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
    _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnumValueOf(
        String name) {
  switch (name) {
    case 'CIN_FRONT':
      return _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_CIN_FRONT;
    case 'CIN_BACK':
      return _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_CIN_BACK;
    case 'SELFIE_WITH_ID':
      return _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_SELFIE_WITH_ID;
    case 'PATENTE':
      return _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_PATENTE;
    case 'DIPLOMA':
      return _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_DIPLOMA;
    case 'INSURANCE':
      return _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_INSURANCE;
    case 'OTHER':
      return _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<
        V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum>
    _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnumValues =
    BuiltSet<
        V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum>(const <V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum>[
  _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_CIN_FRONT,
  _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_CIN_BACK,
  _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_SELFIE_WITH_ID,
  _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_PATENTE,
  _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_DIPLOMA,
  _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_INSURANCE,
  _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum_OTHER,
]);

Serializer<V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum>
    _$v1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnumSerializer =
    _$V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnumSerializer();

class _$V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<
            V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum> {
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
    V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
  ];
  @override
  final String wireName =
      'V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum';

  @override
  Object serialize(
          Serializers serializers,
          V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
              object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
      deserialize(Serializers serializers, Object serialized,
              {FullType specifiedType = FullType.unspecified}) =>
          V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum
              .valueOf(_fromWire[serialized] ??
                  (serialized is String ? serialized : ''));
}

class _$V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner
    extends V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner {
  @override
  final String id;
  @override
  final V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum type;

  factory _$V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner(
          [void Function(
                  V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerBuilder)?
              updates]) =>
      (V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerBuilder()
            ..update(updates))
          ._build();

  _$V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner._(
      {required this.id, required this.type})
      : super._();
  @override
  V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner rebuild(
          void Function(
                  V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerBuilder
      toBuilder() =>
          V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerBuilder()
            ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner &&
        id == other.id &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner')
          ..add('id', id)
          ..add('type', type))
        .toString();
  }
}

class V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerBuilder
    implements
        Builder<V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner,
            V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerBuilder> {
  _$V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum? _type;
  V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum?
      get type => _$this._type;
  set type(
          V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerTypeEnum?
              type) =>
      _$this._type = type;

  V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerBuilder() {
    V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner._defaults(this);
  }

  V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
      V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner other) {
    _$v = other as _$V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner;
  }

  @override
  void update(
      void Function(
              V1AdminVerificationsGet200ResponseItemsInnerDocumentsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner build() =>
      _build();

  _$V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner _build() {
    final _$result = _$v ??
        _$V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner',
              'id'),
          type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner',
              'type'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

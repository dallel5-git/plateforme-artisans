// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_users_me_delete_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1UsersMeDeleteRequestConfirmationEnum
    _$v1UsersMeDeleteRequestConfirmationEnum_SUPPRIMER =
    const V1UsersMeDeleteRequestConfirmationEnum._('SUPPRIMER');
const V1UsersMeDeleteRequestConfirmationEnum
    _$v1UsersMeDeleteRequestConfirmationEnum_DELETE =
    const V1UsersMeDeleteRequestConfirmationEnum._('DELETE');

V1UsersMeDeleteRequestConfirmationEnum
    _$v1UsersMeDeleteRequestConfirmationEnumValueOf(String name) {
  switch (name) {
    case 'SUPPRIMER':
      return _$v1UsersMeDeleteRequestConfirmationEnum_SUPPRIMER;
    case 'DELETE':
      return _$v1UsersMeDeleteRequestConfirmationEnum_DELETE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1UsersMeDeleteRequestConfirmationEnum>
    _$v1UsersMeDeleteRequestConfirmationEnumValues = BuiltSet<
        V1UsersMeDeleteRequestConfirmationEnum>(const <V1UsersMeDeleteRequestConfirmationEnum>[
  _$v1UsersMeDeleteRequestConfirmationEnum_SUPPRIMER,
  _$v1UsersMeDeleteRequestConfirmationEnum_DELETE,
]);

Serializer<V1UsersMeDeleteRequestConfirmationEnum>
    _$v1UsersMeDeleteRequestConfirmationEnumSerializer =
    _$V1UsersMeDeleteRequestConfirmationEnumSerializer();

class _$V1UsersMeDeleteRequestConfirmationEnumSerializer
    implements PrimitiveSerializer<V1UsersMeDeleteRequestConfirmationEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SUPPRIMER': 'SUPPRIMER',
    'DELETE': 'DELETE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SUPPRIMER': 'SUPPRIMER',
    'DELETE': 'DELETE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1UsersMeDeleteRequestConfirmationEnum
  ];
  @override
  final String wireName = 'V1UsersMeDeleteRequestConfirmationEnum';

  @override
  Object serialize(Serializers serializers,
          V1UsersMeDeleteRequestConfirmationEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1UsersMeDeleteRequestConfirmationEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1UsersMeDeleteRequestConfirmationEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1UsersMeDeleteRequest extends V1UsersMeDeleteRequest {
  @override
  final V1UsersMeDeleteRequestConfirmationEnum confirmation;
  @override
  final String? reason;

  factory _$V1UsersMeDeleteRequest(
          [void Function(V1UsersMeDeleteRequestBuilder)? updates]) =>
      (V1UsersMeDeleteRequestBuilder()..update(updates))._build();

  _$V1UsersMeDeleteRequest._({required this.confirmation, this.reason})
      : super._();
  @override
  V1UsersMeDeleteRequest rebuild(
          void Function(V1UsersMeDeleteRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1UsersMeDeleteRequestBuilder toBuilder() =>
      V1UsersMeDeleteRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1UsersMeDeleteRequest &&
        confirmation == other.confirmation &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, confirmation.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1UsersMeDeleteRequest')
          ..add('confirmation', confirmation)
          ..add('reason', reason))
        .toString();
  }
}

class V1UsersMeDeleteRequestBuilder
    implements Builder<V1UsersMeDeleteRequest, V1UsersMeDeleteRequestBuilder> {
  _$V1UsersMeDeleteRequest? _$v;

  V1UsersMeDeleteRequestConfirmationEnum? _confirmation;
  V1UsersMeDeleteRequestConfirmationEnum? get confirmation =>
      _$this._confirmation;
  set confirmation(V1UsersMeDeleteRequestConfirmationEnum? confirmation) =>
      _$this._confirmation = confirmation;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  V1UsersMeDeleteRequestBuilder() {
    V1UsersMeDeleteRequest._defaults(this);
  }

  V1UsersMeDeleteRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _confirmation = $v.confirmation;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1UsersMeDeleteRequest other) {
    _$v = other as _$V1UsersMeDeleteRequest;
  }

  @override
  void update(void Function(V1UsersMeDeleteRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1UsersMeDeleteRequest build() => _build();

  _$V1UsersMeDeleteRequest _build() {
    final _$result = _$v ??
        _$V1UsersMeDeleteRequest._(
          confirmation: BuiltValueNullFieldError.checkNotNull(
              confirmation, r'V1UsersMeDeleteRequest', 'confirmation'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

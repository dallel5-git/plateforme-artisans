// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_users_me_delete200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1UsersMeDelete200ResponseStatusEnum
    _$v1UsersMeDelete200ResponseStatusEnum_DELETED =
    const V1UsersMeDelete200ResponseStatusEnum._('DELETED');

V1UsersMeDelete200ResponseStatusEnum
    _$v1UsersMeDelete200ResponseStatusEnumValueOf(String name) {
  switch (name) {
    case 'DELETED':
      return _$v1UsersMeDelete200ResponseStatusEnum_DELETED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1UsersMeDelete200ResponseStatusEnum>
    _$v1UsersMeDelete200ResponseStatusEnumValues = BuiltSet<
        V1UsersMeDelete200ResponseStatusEnum>(const <V1UsersMeDelete200ResponseStatusEnum>[
  _$v1UsersMeDelete200ResponseStatusEnum_DELETED,
]);

Serializer<V1UsersMeDelete200ResponseStatusEnum>
    _$v1UsersMeDelete200ResponseStatusEnumSerializer =
    _$V1UsersMeDelete200ResponseStatusEnumSerializer();

class _$V1UsersMeDelete200ResponseStatusEnumSerializer
    implements PrimitiveSerializer<V1UsersMeDelete200ResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELETED': 'DELETED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELETED': 'DELETED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1UsersMeDelete200ResponseStatusEnum
  ];
  @override
  final String wireName = 'V1UsersMeDelete200ResponseStatusEnum';

  @override
  Object serialize(
          Serializers serializers, V1UsersMeDelete200ResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1UsersMeDelete200ResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1UsersMeDelete200ResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1UsersMeDelete200Response extends V1UsersMeDelete200Response {
  @override
  final bool success;
  @override
  final V1UsersMeDelete200ResponseStatusEnum status;
  @override
  final String message;
  @override
  final DateTime deletedAt;

  factory _$V1UsersMeDelete200Response(
          [void Function(V1UsersMeDelete200ResponseBuilder)? updates]) =>
      (V1UsersMeDelete200ResponseBuilder()..update(updates))._build();

  _$V1UsersMeDelete200Response._(
      {required this.success,
      required this.status,
      required this.message,
      required this.deletedAt})
      : super._();
  @override
  V1UsersMeDelete200Response rebuild(
          void Function(V1UsersMeDelete200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1UsersMeDelete200ResponseBuilder toBuilder() =>
      V1UsersMeDelete200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1UsersMeDelete200Response &&
        success == other.success &&
        status == other.status &&
        message == other.message &&
        deletedAt == other.deletedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, deletedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1UsersMeDelete200Response')
          ..add('success', success)
          ..add('status', status)
          ..add('message', message)
          ..add('deletedAt', deletedAt))
        .toString();
  }
}

class V1UsersMeDelete200ResponseBuilder
    implements
        Builder<V1UsersMeDelete200Response, V1UsersMeDelete200ResponseBuilder> {
  _$V1UsersMeDelete200Response? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  V1UsersMeDelete200ResponseStatusEnum? _status;
  V1UsersMeDelete200ResponseStatusEnum? get status => _$this._status;
  set status(V1UsersMeDelete200ResponseStatusEnum? status) =>
      _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  DateTime? _deletedAt;
  DateTime? get deletedAt => _$this._deletedAt;
  set deletedAt(DateTime? deletedAt) => _$this._deletedAt = deletedAt;

  V1UsersMeDelete200ResponseBuilder() {
    V1UsersMeDelete200Response._defaults(this);
  }

  V1UsersMeDelete200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _status = $v.status;
      _message = $v.message;
      _deletedAt = $v.deletedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1UsersMeDelete200Response other) {
    _$v = other as _$V1UsersMeDelete200Response;
  }

  @override
  void update(void Function(V1UsersMeDelete200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1UsersMeDelete200Response build() => _build();

  _$V1UsersMeDelete200Response _build() {
    final _$result = _$v ??
        _$V1UsersMeDelete200Response._(
          success: BuiltValueNullFieldError.checkNotNull(
              success, r'V1UsersMeDelete200Response', 'success'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'V1UsersMeDelete200Response', 'status'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'V1UsersMeDelete200Response', 'message'),
          deletedAt: BuiltValueNullFieldError.checkNotNull(
              deletedAt, r'V1UsersMeDelete200Response', 'deletedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_health_get503_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1HealthGet503ResponseStatusEnum _$v1HealthGet503ResponseStatusEnum_ok =
    const V1HealthGet503ResponseStatusEnum._('ok');
const V1HealthGet503ResponseStatusEnum
    _$v1HealthGet503ResponseStatusEnum_degraded =
    const V1HealthGet503ResponseStatusEnum._('degraded');

V1HealthGet503ResponseStatusEnum _$v1HealthGet503ResponseStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ok':
      return _$v1HealthGet503ResponseStatusEnum_ok;
    case 'degraded':
      return _$v1HealthGet503ResponseStatusEnum_degraded;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1HealthGet503ResponseStatusEnum>
    _$v1HealthGet503ResponseStatusEnumValues = BuiltSet<
        V1HealthGet503ResponseStatusEnum>(const <V1HealthGet503ResponseStatusEnum>[
  _$v1HealthGet503ResponseStatusEnum_ok,
  _$v1HealthGet503ResponseStatusEnum_degraded,
]);

const V1HealthGet503ResponseDbEnum _$v1HealthGet503ResponseDbEnum_up =
    const V1HealthGet503ResponseDbEnum._('up');
const V1HealthGet503ResponseDbEnum _$v1HealthGet503ResponseDbEnum_down =
    const V1HealthGet503ResponseDbEnum._('down');

V1HealthGet503ResponseDbEnum _$v1HealthGet503ResponseDbEnumValueOf(
    String name) {
  switch (name) {
    case 'up':
      return _$v1HealthGet503ResponseDbEnum_up;
    case 'down':
      return _$v1HealthGet503ResponseDbEnum_down;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1HealthGet503ResponseDbEnum>
    _$v1HealthGet503ResponseDbEnumValues =
    BuiltSet<V1HealthGet503ResponseDbEnum>(const <V1HealthGet503ResponseDbEnum>[
  _$v1HealthGet503ResponseDbEnum_up,
  _$v1HealthGet503ResponseDbEnum_down,
]);

const V1HealthGet503ResponseRedisEnum _$v1HealthGet503ResponseRedisEnum_up =
    const V1HealthGet503ResponseRedisEnum._('up');
const V1HealthGet503ResponseRedisEnum _$v1HealthGet503ResponseRedisEnum_down =
    const V1HealthGet503ResponseRedisEnum._('down');

V1HealthGet503ResponseRedisEnum _$v1HealthGet503ResponseRedisEnumValueOf(
    String name) {
  switch (name) {
    case 'up':
      return _$v1HealthGet503ResponseRedisEnum_up;
    case 'down':
      return _$v1HealthGet503ResponseRedisEnum_down;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1HealthGet503ResponseRedisEnum>
    _$v1HealthGet503ResponseRedisEnumValues = BuiltSet<
        V1HealthGet503ResponseRedisEnum>(const <V1HealthGet503ResponseRedisEnum>[
  _$v1HealthGet503ResponseRedisEnum_up,
  _$v1HealthGet503ResponseRedisEnum_down,
]);

Serializer<V1HealthGet503ResponseStatusEnum>
    _$v1HealthGet503ResponseStatusEnumSerializer =
    _$V1HealthGet503ResponseStatusEnumSerializer();
Serializer<V1HealthGet503ResponseDbEnum>
    _$v1HealthGet503ResponseDbEnumSerializer =
    _$V1HealthGet503ResponseDbEnumSerializer();
Serializer<V1HealthGet503ResponseRedisEnum>
    _$v1HealthGet503ResponseRedisEnumSerializer =
    _$V1HealthGet503ResponseRedisEnumSerializer();

class _$V1HealthGet503ResponseStatusEnumSerializer
    implements PrimitiveSerializer<V1HealthGet503ResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ok': 'ok',
    'degraded': 'degraded',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ok': 'ok',
    'degraded': 'degraded',
  };

  @override
  final Iterable<Type> types = const <Type>[V1HealthGet503ResponseStatusEnum];
  @override
  final String wireName = 'V1HealthGet503ResponseStatusEnum';

  @override
  Object serialize(
          Serializers serializers, V1HealthGet503ResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1HealthGet503ResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1HealthGet503ResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1HealthGet503ResponseDbEnumSerializer
    implements PrimitiveSerializer<V1HealthGet503ResponseDbEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'up': 'up',
    'down': 'down',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'up': 'up',
    'down': 'down',
  };

  @override
  final Iterable<Type> types = const <Type>[V1HealthGet503ResponseDbEnum];
  @override
  final String wireName = 'V1HealthGet503ResponseDbEnum';

  @override
  Object serialize(Serializers serializers, V1HealthGet503ResponseDbEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1HealthGet503ResponseDbEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1HealthGet503ResponseDbEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1HealthGet503ResponseRedisEnumSerializer
    implements PrimitiveSerializer<V1HealthGet503ResponseRedisEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'up': 'up',
    'down': 'down',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'up': 'up',
    'down': 'down',
  };

  @override
  final Iterable<Type> types = const <Type>[V1HealthGet503ResponseRedisEnum];
  @override
  final String wireName = 'V1HealthGet503ResponseRedisEnum';

  @override
  Object serialize(
          Serializers serializers, V1HealthGet503ResponseRedisEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1HealthGet503ResponseRedisEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1HealthGet503ResponseRedisEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1HealthGet503Response extends V1HealthGet503Response {
  @override
  final V1HealthGet503ResponseStatusEnum status;
  @override
  final V1HealthGet503ResponseDbEnum db;
  @override
  final V1HealthGet503ResponseRedisEnum redis;

  factory _$V1HealthGet503Response(
          [void Function(V1HealthGet503ResponseBuilder)? updates]) =>
      (V1HealthGet503ResponseBuilder()..update(updates))._build();

  _$V1HealthGet503Response._(
      {required this.status, required this.db, required this.redis})
      : super._();
  @override
  V1HealthGet503Response rebuild(
          void Function(V1HealthGet503ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1HealthGet503ResponseBuilder toBuilder() =>
      V1HealthGet503ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1HealthGet503Response &&
        status == other.status &&
        db == other.db &&
        redis == other.redis;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, db.hashCode);
    _$hash = $jc(_$hash, redis.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1HealthGet503Response')
          ..add('status', status)
          ..add('db', db)
          ..add('redis', redis))
        .toString();
  }
}

class V1HealthGet503ResponseBuilder
    implements Builder<V1HealthGet503Response, V1HealthGet503ResponseBuilder> {
  _$V1HealthGet503Response? _$v;

  V1HealthGet503ResponseStatusEnum? _status;
  V1HealthGet503ResponseStatusEnum? get status => _$this._status;
  set status(V1HealthGet503ResponseStatusEnum? status) =>
      _$this._status = status;

  V1HealthGet503ResponseDbEnum? _db;
  V1HealthGet503ResponseDbEnum? get db => _$this._db;
  set db(V1HealthGet503ResponseDbEnum? db) => _$this._db = db;

  V1HealthGet503ResponseRedisEnum? _redis;
  V1HealthGet503ResponseRedisEnum? get redis => _$this._redis;
  set redis(V1HealthGet503ResponseRedisEnum? redis) => _$this._redis = redis;

  V1HealthGet503ResponseBuilder() {
    V1HealthGet503Response._defaults(this);
  }

  V1HealthGet503ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _db = $v.db;
      _redis = $v.redis;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1HealthGet503Response other) {
    _$v = other as _$V1HealthGet503Response;
  }

  @override
  void update(void Function(V1HealthGet503ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1HealthGet503Response build() => _build();

  _$V1HealthGet503Response _build() {
    final _$result = _$v ??
        _$V1HealthGet503Response._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'V1HealthGet503Response', 'status'),
          db: BuiltValueNullFieldError.checkNotNull(
              db, r'V1HealthGet503Response', 'db'),
          redis: BuiltValueNullFieldError.checkNotNull(
              redis, r'V1HealthGet503Response', 'redis'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

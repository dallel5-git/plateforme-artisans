// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_health_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1HealthGet200ResponseStatusEnum _$v1HealthGet200ResponseStatusEnum_ok =
    const V1HealthGet200ResponseStatusEnum._('ok');
const V1HealthGet200ResponseStatusEnum
_$v1HealthGet200ResponseStatusEnum_degraded =
    const V1HealthGet200ResponseStatusEnum._('degraded');

V1HealthGet200ResponseStatusEnum _$v1HealthGet200ResponseStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'ok':
      return _$v1HealthGet200ResponseStatusEnum_ok;
    case 'degraded':
      return _$v1HealthGet200ResponseStatusEnum_degraded;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1HealthGet200ResponseStatusEnum>
_$v1HealthGet200ResponseStatusEnumValues =
    BuiltSet<V1HealthGet200ResponseStatusEnum>(
      const <V1HealthGet200ResponseStatusEnum>[
        _$v1HealthGet200ResponseStatusEnum_ok,
        _$v1HealthGet200ResponseStatusEnum_degraded,
      ],
    );

const V1HealthGet200ResponseDbEnum _$v1HealthGet200ResponseDbEnum_up =
    const V1HealthGet200ResponseDbEnum._('up');
const V1HealthGet200ResponseDbEnum _$v1HealthGet200ResponseDbEnum_down =
    const V1HealthGet200ResponseDbEnum._('down');

V1HealthGet200ResponseDbEnum _$v1HealthGet200ResponseDbEnumValueOf(
  String name,
) {
  switch (name) {
    case 'up':
      return _$v1HealthGet200ResponseDbEnum_up;
    case 'down':
      return _$v1HealthGet200ResponseDbEnum_down;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1HealthGet200ResponseDbEnum>
_$v1HealthGet200ResponseDbEnumValues = BuiltSet<V1HealthGet200ResponseDbEnum>(
  const <V1HealthGet200ResponseDbEnum>[
    _$v1HealthGet200ResponseDbEnum_up,
    _$v1HealthGet200ResponseDbEnum_down,
  ],
);

const V1HealthGet200ResponseRedisEnum _$v1HealthGet200ResponseRedisEnum_up =
    const V1HealthGet200ResponseRedisEnum._('up');
const V1HealthGet200ResponseRedisEnum _$v1HealthGet200ResponseRedisEnum_down =
    const V1HealthGet200ResponseRedisEnum._('down');

V1HealthGet200ResponseRedisEnum _$v1HealthGet200ResponseRedisEnumValueOf(
  String name,
) {
  switch (name) {
    case 'up':
      return _$v1HealthGet200ResponseRedisEnum_up;
    case 'down':
      return _$v1HealthGet200ResponseRedisEnum_down;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1HealthGet200ResponseRedisEnum>
_$v1HealthGet200ResponseRedisEnumValues =
    BuiltSet<V1HealthGet200ResponseRedisEnum>(
      const <V1HealthGet200ResponseRedisEnum>[
        _$v1HealthGet200ResponseRedisEnum_up,
        _$v1HealthGet200ResponseRedisEnum_down,
      ],
    );

Serializer<V1HealthGet200ResponseStatusEnum>
_$v1HealthGet200ResponseStatusEnumSerializer =
    _$V1HealthGet200ResponseStatusEnumSerializer();
Serializer<V1HealthGet200ResponseDbEnum>
_$v1HealthGet200ResponseDbEnumSerializer =
    _$V1HealthGet200ResponseDbEnumSerializer();
Serializer<V1HealthGet200ResponseRedisEnum>
_$v1HealthGet200ResponseRedisEnumSerializer =
    _$V1HealthGet200ResponseRedisEnumSerializer();

class _$V1HealthGet200ResponseStatusEnumSerializer
    implements PrimitiveSerializer<V1HealthGet200ResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ok': 'ok',
    'degraded': 'degraded',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ok': 'ok',
    'degraded': 'degraded',
  };

  @override
  final Iterable<Type> types = const <Type>[V1HealthGet200ResponseStatusEnum];
  @override
  final String wireName = 'V1HealthGet200ResponseStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    V1HealthGet200ResponseStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  V1HealthGet200ResponseStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => V1HealthGet200ResponseStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$V1HealthGet200ResponseDbEnumSerializer
    implements PrimitiveSerializer<V1HealthGet200ResponseDbEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'up': 'up',
    'down': 'down',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'up': 'up',
    'down': 'down',
  };

  @override
  final Iterable<Type> types = const <Type>[V1HealthGet200ResponseDbEnum];
  @override
  final String wireName = 'V1HealthGet200ResponseDbEnum';

  @override
  Object serialize(
    Serializers serializers,
    V1HealthGet200ResponseDbEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  V1HealthGet200ResponseDbEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => V1HealthGet200ResponseDbEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$V1HealthGet200ResponseRedisEnumSerializer
    implements PrimitiveSerializer<V1HealthGet200ResponseRedisEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'up': 'up',
    'down': 'down',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'up': 'up',
    'down': 'down',
  };

  @override
  final Iterable<Type> types = const <Type>[V1HealthGet200ResponseRedisEnum];
  @override
  final String wireName = 'V1HealthGet200ResponseRedisEnum';

  @override
  Object serialize(
    Serializers serializers,
    V1HealthGet200ResponseRedisEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  V1HealthGet200ResponseRedisEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => V1HealthGet200ResponseRedisEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$V1HealthGet200Response extends V1HealthGet200Response {
  @override
  final V1HealthGet200ResponseStatusEnum status;
  @override
  final V1HealthGet200ResponseDbEnum db;
  @override
  final V1HealthGet200ResponseRedisEnum redis;

  factory _$V1HealthGet200Response([
    void Function(V1HealthGet200ResponseBuilder)? updates,
  ]) => (V1HealthGet200ResponseBuilder()..update(updates))._build();

  _$V1HealthGet200Response._({
    required this.status,
    required this.db,
    required this.redis,
  }) : super._();
  @override
  V1HealthGet200Response rebuild(
    void Function(V1HealthGet200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1HealthGet200ResponseBuilder toBuilder() =>
      V1HealthGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1HealthGet200Response &&
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
    return (newBuiltValueToStringHelper(r'V1HealthGet200Response')
          ..add('status', status)
          ..add('db', db)
          ..add('redis', redis))
        .toString();
  }
}

class V1HealthGet200ResponseBuilder
    implements Builder<V1HealthGet200Response, V1HealthGet200ResponseBuilder> {
  _$V1HealthGet200Response? _$v;

  V1HealthGet200ResponseStatusEnum? _status;
  V1HealthGet200ResponseStatusEnum? get status => _$this._status;
  set status(V1HealthGet200ResponseStatusEnum? status) =>
      _$this._status = status;

  V1HealthGet200ResponseDbEnum? _db;
  V1HealthGet200ResponseDbEnum? get db => _$this._db;
  set db(V1HealthGet200ResponseDbEnum? db) => _$this._db = db;

  V1HealthGet200ResponseRedisEnum? _redis;
  V1HealthGet200ResponseRedisEnum? get redis => _$this._redis;
  set redis(V1HealthGet200ResponseRedisEnum? redis) => _$this._redis = redis;

  V1HealthGet200ResponseBuilder() {
    V1HealthGet200Response._defaults(this);
  }

  V1HealthGet200ResponseBuilder get _$this {
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
  void replace(V1HealthGet200Response other) {
    _$v = other as _$V1HealthGet200Response;
  }

  @override
  void update(void Function(V1HealthGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1HealthGet200Response build() => _build();

  _$V1HealthGet200Response _build() {
    final _$result =
        _$v ??
        _$V1HealthGet200Response._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'V1HealthGet200Response',
            'status',
          ),
          db: BuiltValueNullFieldError.checkNotNull(
            db,
            r'V1HealthGet200Response',
            'db',
          ),
          redis: BuiltValueNullFieldError.checkNotNull(
            redis,
            r'V1HealthGet200Response',
            'redis',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

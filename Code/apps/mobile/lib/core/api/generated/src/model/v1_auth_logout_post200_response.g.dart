// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_auth_logout_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1AuthLogoutPost200ResponseStatusEnum
_$v1AuthLogoutPost200ResponseStatusEnum_ok =
    const V1AuthLogoutPost200ResponseStatusEnum._('ok');

V1AuthLogoutPost200ResponseStatusEnum
_$v1AuthLogoutPost200ResponseStatusEnumValueOf(String name) {
  switch (name) {
    case 'ok':
      return _$v1AuthLogoutPost200ResponseStatusEnum_ok;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1AuthLogoutPost200ResponseStatusEnum>
_$v1AuthLogoutPost200ResponseStatusEnumValues =
    BuiltSet<V1AuthLogoutPost200ResponseStatusEnum>(
      const <V1AuthLogoutPost200ResponseStatusEnum>[
        _$v1AuthLogoutPost200ResponseStatusEnum_ok,
      ],
    );

Serializer<V1AuthLogoutPost200ResponseStatusEnum>
_$v1AuthLogoutPost200ResponseStatusEnumSerializer =
    _$V1AuthLogoutPost200ResponseStatusEnumSerializer();

class _$V1AuthLogoutPost200ResponseStatusEnumSerializer
    implements PrimitiveSerializer<V1AuthLogoutPost200ResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ok': 'ok',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ok': 'ok',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1AuthLogoutPost200ResponseStatusEnum,
  ];
  @override
  final String wireName = 'V1AuthLogoutPost200ResponseStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    V1AuthLogoutPost200ResponseStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  V1AuthLogoutPost200ResponseStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => V1AuthLogoutPost200ResponseStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$V1AuthLogoutPost200Response extends V1AuthLogoutPost200Response {
  @override
  final V1AuthLogoutPost200ResponseStatusEnum status;

  factory _$V1AuthLogoutPost200Response([
    void Function(V1AuthLogoutPost200ResponseBuilder)? updates,
  ]) => (V1AuthLogoutPost200ResponseBuilder()..update(updates))._build();

  _$V1AuthLogoutPost200Response._({required this.status}) : super._();
  @override
  V1AuthLogoutPost200Response rebuild(
    void Function(V1AuthLogoutPost200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1AuthLogoutPost200ResponseBuilder toBuilder() =>
      V1AuthLogoutPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AuthLogoutPost200Response && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'V1AuthLogoutPost200Response',
    )..add('status', status)).toString();
  }
}

class V1AuthLogoutPost200ResponseBuilder
    implements
        Builder<
          V1AuthLogoutPost200Response,
          V1AuthLogoutPost200ResponseBuilder
        > {
  _$V1AuthLogoutPost200Response? _$v;

  V1AuthLogoutPost200ResponseStatusEnum? _status;
  V1AuthLogoutPost200ResponseStatusEnum? get status => _$this._status;
  set status(V1AuthLogoutPost200ResponseStatusEnum? status) =>
      _$this._status = status;

  V1AuthLogoutPost200ResponseBuilder() {
    V1AuthLogoutPost200Response._defaults(this);
  }

  V1AuthLogoutPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AuthLogoutPost200Response other) {
    _$v = other as _$V1AuthLogoutPost200Response;
  }

  @override
  void update(void Function(V1AuthLogoutPost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AuthLogoutPost200Response build() => _build();

  _$V1AuthLogoutPost200Response _build() {
    final _$result =
        _$v ??
        _$V1AuthLogoutPost200Response._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'V1AuthLogoutPost200Response',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

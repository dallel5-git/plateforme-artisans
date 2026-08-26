// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_auth_otp_request_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1AuthOtpRequestPost200ResponseStatusEnum
    _$v1AuthOtpRequestPost200ResponseStatusEnum_sent =
    const V1AuthOtpRequestPost200ResponseStatusEnum._('sent');

V1AuthOtpRequestPost200ResponseStatusEnum
    _$v1AuthOtpRequestPost200ResponseStatusEnumValueOf(String name) {
  switch (name) {
    case 'sent':
      return _$v1AuthOtpRequestPost200ResponseStatusEnum_sent;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1AuthOtpRequestPost200ResponseStatusEnum>
    _$v1AuthOtpRequestPost200ResponseStatusEnumValues = BuiltSet<
        V1AuthOtpRequestPost200ResponseStatusEnum>(const <V1AuthOtpRequestPost200ResponseStatusEnum>[
  _$v1AuthOtpRequestPost200ResponseStatusEnum_sent,
]);

Serializer<V1AuthOtpRequestPost200ResponseStatusEnum>
    _$v1AuthOtpRequestPost200ResponseStatusEnumSerializer =
    _$V1AuthOtpRequestPost200ResponseStatusEnumSerializer();

class _$V1AuthOtpRequestPost200ResponseStatusEnumSerializer
    implements PrimitiveSerializer<V1AuthOtpRequestPost200ResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'sent': 'sent',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'sent': 'sent',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1AuthOtpRequestPost200ResponseStatusEnum
  ];
  @override
  final String wireName = 'V1AuthOtpRequestPost200ResponseStatusEnum';

  @override
  Object serialize(Serializers serializers,
          V1AuthOtpRequestPost200ResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1AuthOtpRequestPost200ResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1AuthOtpRequestPost200ResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1AuthOtpRequestPost200Response
    extends V1AuthOtpRequestPost200Response {
  @override
  final V1AuthOtpRequestPost200ResponseStatusEnum status;

  factory _$V1AuthOtpRequestPost200Response(
          [void Function(V1AuthOtpRequestPost200ResponseBuilder)? updates]) =>
      (V1AuthOtpRequestPost200ResponseBuilder()..update(updates))._build();

  _$V1AuthOtpRequestPost200Response._({required this.status}) : super._();
  @override
  V1AuthOtpRequestPost200Response rebuild(
          void Function(V1AuthOtpRequestPost200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1AuthOtpRequestPost200ResponseBuilder toBuilder() =>
      V1AuthOtpRequestPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AuthOtpRequestPost200Response && status == other.status;
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
    return (newBuiltValueToStringHelper(r'V1AuthOtpRequestPost200Response')
          ..add('status', status))
        .toString();
  }
}

class V1AuthOtpRequestPost200ResponseBuilder
    implements
        Builder<V1AuthOtpRequestPost200Response,
            V1AuthOtpRequestPost200ResponseBuilder> {
  _$V1AuthOtpRequestPost200Response? _$v;

  V1AuthOtpRequestPost200ResponseStatusEnum? _status;
  V1AuthOtpRequestPost200ResponseStatusEnum? get status => _$this._status;
  set status(V1AuthOtpRequestPost200ResponseStatusEnum? status) =>
      _$this._status = status;

  V1AuthOtpRequestPost200ResponseBuilder() {
    V1AuthOtpRequestPost200Response._defaults(this);
  }

  V1AuthOtpRequestPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AuthOtpRequestPost200Response other) {
    _$v = other as _$V1AuthOtpRequestPost200Response;
  }

  @override
  void update(void Function(V1AuthOtpRequestPost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AuthOtpRequestPost200Response build() => _build();

  _$V1AuthOtpRequestPost200Response _build() {
    final _$result = _$v ??
        _$V1AuthOtpRequestPost200Response._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'V1AuthOtpRequestPost200Response', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

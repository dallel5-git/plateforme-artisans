// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_verification_submit_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum
    _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_NOT_SUBMITTED =
    const V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum._(
        'NOT_SUBMITTED');
const V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum
    _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_PENDING =
    const V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum._('PENDING');
const V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum
    _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_MORE_INFO_REQUIRED =
    const V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum._(
        'MORE_INFO_REQUIRED');
const V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum
    _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_APPROVED =
    const V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum._(
        'APPROVED');
const V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum
    _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_REJECTED =
    const V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum._(
        'REJECTED');

V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum
    _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'NOT_SUBMITTED':
      return _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_NOT_SUBMITTED;
    case 'PENDING':
      return _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_PENDING;
    case 'MORE_INFO_REQUIRED':
      return _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_MORE_INFO_REQUIRED;
    case 'APPROVED':
      return _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_APPROVED;
    case 'REJECTED':
      return _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum>
    _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnumValues = BuiltSet<
        V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum>(const <V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum>[
  _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_NOT_SUBMITTED,
  _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_PENDING,
  _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_MORE_INFO_REQUIRED,
  _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_APPROVED,
  _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnum_REJECTED,
]);

Serializer<V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum>
    _$v1ProvidersMeVerificationSubmitPost200ResponseStatusEnumSerializer =
    _$V1ProvidersMeVerificationSubmitPost200ResponseStatusEnumSerializer();

class _$V1ProvidersMeVerificationSubmitPost200ResponseStatusEnumSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_SUBMITTED': 'NOT_SUBMITTED',
    'PENDING': 'PENDING',
    'MORE_INFO_REQUIRED': 'MORE_INFO_REQUIRED',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_SUBMITTED': 'NOT_SUBMITTED',
    'PENDING': 'PENDING',
    'MORE_INFO_REQUIRED': 'MORE_INFO_REQUIRED',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum
  ];
  @override
  final String wireName =
      'V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum';

  @override
  Object serialize(Serializers serializers,
          V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ProvidersMeVerificationSubmitPost200Response
    extends V1ProvidersMeVerificationSubmitPost200Response {
  @override
  final String requestId;
  @override
  final V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum status;
  @override
  final DateTime submittedAt;

  factory _$V1ProvidersMeVerificationSubmitPost200Response(
          [void Function(V1ProvidersMeVerificationSubmitPost200ResponseBuilder)?
              updates]) =>
      (V1ProvidersMeVerificationSubmitPost200ResponseBuilder()..update(updates))
          ._build();

  _$V1ProvidersMeVerificationSubmitPost200Response._(
      {required this.requestId,
      required this.status,
      required this.submittedAt})
      : super._();
  @override
  V1ProvidersMeVerificationSubmitPost200Response rebuild(
          void Function(V1ProvidersMeVerificationSubmitPost200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeVerificationSubmitPost200ResponseBuilder toBuilder() =>
      V1ProvidersMeVerificationSubmitPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeVerificationSubmitPost200Response &&
        requestId == other.requestId &&
        status == other.status &&
        submittedAt == other.submittedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, requestId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersMeVerificationSubmitPost200Response')
          ..add('requestId', requestId)
          ..add('status', status)
          ..add('submittedAt', submittedAt))
        .toString();
  }
}

class V1ProvidersMeVerificationSubmitPost200ResponseBuilder
    implements
        Builder<V1ProvidersMeVerificationSubmitPost200Response,
            V1ProvidersMeVerificationSubmitPost200ResponseBuilder> {
  _$V1ProvidersMeVerificationSubmitPost200Response? _$v;

  String? _requestId;
  String? get requestId => _$this._requestId;
  set requestId(String? requestId) => _$this._requestId = requestId;

  V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum? _status;
  V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum? get status =>
      _$this._status;
  set status(
          V1ProvidersMeVerificationSubmitPost200ResponseStatusEnum? status) =>
      _$this._status = status;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  V1ProvidersMeVerificationSubmitPost200ResponseBuilder() {
    V1ProvidersMeVerificationSubmitPost200Response._defaults(this);
  }

  V1ProvidersMeVerificationSubmitPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _requestId = $v.requestId;
      _status = $v.status;
      _submittedAt = $v.submittedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeVerificationSubmitPost200Response other) {
    _$v = other as _$V1ProvidersMeVerificationSubmitPost200Response;
  }

  @override
  void update(
      void Function(V1ProvidersMeVerificationSubmitPost200ResponseBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeVerificationSubmitPost200Response build() => _build();

  _$V1ProvidersMeVerificationSubmitPost200Response _build() {
    final _$result = _$v ??
        _$V1ProvidersMeVerificationSubmitPost200Response._(
          requestId: BuiltValueNullFieldError.checkNotNull(requestId,
              r'V1ProvidersMeVerificationSubmitPost200Response', 'requestId'),
          status: BuiltValueNullFieldError.checkNotNull(status,
              r'V1ProvidersMeVerificationSubmitPost200Response', 'status'),
          submittedAt: BuiltValueNullFieldError.checkNotNull(submittedAt,
              r'V1ProvidersMeVerificationSubmitPost200Response', 'submittedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_verification_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
    _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_NOT_SUBMITTED =
    const V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum._(
        'NOT_SUBMITTED');
const V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
    _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_PENDING =
    const V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum._(
        'PENDING');
const V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
    _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_MORE_INFO_REQUIRED =
    const V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum._(
        'MORE_INFO_REQUIRED');
const V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
    _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_APPROVED =
    const V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum._(
        'APPROVED');
const V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
    _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_REJECTED =
    const V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum._(
        'REJECTED');

V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
    _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'NOT_SUBMITTED':
      return _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_NOT_SUBMITTED;
    case 'PENDING':
      return _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_PENDING;
    case 'MORE_INFO_REQUIRED':
      return _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_MORE_INFO_REQUIRED;
    case 'APPROVED':
      return _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_APPROVED;
    case 'REJECTED':
      return _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum>
    _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnumValues =
    BuiltSet<
        V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum>(const <V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum>[
  _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_NOT_SUBMITTED,
  _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_PENDING,
  _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_MORE_INFO_REQUIRED,
  _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_APPROVED,
  _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnum_REJECTED,
]);

Serializer<V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum>
    _$v1ProvidersMeVerificationGet200ResponseVerificationStatusEnumSerializer =
    _$V1ProvidersMeVerificationGet200ResponseVerificationStatusEnumSerializer();

class _$V1ProvidersMeVerificationGet200ResponseVerificationStatusEnumSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum> {
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
    V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
  ];
  @override
  final String wireName =
      'V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum';

  @override
  Object serialize(Serializers serializers,
          V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ProvidersMeVerificationGet200Response
    extends V1ProvidersMeVerificationGet200Response {
  @override
  final V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum
      verificationStatus;
  @override
  final bool isVerified;
  @override
  final V1ProvidersMeVerificationGet200ResponseCurrentRequest currentRequest;

  factory _$V1ProvidersMeVerificationGet200Response(
          [void Function(V1ProvidersMeVerificationGet200ResponseBuilder)?
              updates]) =>
      (V1ProvidersMeVerificationGet200ResponseBuilder()..update(updates))
          ._build();

  _$V1ProvidersMeVerificationGet200Response._(
      {required this.verificationStatus,
      required this.isVerified,
      required this.currentRequest})
      : super._();
  @override
  V1ProvidersMeVerificationGet200Response rebuild(
          void Function(V1ProvidersMeVerificationGet200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeVerificationGet200ResponseBuilder toBuilder() =>
      V1ProvidersMeVerificationGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeVerificationGet200Response &&
        verificationStatus == other.verificationStatus &&
        isVerified == other.isVerified &&
        currentRequest == other.currentRequest;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, verificationStatus.hashCode);
    _$hash = $jc(_$hash, isVerified.hashCode);
    _$hash = $jc(_$hash, currentRequest.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersMeVerificationGet200Response')
          ..add('verificationStatus', verificationStatus)
          ..add('isVerified', isVerified)
          ..add('currentRequest', currentRequest))
        .toString();
  }
}

class V1ProvidersMeVerificationGet200ResponseBuilder
    implements
        Builder<V1ProvidersMeVerificationGet200Response,
            V1ProvidersMeVerificationGet200ResponseBuilder> {
  _$V1ProvidersMeVerificationGet200Response? _$v;

  V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum?
      _verificationStatus;
  V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum?
      get verificationStatus => _$this._verificationStatus;
  set verificationStatus(
          V1ProvidersMeVerificationGet200ResponseVerificationStatusEnum?
              verificationStatus) =>
      _$this._verificationStatus = verificationStatus;

  bool? _isVerified;
  bool? get isVerified => _$this._isVerified;
  set isVerified(bool? isVerified) => _$this._isVerified = isVerified;

  V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder? _currentRequest;
  V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder
      get currentRequest => _$this._currentRequest ??=
          V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder();
  set currentRequest(
          V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder?
              currentRequest) =>
      _$this._currentRequest = currentRequest;

  V1ProvidersMeVerificationGet200ResponseBuilder() {
    V1ProvidersMeVerificationGet200Response._defaults(this);
  }

  V1ProvidersMeVerificationGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _verificationStatus = $v.verificationStatus;
      _isVerified = $v.isVerified;
      _currentRequest = $v.currentRequest.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeVerificationGet200Response other) {
    _$v = other as _$V1ProvidersMeVerificationGet200Response;
  }

  @override
  void update(
      void Function(V1ProvidersMeVerificationGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeVerificationGet200Response build() => _build();

  _$V1ProvidersMeVerificationGet200Response _build() {
    _$V1ProvidersMeVerificationGet200Response _$result;
    try {
      _$result = _$v ??
          _$V1ProvidersMeVerificationGet200Response._(
            verificationStatus: BuiltValueNullFieldError.checkNotNull(
                verificationStatus,
                r'V1ProvidersMeVerificationGet200Response',
                'verificationStatus'),
            isVerified: BuiltValueNullFieldError.checkNotNull(isVerified,
                r'V1ProvidersMeVerificationGet200Response', 'isVerified'),
            currentRequest: currentRequest.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'currentRequest';
        currentRequest.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1ProvidersMeVerificationGet200Response',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

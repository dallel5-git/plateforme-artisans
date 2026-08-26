// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_auth_otp_verify_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1AuthOtpVerifyPostRequest extends V1AuthOtpVerifyPostRequest {
  @override
  final String phone;
  @override
  final String code;

  factory _$V1AuthOtpVerifyPostRequest(
          [void Function(V1AuthOtpVerifyPostRequestBuilder)? updates]) =>
      (V1AuthOtpVerifyPostRequestBuilder()..update(updates))._build();

  _$V1AuthOtpVerifyPostRequest._({required this.phone, required this.code})
      : super._();
  @override
  V1AuthOtpVerifyPostRequest rebuild(
          void Function(V1AuthOtpVerifyPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1AuthOtpVerifyPostRequestBuilder toBuilder() =>
      V1AuthOtpVerifyPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AuthOtpVerifyPostRequest &&
        phone == other.phone &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1AuthOtpVerifyPostRequest')
          ..add('phone', phone)
          ..add('code', code))
        .toString();
  }
}

class V1AuthOtpVerifyPostRequestBuilder
    implements
        Builder<V1AuthOtpVerifyPostRequest, V1AuthOtpVerifyPostRequestBuilder> {
  _$V1AuthOtpVerifyPostRequest? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  V1AuthOtpVerifyPostRequestBuilder() {
    V1AuthOtpVerifyPostRequest._defaults(this);
  }

  V1AuthOtpVerifyPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AuthOtpVerifyPostRequest other) {
    _$v = other as _$V1AuthOtpVerifyPostRequest;
  }

  @override
  void update(void Function(V1AuthOtpVerifyPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AuthOtpVerifyPostRequest build() => _build();

  _$V1AuthOtpVerifyPostRequest _build() {
    final _$result = _$v ??
        _$V1AuthOtpVerifyPostRequest._(
          phone: BuiltValueNullFieldError.checkNotNull(
              phone, r'V1AuthOtpVerifyPostRequest', 'phone'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'V1AuthOtpVerifyPostRequest', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

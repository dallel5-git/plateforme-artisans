// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_auth_otp_request_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1AuthOtpRequestPostRequest extends V1AuthOtpRequestPostRequest {
  @override
  final String phone;

  factory _$V1AuthOtpRequestPostRequest([
    void Function(V1AuthOtpRequestPostRequestBuilder)? updates,
  ]) => (V1AuthOtpRequestPostRequestBuilder()..update(updates))._build();

  _$V1AuthOtpRequestPostRequest._({required this.phone}) : super._();
  @override
  V1AuthOtpRequestPostRequest rebuild(
    void Function(V1AuthOtpRequestPostRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1AuthOtpRequestPostRequestBuilder toBuilder() =>
      V1AuthOtpRequestPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AuthOtpRequestPostRequest && phone == other.phone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'V1AuthOtpRequestPostRequest',
    )..add('phone', phone)).toString();
  }
}

class V1AuthOtpRequestPostRequestBuilder
    implements
        Builder<
          V1AuthOtpRequestPostRequest,
          V1AuthOtpRequestPostRequestBuilder
        > {
  _$V1AuthOtpRequestPostRequest? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  V1AuthOtpRequestPostRequestBuilder() {
    V1AuthOtpRequestPostRequest._defaults(this);
  }

  V1AuthOtpRequestPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AuthOtpRequestPostRequest other) {
    _$v = other as _$V1AuthOtpRequestPostRequest;
  }

  @override
  void update(void Function(V1AuthOtpRequestPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AuthOtpRequestPostRequest build() => _build();

  _$V1AuthOtpRequestPostRequest _build() {
    final _$result =
        _$v ??
        _$V1AuthOtpRequestPostRequest._(
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'V1AuthOtpRequestPostRequest',
            'phone',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

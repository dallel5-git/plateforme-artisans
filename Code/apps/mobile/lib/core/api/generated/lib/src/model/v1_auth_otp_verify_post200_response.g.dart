// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_auth_otp_verify_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1AuthOtpVerifyPost200Response extends V1AuthOtpVerifyPost200Response {
  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final V1AuthOtpVerifyPost200ResponseUser user;

  factory _$V1AuthOtpVerifyPost200Response(
          [void Function(V1AuthOtpVerifyPost200ResponseBuilder)? updates]) =>
      (V1AuthOtpVerifyPost200ResponseBuilder()..update(updates))._build();

  _$V1AuthOtpVerifyPost200Response._(
      {required this.accessToken,
      required this.refreshToken,
      required this.user})
      : super._();
  @override
  V1AuthOtpVerifyPost200Response rebuild(
          void Function(V1AuthOtpVerifyPost200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1AuthOtpVerifyPost200ResponseBuilder toBuilder() =>
      V1AuthOtpVerifyPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AuthOtpVerifyPost200Response &&
        accessToken == other.accessToken &&
        refreshToken == other.refreshToken &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1AuthOtpVerifyPost200Response')
          ..add('accessToken', accessToken)
          ..add('refreshToken', refreshToken)
          ..add('user', user))
        .toString();
  }
}

class V1AuthOtpVerifyPost200ResponseBuilder
    implements
        Builder<V1AuthOtpVerifyPost200Response,
            V1AuthOtpVerifyPost200ResponseBuilder> {
  _$V1AuthOtpVerifyPost200Response? _$v;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  V1AuthOtpVerifyPost200ResponseUserBuilder? _user;
  V1AuthOtpVerifyPost200ResponseUserBuilder get user =>
      _$this._user ??= V1AuthOtpVerifyPost200ResponseUserBuilder();
  set user(V1AuthOtpVerifyPost200ResponseUserBuilder? user) =>
      _$this._user = user;

  V1AuthOtpVerifyPost200ResponseBuilder() {
    V1AuthOtpVerifyPost200Response._defaults(this);
  }

  V1AuthOtpVerifyPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessToken = $v.accessToken;
      _refreshToken = $v.refreshToken;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AuthOtpVerifyPost200Response other) {
    _$v = other as _$V1AuthOtpVerifyPost200Response;
  }

  @override
  void update(void Function(V1AuthOtpVerifyPost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AuthOtpVerifyPost200Response build() => _build();

  _$V1AuthOtpVerifyPost200Response _build() {
    _$V1AuthOtpVerifyPost200Response _$result;
    try {
      _$result = _$v ??
          _$V1AuthOtpVerifyPost200Response._(
            accessToken: BuiltValueNullFieldError.checkNotNull(
                accessToken, r'V1AuthOtpVerifyPost200Response', 'accessToken'),
            refreshToken: BuiltValueNullFieldError.checkNotNull(refreshToken,
                r'V1AuthOtpVerifyPost200Response', 'refreshToken'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1AuthOtpVerifyPost200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_tokens_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthTokensInput extends AuthTokensInput {
  @override
  final String accessToken;
  @override
  final String refreshToken;

  factory _$AuthTokensInput([void Function(AuthTokensInputBuilder)? updates]) =>
      (AuthTokensInputBuilder()..update(updates))._build();

  _$AuthTokensInput._({required this.accessToken, required this.refreshToken})
      : super._();
  @override
  AuthTokensInput rebuild(void Function(AuthTokensInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthTokensInputBuilder toBuilder() => AuthTokensInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthTokensInput &&
        accessToken == other.accessToken &&
        refreshToken == other.refreshToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthTokensInput')
          ..add('accessToken', accessToken)
          ..add('refreshToken', refreshToken))
        .toString();
  }
}

class AuthTokensInputBuilder
    implements Builder<AuthTokensInput, AuthTokensInputBuilder> {
  _$AuthTokensInput? _$v;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  AuthTokensInputBuilder() {
    AuthTokensInput._defaults(this);
  }

  AuthTokensInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessToken = $v.accessToken;
      _refreshToken = $v.refreshToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthTokensInput other) {
    _$v = other as _$AuthTokensInput;
  }

  @override
  void update(void Function(AuthTokensInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthTokensInput build() => _build();

  _$AuthTokensInput _build() {
    final _$result = _$v ??
        _$AuthTokensInput._(
          accessToken: BuiltValueNullFieldError.checkNotNull(
              accessToken, r'AuthTokensInput', 'accessToken'),
          refreshToken: BuiltValueNullFieldError.checkNotNull(
              refreshToken, r'AuthTokensInput', 'refreshToken'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

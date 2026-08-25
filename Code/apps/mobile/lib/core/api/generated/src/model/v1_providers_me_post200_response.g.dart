// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMePost200Response extends V1ProvidersMePost200Response {
  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final V1ProvidersMePost200ResponseProvider provider;

  factory _$V1ProvidersMePost200Response(
          [void Function(V1ProvidersMePost200ResponseBuilder)? updates]) =>
      (V1ProvidersMePost200ResponseBuilder()..update(updates))._build();

  _$V1ProvidersMePost200Response._(
      {required this.accessToken,
      required this.refreshToken,
      required this.provider})
      : super._();
  @override
  V1ProvidersMePost200Response rebuild(
          void Function(V1ProvidersMePost200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMePost200ResponseBuilder toBuilder() =>
      V1ProvidersMePost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMePost200Response &&
        accessToken == other.accessToken &&
        refreshToken == other.refreshToken &&
        provider == other.provider;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1ProvidersMePost200Response')
          ..add('accessToken', accessToken)
          ..add('refreshToken', refreshToken)
          ..add('provider', provider))
        .toString();
  }
}

class V1ProvidersMePost200ResponseBuilder
    implements
        Builder<V1ProvidersMePost200Response,
            V1ProvidersMePost200ResponseBuilder> {
  _$V1ProvidersMePost200Response? _$v;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  V1ProvidersMePost200ResponseProviderBuilder? _provider;
  V1ProvidersMePost200ResponseProviderBuilder get provider =>
      _$this._provider ??= V1ProvidersMePost200ResponseProviderBuilder();
  set provider(V1ProvidersMePost200ResponseProviderBuilder? provider) =>
      _$this._provider = provider;

  V1ProvidersMePost200ResponseBuilder() {
    V1ProvidersMePost200Response._defaults(this);
  }

  V1ProvidersMePost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessToken = $v.accessToken;
      _refreshToken = $v.refreshToken;
      _provider = $v.provider.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMePost200Response other) {
    _$v = other as _$V1ProvidersMePost200Response;
  }

  @override
  void update(void Function(V1ProvidersMePost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMePost200Response build() => _build();

  _$V1ProvidersMePost200Response _build() {
    _$V1ProvidersMePost200Response _$result;
    try {
      _$result = _$v ??
          _$V1ProvidersMePost200Response._(
            accessToken: BuiltValueNullFieldError.checkNotNull(
                accessToken, r'V1ProvidersMePost200Response', 'accessToken'),
            refreshToken: BuiltValueNullFieldError.checkNotNull(
                refreshToken, r'V1ProvidersMePost200Response', 'refreshToken'),
            provider: provider.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'provider';
        provider.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1ProvidersMePost200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

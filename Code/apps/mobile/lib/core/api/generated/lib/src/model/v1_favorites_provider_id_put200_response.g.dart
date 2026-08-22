// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_favorites_provider_id_put200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1FavoritesProviderIdPut200Response
    extends V1FavoritesProviderIdPut200Response {
  @override
  final String providerId;
  @override
  final DateTime createdAt;

  factory _$V1FavoritesProviderIdPut200Response(
          [void Function(V1FavoritesProviderIdPut200ResponseBuilder)?
              updates]) =>
      (V1FavoritesProviderIdPut200ResponseBuilder()..update(updates))._build();

  _$V1FavoritesProviderIdPut200Response._(
      {required this.providerId, required this.createdAt})
      : super._();
  @override
  V1FavoritesProviderIdPut200Response rebuild(
          void Function(V1FavoritesProviderIdPut200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1FavoritesProviderIdPut200ResponseBuilder toBuilder() =>
      V1FavoritesProviderIdPut200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1FavoritesProviderIdPut200Response &&
        providerId == other.providerId &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, providerId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1FavoritesProviderIdPut200Response')
          ..add('providerId', providerId)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class V1FavoritesProviderIdPut200ResponseBuilder
    implements
        Builder<V1FavoritesProviderIdPut200Response,
            V1FavoritesProviderIdPut200ResponseBuilder> {
  _$V1FavoritesProviderIdPut200Response? _$v;

  String? _providerId;
  String? get providerId => _$this._providerId;
  set providerId(String? providerId) => _$this._providerId = providerId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  V1FavoritesProviderIdPut200ResponseBuilder() {
    V1FavoritesProviderIdPut200Response._defaults(this);
  }

  V1FavoritesProviderIdPut200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _providerId = $v.providerId;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1FavoritesProviderIdPut200Response other) {
    _$v = other as _$V1FavoritesProviderIdPut200Response;
  }

  @override
  void update(
      void Function(V1FavoritesProviderIdPut200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1FavoritesProviderIdPut200Response build() => _build();

  _$V1FavoritesProviderIdPut200Response _build() {
    final _$result = _$v ??
        _$V1FavoritesProviderIdPut200Response._(
          providerId: BuiltValueNullFieldError.checkNotNull(
              providerId, r'V1FavoritesProviderIdPut200Response', 'providerId'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'V1FavoritesProviderIdPut200Response', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

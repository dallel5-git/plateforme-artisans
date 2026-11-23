// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_users_me_export_get200_response_favorites_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1UsersMeExportGet200ResponseFavoritesInner
    extends V1UsersMeExportGet200ResponseFavoritesInner {
  @override
  final String providerId;
  @override
  final String providerBusinessName;
  @override
  final DateTime createdAt;

  factory _$V1UsersMeExportGet200ResponseFavoritesInner(
          [void Function(V1UsersMeExportGet200ResponseFavoritesInnerBuilder)?
              updates]) =>
      (V1UsersMeExportGet200ResponseFavoritesInnerBuilder()..update(updates))
          ._build();

  _$V1UsersMeExportGet200ResponseFavoritesInner._(
      {required this.providerId,
      required this.providerBusinessName,
      required this.createdAt})
      : super._();
  @override
  V1UsersMeExportGet200ResponseFavoritesInner rebuild(
          void Function(V1UsersMeExportGet200ResponseFavoritesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1UsersMeExportGet200ResponseFavoritesInnerBuilder toBuilder() =>
      V1UsersMeExportGet200ResponseFavoritesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1UsersMeExportGet200ResponseFavoritesInner &&
        providerId == other.providerId &&
        providerBusinessName == other.providerBusinessName &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, providerId.hashCode);
    _$hash = $jc(_$hash, providerBusinessName.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1UsersMeExportGet200ResponseFavoritesInner')
          ..add('providerId', providerId)
          ..add('providerBusinessName', providerBusinessName)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class V1UsersMeExportGet200ResponseFavoritesInnerBuilder
    implements
        Builder<V1UsersMeExportGet200ResponseFavoritesInner,
            V1UsersMeExportGet200ResponseFavoritesInnerBuilder> {
  _$V1UsersMeExportGet200ResponseFavoritesInner? _$v;

  String? _providerId;
  String? get providerId => _$this._providerId;
  set providerId(String? providerId) => _$this._providerId = providerId;

  String? _providerBusinessName;
  String? get providerBusinessName => _$this._providerBusinessName;
  set providerBusinessName(String? providerBusinessName) =>
      _$this._providerBusinessName = providerBusinessName;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  V1UsersMeExportGet200ResponseFavoritesInnerBuilder() {
    V1UsersMeExportGet200ResponseFavoritesInner._defaults(this);
  }

  V1UsersMeExportGet200ResponseFavoritesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _providerId = $v.providerId;
      _providerBusinessName = $v.providerBusinessName;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1UsersMeExportGet200ResponseFavoritesInner other) {
    _$v = other as _$V1UsersMeExportGet200ResponseFavoritesInner;
  }

  @override
  void update(
      void Function(V1UsersMeExportGet200ResponseFavoritesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1UsersMeExportGet200ResponseFavoritesInner build() => _build();

  _$V1UsersMeExportGet200ResponseFavoritesInner _build() {
    final _$result = _$v ??
        _$V1UsersMeExportGet200ResponseFavoritesInner._(
          providerId: BuiltValueNullFieldError.checkNotNull(providerId,
              r'V1UsersMeExportGet200ResponseFavoritesInner', 'providerId'),
          providerBusinessName: BuiltValueNullFieldError.checkNotNull(
              providerBusinessName,
              r'V1UsersMeExportGet200ResponseFavoritesInner',
              'providerBusinessName'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'V1UsersMeExportGet200ResponseFavoritesInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

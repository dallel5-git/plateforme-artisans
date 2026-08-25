// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_slug_get200_response_base_delegation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersSlugGet200ResponseBaseDelegation
    extends V1ProvidersSlugGet200ResponseBaseDelegation {
  @override
  final String slug;
  @override
  final String nameFr;
  @override
  final String nameAr;

  factory _$V1ProvidersSlugGet200ResponseBaseDelegation([
    void Function(V1ProvidersSlugGet200ResponseBaseDelegationBuilder)? updates,
  ]) => (V1ProvidersSlugGet200ResponseBaseDelegationBuilder()..update(updates))
      ._build();

  _$V1ProvidersSlugGet200ResponseBaseDelegation._({
    required this.slug,
    required this.nameFr,
    required this.nameAr,
  }) : super._();
  @override
  V1ProvidersSlugGet200ResponseBaseDelegation rebuild(
    void Function(V1ProvidersSlugGet200ResponseBaseDelegationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1ProvidersSlugGet200ResponseBaseDelegationBuilder toBuilder() =>
      V1ProvidersSlugGet200ResponseBaseDelegationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersSlugGet200ResponseBaseDelegation &&
        slug == other.slug &&
        nameFr == other.nameFr &&
        nameAr == other.nameAr;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, nameFr.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersSlugGet200ResponseBaseDelegation',
          )
          ..add('slug', slug)
          ..add('nameFr', nameFr)
          ..add('nameAr', nameAr))
        .toString();
  }
}

class V1ProvidersSlugGet200ResponseBaseDelegationBuilder
    implements
        Builder<
          V1ProvidersSlugGet200ResponseBaseDelegation,
          V1ProvidersSlugGet200ResponseBaseDelegationBuilder
        > {
  _$V1ProvidersSlugGet200ResponseBaseDelegation? _$v;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _nameFr;
  String? get nameFr => _$this._nameFr;
  set nameFr(String? nameFr) => _$this._nameFr = nameFr;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  V1ProvidersSlugGet200ResponseBaseDelegationBuilder() {
    V1ProvidersSlugGet200ResponseBaseDelegation._defaults(this);
  }

  V1ProvidersSlugGet200ResponseBaseDelegationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _slug = $v.slug;
      _nameFr = $v.nameFr;
      _nameAr = $v.nameAr;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersSlugGet200ResponseBaseDelegation other) {
    _$v = other as _$V1ProvidersSlugGet200ResponseBaseDelegation;
  }

  @override
  void update(
    void Function(V1ProvidersSlugGet200ResponseBaseDelegationBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersSlugGet200ResponseBaseDelegation build() => _build();

  _$V1ProvidersSlugGet200ResponseBaseDelegation _build() {
    final _$result =
        _$v ??
        _$V1ProvidersSlugGet200ResponseBaseDelegation._(
          slug: BuiltValueNullFieldError.checkNotNull(
            slug,
            r'V1ProvidersSlugGet200ResponseBaseDelegation',
            'slug',
          ),
          nameFr: BuiltValueNullFieldError.checkNotNull(
            nameFr,
            r'V1ProvidersSlugGet200ResponseBaseDelegation',
            'nameFr',
          ),
          nameAr: BuiltValueNullFieldError.checkNotNull(
            nameAr,
            r'V1ProvidersSlugGet200ResponseBaseDelegation',
            'nameAr',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

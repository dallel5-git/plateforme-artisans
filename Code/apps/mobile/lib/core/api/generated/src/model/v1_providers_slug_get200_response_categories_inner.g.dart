// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_slug_get200_response_categories_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersSlugGet200ResponseCategoriesInner
    extends V1ProvidersSlugGet200ResponseCategoriesInner {
  @override
  final String slug;
  @override
  final String nameFr;
  @override
  final String nameAr;
  @override
  final bool isPrimary;
  @override
  final int yearsExperience;

  factory _$V1ProvidersSlugGet200ResponseCategoriesInner([
    void Function(V1ProvidersSlugGet200ResponseCategoriesInnerBuilder)? updates,
  ]) => (V1ProvidersSlugGet200ResponseCategoriesInnerBuilder()..update(updates))
      ._build();

  _$V1ProvidersSlugGet200ResponseCategoriesInner._({
    required this.slug,
    required this.nameFr,
    required this.nameAr,
    required this.isPrimary,
    required this.yearsExperience,
  }) : super._();
  @override
  V1ProvidersSlugGet200ResponseCategoriesInner rebuild(
    void Function(V1ProvidersSlugGet200ResponseCategoriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1ProvidersSlugGet200ResponseCategoriesInnerBuilder toBuilder() =>
      V1ProvidersSlugGet200ResponseCategoriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersSlugGet200ResponseCategoriesInner &&
        slug == other.slug &&
        nameFr == other.nameFr &&
        nameAr == other.nameAr &&
        isPrimary == other.isPrimary &&
        yearsExperience == other.yearsExperience;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, nameFr.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, isPrimary.hashCode);
    _$hash = $jc(_$hash, yearsExperience.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersSlugGet200ResponseCategoriesInner',
          )
          ..add('slug', slug)
          ..add('nameFr', nameFr)
          ..add('nameAr', nameAr)
          ..add('isPrimary', isPrimary)
          ..add('yearsExperience', yearsExperience))
        .toString();
  }
}

class V1ProvidersSlugGet200ResponseCategoriesInnerBuilder
    implements
        Builder<
          V1ProvidersSlugGet200ResponseCategoriesInner,
          V1ProvidersSlugGet200ResponseCategoriesInnerBuilder
        > {
  _$V1ProvidersSlugGet200ResponseCategoriesInner? _$v;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _nameFr;
  String? get nameFr => _$this._nameFr;
  set nameFr(String? nameFr) => _$this._nameFr = nameFr;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  bool? _isPrimary;
  bool? get isPrimary => _$this._isPrimary;
  set isPrimary(bool? isPrimary) => _$this._isPrimary = isPrimary;

  int? _yearsExperience;
  int? get yearsExperience => _$this._yearsExperience;
  set yearsExperience(int? yearsExperience) =>
      _$this._yearsExperience = yearsExperience;

  V1ProvidersSlugGet200ResponseCategoriesInnerBuilder() {
    V1ProvidersSlugGet200ResponseCategoriesInner._defaults(this);
  }

  V1ProvidersSlugGet200ResponseCategoriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _slug = $v.slug;
      _nameFr = $v.nameFr;
      _nameAr = $v.nameAr;
      _isPrimary = $v.isPrimary;
      _yearsExperience = $v.yearsExperience;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersSlugGet200ResponseCategoriesInner other) {
    _$v = other as _$V1ProvidersSlugGet200ResponseCategoriesInner;
  }

  @override
  void update(
    void Function(V1ProvidersSlugGet200ResponseCategoriesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersSlugGet200ResponseCategoriesInner build() => _build();

  _$V1ProvidersSlugGet200ResponseCategoriesInner _build() {
    final _$result =
        _$v ??
        _$V1ProvidersSlugGet200ResponseCategoriesInner._(
          slug: BuiltValueNullFieldError.checkNotNull(
            slug,
            r'V1ProvidersSlugGet200ResponseCategoriesInner',
            'slug',
          ),
          nameFr: BuiltValueNullFieldError.checkNotNull(
            nameFr,
            r'V1ProvidersSlugGet200ResponseCategoriesInner',
            'nameFr',
          ),
          nameAr: BuiltValueNullFieldError.checkNotNull(
            nameAr,
            r'V1ProvidersSlugGet200ResponseCategoriesInner',
            'nameAr',
          ),
          isPrimary: BuiltValueNullFieldError.checkNotNull(
            isPrimary,
            r'V1ProvidersSlugGet200ResponseCategoriesInner',
            'isPrimary',
          ),
          yearsExperience: BuiltValueNullFieldError.checkNotNull(
            yearsExperience,
            r'V1ProvidersSlugGet200ResponseCategoriesInner',
            'yearsExperience',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

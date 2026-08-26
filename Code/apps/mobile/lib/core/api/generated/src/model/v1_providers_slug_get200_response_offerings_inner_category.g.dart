// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_slug_get200_response_offerings_inner_category.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersSlugGet200ResponseOfferingsInnerCategory
    extends V1ProvidersSlugGet200ResponseOfferingsInnerCategory {
  @override
  final String slug;
  @override
  final String nameFr;
  @override
  final String nameAr;

  factory _$V1ProvidersSlugGet200ResponseOfferingsInnerCategory(
          [void Function(
                  V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder)?
              updates]) =>
      (V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder()
            ..update(updates))
          ._build();

  _$V1ProvidersSlugGet200ResponseOfferingsInnerCategory._(
      {required this.slug, required this.nameFr, required this.nameAr})
      : super._();
  @override
  V1ProvidersSlugGet200ResponseOfferingsInnerCategory rebuild(
          void Function(
                  V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder toBuilder() =>
      V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersSlugGet200ResponseOfferingsInnerCategory &&
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
            r'V1ProvidersSlugGet200ResponseOfferingsInnerCategory')
          ..add('slug', slug)
          ..add('nameFr', nameFr)
          ..add('nameAr', nameAr))
        .toString();
  }
}

class V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder
    implements
        Builder<V1ProvidersSlugGet200ResponseOfferingsInnerCategory,
            V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder> {
  _$V1ProvidersSlugGet200ResponseOfferingsInnerCategory? _$v;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _nameFr;
  String? get nameFr => _$this._nameFr;
  set nameFr(String? nameFr) => _$this._nameFr = nameFr;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder() {
    V1ProvidersSlugGet200ResponseOfferingsInnerCategory._defaults(this);
  }

  V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder get _$this {
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
  void replace(V1ProvidersSlugGet200ResponseOfferingsInnerCategory other) {
    _$v = other as _$V1ProvidersSlugGet200ResponseOfferingsInnerCategory;
  }

  @override
  void update(
      void Function(V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersSlugGet200ResponseOfferingsInnerCategory build() => _build();

  _$V1ProvidersSlugGet200ResponseOfferingsInnerCategory _build() {
    final _$result = _$v ??
        _$V1ProvidersSlugGet200ResponseOfferingsInnerCategory._(
          slug: BuiltValueNullFieldError.checkNotNull(slug,
              r'V1ProvidersSlugGet200ResponseOfferingsInnerCategory', 'slug'),
          nameFr: BuiltValueNullFieldError.checkNotNull(nameFr,
              r'V1ProvidersSlugGet200ResponseOfferingsInnerCategory', 'nameFr'),
          nameAr: BuiltValueNullFieldError.checkNotNull(nameAr,
              r'V1ProvidersSlugGet200ResponseOfferingsInnerCategory', 'nameAr'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

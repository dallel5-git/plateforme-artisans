// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_search_get200_response_items_inner_categories_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner
    extends V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner {
  @override
  final String slug;
  @override
  final String nameFr;
  @override
  final String nameAr;
  @override
  final bool isPrimary;

  factory _$V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner([
    void Function(
      V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerBuilder,
    )?
    updates,
  ]) =>
      (V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerBuilder()
            ..update(updates))
          ._build();

  _$V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner._({
    required this.slug,
    required this.nameFr,
    required this.nameAr,
    required this.isPrimary,
  }) : super._();
  @override
  V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner rebuild(
    void Function(
      V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerBuilder toBuilder() =>
      V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner &&
        slug == other.slug &&
        nameFr == other.nameFr &&
        nameAr == other.nameAr &&
        isPrimary == other.isPrimary;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, nameFr.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, isPrimary.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner',
          )
          ..add('slug', slug)
          ..add('nameFr', nameFr)
          ..add('nameAr', nameAr)
          ..add('isPrimary', isPrimary))
        .toString();
  }
}

class V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerBuilder
    implements
        Builder<
          V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner,
          V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerBuilder
        > {
  _$V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner? _$v;

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

  V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerBuilder() {
    V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner._defaults(this);
  }

  V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _slug = $v.slug;
      _nameFr = $v.nameFr;
      _nameAr = $v.nameAr;
      _isPrimary = $v.isPrimary;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner other) {
    _$v = other as _$V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner;
  }

  @override
  void update(
    void Function(
      V1ProvidersSearchGet200ResponseItemsInnerCategoriesInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner build() => _build();

  _$V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner _build() {
    final _$result =
        _$v ??
        _$V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner._(
          slug: BuiltValueNullFieldError.checkNotNull(
            slug,
            r'V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner',
            'slug',
          ),
          nameFr: BuiltValueNullFieldError.checkNotNull(
            nameFr,
            r'V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner',
            'nameFr',
          ),
          nameAr: BuiltValueNullFieldError.checkNotNull(
            nameAr,
            r'V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner',
            'nameAr',
          ),
          isPrimary: BuiltValueNullFieldError.checkNotNull(
            isPrimary,
            r'V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner',
            'isPrimary',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

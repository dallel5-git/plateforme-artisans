// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_categories_put_request_categories_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMeCategoriesPutRequestCategoriesInner
    extends V1ProvidersMeCategoriesPutRequestCategoriesInner {
  @override
  final String categoryId;
  @override
  final bool isPrimary;
  @override
  final int? yearsExperience;

  factory _$V1ProvidersMeCategoriesPutRequestCategoriesInner([
    void Function(V1ProvidersMeCategoriesPutRequestCategoriesInnerBuilder)?
    updates,
  ]) =>
      (V1ProvidersMeCategoriesPutRequestCategoriesInnerBuilder()
            ..update(updates))
          ._build();

  _$V1ProvidersMeCategoriesPutRequestCategoriesInner._({
    required this.categoryId,
    required this.isPrimary,
    this.yearsExperience,
  }) : super._();
  @override
  V1ProvidersMeCategoriesPutRequestCategoriesInner rebuild(
    void Function(V1ProvidersMeCategoriesPutRequestCategoriesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeCategoriesPutRequestCategoriesInnerBuilder toBuilder() =>
      V1ProvidersMeCategoriesPutRequestCategoriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeCategoriesPutRequestCategoriesInner &&
        categoryId == other.categoryId &&
        isPrimary == other.isPrimary &&
        yearsExperience == other.yearsExperience;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, isPrimary.hashCode);
    _$hash = $jc(_$hash, yearsExperience.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersMeCategoriesPutRequestCategoriesInner',
          )
          ..add('categoryId', categoryId)
          ..add('isPrimary', isPrimary)
          ..add('yearsExperience', yearsExperience))
        .toString();
  }
}

class V1ProvidersMeCategoriesPutRequestCategoriesInnerBuilder
    implements
        Builder<
          V1ProvidersMeCategoriesPutRequestCategoriesInner,
          V1ProvidersMeCategoriesPutRequestCategoriesInnerBuilder
        > {
  _$V1ProvidersMeCategoriesPutRequestCategoriesInner? _$v;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  bool? _isPrimary;
  bool? get isPrimary => _$this._isPrimary;
  set isPrimary(bool? isPrimary) => _$this._isPrimary = isPrimary;

  int? _yearsExperience;
  int? get yearsExperience => _$this._yearsExperience;
  set yearsExperience(int? yearsExperience) =>
      _$this._yearsExperience = yearsExperience;

  V1ProvidersMeCategoriesPutRequestCategoriesInnerBuilder() {
    V1ProvidersMeCategoriesPutRequestCategoriesInner._defaults(this);
  }

  V1ProvidersMeCategoriesPutRequestCategoriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryId = $v.categoryId;
      _isPrimary = $v.isPrimary;
      _yearsExperience = $v.yearsExperience;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeCategoriesPutRequestCategoriesInner other) {
    _$v = other as _$V1ProvidersMeCategoriesPutRequestCategoriesInner;
  }

  @override
  void update(
    void Function(V1ProvidersMeCategoriesPutRequestCategoriesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeCategoriesPutRequestCategoriesInner build() => _build();

  _$V1ProvidersMeCategoriesPutRequestCategoriesInner _build() {
    final _$result =
        _$v ??
        _$V1ProvidersMeCategoriesPutRequestCategoriesInner._(
          categoryId: BuiltValueNullFieldError.checkNotNull(
            categoryId,
            r'V1ProvidersMeCategoriesPutRequestCategoriesInner',
            'categoryId',
          ),
          isPrimary: BuiltValueNullFieldError.checkNotNull(
            isPrimary,
            r'V1ProvidersMeCategoriesPutRequestCategoriesInner',
            'isPrimary',
          ),
          yearsExperience: yearsExperience,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

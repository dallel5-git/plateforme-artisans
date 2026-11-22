// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_get200_response_categories_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMeGet200ResponseCategoriesInner
    extends V1ProvidersMeGet200ResponseCategoriesInner {
  @override
  final String categoryId;
  @override
  final bool isPrimary;
  @override
  final int yearsExperience;

  factory _$V1ProvidersMeGet200ResponseCategoriesInner(
          [void Function(V1ProvidersMeGet200ResponseCategoriesInnerBuilder)?
              updates]) =>
      (V1ProvidersMeGet200ResponseCategoriesInnerBuilder()..update(updates))
          ._build();

  _$V1ProvidersMeGet200ResponseCategoriesInner._(
      {required this.categoryId,
      required this.isPrimary,
      required this.yearsExperience})
      : super._();
  @override
  V1ProvidersMeGet200ResponseCategoriesInner rebuild(
          void Function(V1ProvidersMeGet200ResponseCategoriesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeGet200ResponseCategoriesInnerBuilder toBuilder() =>
      V1ProvidersMeGet200ResponseCategoriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeGet200ResponseCategoriesInner &&
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
            r'V1ProvidersMeGet200ResponseCategoriesInner')
          ..add('categoryId', categoryId)
          ..add('isPrimary', isPrimary)
          ..add('yearsExperience', yearsExperience))
        .toString();
  }
}

class V1ProvidersMeGet200ResponseCategoriesInnerBuilder
    implements
        Builder<V1ProvidersMeGet200ResponseCategoriesInner,
            V1ProvidersMeGet200ResponseCategoriesInnerBuilder> {
  _$V1ProvidersMeGet200ResponseCategoriesInner? _$v;

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

  V1ProvidersMeGet200ResponseCategoriesInnerBuilder() {
    V1ProvidersMeGet200ResponseCategoriesInner._defaults(this);
  }

  V1ProvidersMeGet200ResponseCategoriesInnerBuilder get _$this {
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
  void replace(V1ProvidersMeGet200ResponseCategoriesInner other) {
    _$v = other as _$V1ProvidersMeGet200ResponseCategoriesInner;
  }

  @override
  void update(
      void Function(V1ProvidersMeGet200ResponseCategoriesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeGet200ResponseCategoriesInner build() => _build();

  _$V1ProvidersMeGet200ResponseCategoriesInner _build() {
    final _$result = _$v ??
        _$V1ProvidersMeGet200ResponseCategoriesInner._(
          categoryId: BuiltValueNullFieldError.checkNotNull(categoryId,
              r'V1ProvidersMeGet200ResponseCategoriesInner', 'categoryId'),
          isPrimary: BuiltValueNullFieldError.checkNotNull(isPrimary,
              r'V1ProvidersMeGet200ResponseCategoriesInner', 'isPrimary'),
          yearsExperience: BuiltValueNullFieldError.checkNotNull(
              yearsExperience,
              r'V1ProvidersMeGet200ResponseCategoriesInner',
              'yearsExperience'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

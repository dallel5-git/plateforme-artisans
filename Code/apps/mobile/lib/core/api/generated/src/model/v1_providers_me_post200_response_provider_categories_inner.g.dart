// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_post200_response_provider_categories_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMePost200ResponseProviderCategoriesInner
    extends V1ProvidersMePost200ResponseProviderCategoriesInner {
  @override
  final String categoryId;
  @override
  final bool isPrimary;
  @override
  final int yearsExperience;

  factory _$V1ProvidersMePost200ResponseProviderCategoriesInner(
          [void Function(
                  V1ProvidersMePost200ResponseProviderCategoriesInnerBuilder)?
              updates]) =>
      (V1ProvidersMePost200ResponseProviderCategoriesInnerBuilder()
            ..update(updates))
          ._build();

  _$V1ProvidersMePost200ResponseProviderCategoriesInner._(
      {required this.categoryId,
      required this.isPrimary,
      required this.yearsExperience})
      : super._();
  @override
  V1ProvidersMePost200ResponseProviderCategoriesInner rebuild(
          void Function(
                  V1ProvidersMePost200ResponseProviderCategoriesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMePost200ResponseProviderCategoriesInnerBuilder toBuilder() =>
      V1ProvidersMePost200ResponseProviderCategoriesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMePost200ResponseProviderCategoriesInner &&
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
            r'V1ProvidersMePost200ResponseProviderCategoriesInner')
          ..add('categoryId', categoryId)
          ..add('isPrimary', isPrimary)
          ..add('yearsExperience', yearsExperience))
        .toString();
  }
}

class V1ProvidersMePost200ResponseProviderCategoriesInnerBuilder
    implements
        Builder<V1ProvidersMePost200ResponseProviderCategoriesInner,
            V1ProvidersMePost200ResponseProviderCategoriesInnerBuilder> {
  _$V1ProvidersMePost200ResponseProviderCategoriesInner? _$v;

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

  V1ProvidersMePost200ResponseProviderCategoriesInnerBuilder() {
    V1ProvidersMePost200ResponseProviderCategoriesInner._defaults(this);
  }

  V1ProvidersMePost200ResponseProviderCategoriesInnerBuilder get _$this {
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
  void replace(V1ProvidersMePost200ResponseProviderCategoriesInner other) {
    _$v = other as _$V1ProvidersMePost200ResponseProviderCategoriesInner;
  }

  @override
  void update(
      void Function(V1ProvidersMePost200ResponseProviderCategoriesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMePost200ResponseProviderCategoriesInner build() => _build();

  _$V1ProvidersMePost200ResponseProviderCategoriesInner _build() {
    final _$result = _$v ??
        _$V1ProvidersMePost200ResponseProviderCategoriesInner._(
          categoryId: BuiltValueNullFieldError.checkNotNull(
              categoryId,
              r'V1ProvidersMePost200ResponseProviderCategoriesInner',
              'categoryId'),
          isPrimary: BuiltValueNullFieldError.checkNotNull(
              isPrimary,
              r'V1ProvidersMePost200ResponseProviderCategoriesInner',
              'isPrimary'),
          yearsExperience: BuiltValueNullFieldError.checkNotNull(
              yearsExperience,
              r'V1ProvidersMePost200ResponseProviderCategoriesInner',
              'yearsExperience'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

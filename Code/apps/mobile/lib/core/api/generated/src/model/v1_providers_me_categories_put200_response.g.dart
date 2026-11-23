// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_categories_put200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMeCategoriesPut200Response
    extends V1ProvidersMeCategoriesPut200Response {
  @override
  final BuiltList<V1ProvidersMePost200ResponseProviderCategoriesInner>
      categories;
  @override
  final int completionScore;

  factory _$V1ProvidersMeCategoriesPut200Response(
          [void Function(V1ProvidersMeCategoriesPut200ResponseBuilder)?
              updates]) =>
      (V1ProvidersMeCategoriesPut200ResponseBuilder()..update(updates))
          ._build();

  _$V1ProvidersMeCategoriesPut200Response._(
      {required this.categories, required this.completionScore})
      : super._();
  @override
  V1ProvidersMeCategoriesPut200Response rebuild(
          void Function(V1ProvidersMeCategoriesPut200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeCategoriesPut200ResponseBuilder toBuilder() =>
      V1ProvidersMeCategoriesPut200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeCategoriesPut200Response &&
        categories == other.categories &&
        completionScore == other.completionScore;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, completionScore.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersMeCategoriesPut200Response')
          ..add('categories', categories)
          ..add('completionScore', completionScore))
        .toString();
  }
}

class V1ProvidersMeCategoriesPut200ResponseBuilder
    implements
        Builder<V1ProvidersMeCategoriesPut200Response,
            V1ProvidersMeCategoriesPut200ResponseBuilder> {
  _$V1ProvidersMeCategoriesPut200Response? _$v;

  ListBuilder<V1ProvidersMePost200ResponseProviderCategoriesInner>? _categories;
  ListBuilder<V1ProvidersMePost200ResponseProviderCategoriesInner>
      get categories => _$this._categories ??=
          ListBuilder<V1ProvidersMePost200ResponseProviderCategoriesInner>();
  set categories(
          ListBuilder<V1ProvidersMePost200ResponseProviderCategoriesInner>?
              categories) =>
      _$this._categories = categories;

  int? _completionScore;
  int? get completionScore => _$this._completionScore;
  set completionScore(int? completionScore) =>
      _$this._completionScore = completionScore;

  V1ProvidersMeCategoriesPut200ResponseBuilder() {
    V1ProvidersMeCategoriesPut200Response._defaults(this);
  }

  V1ProvidersMeCategoriesPut200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categories = $v.categories.toBuilder();
      _completionScore = $v.completionScore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeCategoriesPut200Response other) {
    _$v = other as _$V1ProvidersMeCategoriesPut200Response;
  }

  @override
  void update(
      void Function(V1ProvidersMeCategoriesPut200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeCategoriesPut200Response build() => _build();

  _$V1ProvidersMeCategoriesPut200Response _build() {
    _$V1ProvidersMeCategoriesPut200Response _$result;
    try {
      _$result = _$v ??
          _$V1ProvidersMeCategoriesPut200Response._(
            categories: categories.build(),
            completionScore: BuiltValueNullFieldError.checkNotNull(
                completionScore,
                r'V1ProvidersMeCategoriesPut200Response',
                'completionScore'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categories';
        categories.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1ProvidersMeCategoriesPut200Response',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

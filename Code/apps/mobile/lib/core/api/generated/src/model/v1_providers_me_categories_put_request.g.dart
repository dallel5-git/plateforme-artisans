// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_categories_put_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMeCategoriesPutRequest
    extends V1ProvidersMeCategoriesPutRequest {
  @override
  final BuiltList<V1ProvidersMeCategoriesPutRequestCategoriesInner> categories;

  factory _$V1ProvidersMeCategoriesPutRequest([
    void Function(V1ProvidersMeCategoriesPutRequestBuilder)? updates,
  ]) => (V1ProvidersMeCategoriesPutRequestBuilder()..update(updates))._build();

  _$V1ProvidersMeCategoriesPutRequest._({required this.categories}) : super._();
  @override
  V1ProvidersMeCategoriesPutRequest rebuild(
    void Function(V1ProvidersMeCategoriesPutRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeCategoriesPutRequestBuilder toBuilder() =>
      V1ProvidersMeCategoriesPutRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeCategoriesPutRequest &&
        categories == other.categories;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'V1ProvidersMeCategoriesPutRequest',
    )..add('categories', categories)).toString();
  }
}

class V1ProvidersMeCategoriesPutRequestBuilder
    implements
        Builder<
          V1ProvidersMeCategoriesPutRequest,
          V1ProvidersMeCategoriesPutRequestBuilder
        > {
  _$V1ProvidersMeCategoriesPutRequest? _$v;

  ListBuilder<V1ProvidersMeCategoriesPutRequestCategoriesInner>? _categories;
  ListBuilder<V1ProvidersMeCategoriesPutRequestCategoriesInner>
  get categories => _$this._categories ??=
      ListBuilder<V1ProvidersMeCategoriesPutRequestCategoriesInner>();
  set categories(
    ListBuilder<V1ProvidersMeCategoriesPutRequestCategoriesInner>? categories,
  ) => _$this._categories = categories;

  V1ProvidersMeCategoriesPutRequestBuilder() {
    V1ProvidersMeCategoriesPutRequest._defaults(this);
  }

  V1ProvidersMeCategoriesPutRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categories = $v.categories.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeCategoriesPutRequest other) {
    _$v = other as _$V1ProvidersMeCategoriesPutRequest;
  }

  @override
  void update(
    void Function(V1ProvidersMeCategoriesPutRequestBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeCategoriesPutRequest build() => _build();

  _$V1ProvidersMeCategoriesPutRequest _build() {
    _$V1ProvidersMeCategoriesPutRequest _$result;
    try {
      _$result =
          _$v ??
          _$V1ProvidersMeCategoriesPutRequest._(
            categories: categories.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categories';
        categories.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'V1ProvidersMeCategoriesPutRequest',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

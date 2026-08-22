// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_categories_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1CategoriesGet200Response extends V1CategoriesGet200Response {
  @override
  final BuiltList<CategoryTreeNode> categories;

  factory _$V1CategoriesGet200Response(
          [void Function(V1CategoriesGet200ResponseBuilder)? updates]) =>
      (V1CategoriesGet200ResponseBuilder()..update(updates))._build();

  _$V1CategoriesGet200Response._({required this.categories}) : super._();
  @override
  V1CategoriesGet200Response rebuild(
          void Function(V1CategoriesGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1CategoriesGet200ResponseBuilder toBuilder() =>
      V1CategoriesGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1CategoriesGet200Response &&
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
    return (newBuiltValueToStringHelper(r'V1CategoriesGet200Response')
          ..add('categories', categories))
        .toString();
  }
}

class V1CategoriesGet200ResponseBuilder
    implements
        Builder<V1CategoriesGet200Response, V1CategoriesGet200ResponseBuilder> {
  _$V1CategoriesGet200Response? _$v;

  ListBuilder<CategoryTreeNode>? _categories;
  ListBuilder<CategoryTreeNode> get categories =>
      _$this._categories ??= ListBuilder<CategoryTreeNode>();
  set categories(ListBuilder<CategoryTreeNode>? categories) =>
      _$this._categories = categories;

  V1CategoriesGet200ResponseBuilder() {
    V1CategoriesGet200Response._defaults(this);
  }

  V1CategoriesGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categories = $v.categories.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1CategoriesGet200Response other) {
    _$v = other as _$V1CategoriesGet200Response;
  }

  @override
  void update(void Function(V1CategoriesGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1CategoriesGet200Response build() => _build();

  _$V1CategoriesGet200Response _build() {
    _$V1CategoriesGet200Response _$result;
    try {
      _$result = _$v ??
          _$V1CategoriesGet200Response._(
            categories: categories.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categories';
        categories.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1CategoriesGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

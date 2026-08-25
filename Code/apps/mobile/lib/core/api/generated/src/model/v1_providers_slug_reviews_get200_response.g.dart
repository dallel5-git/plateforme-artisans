// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_slug_reviews_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersSlugReviewsGet200Response
    extends V1ProvidersSlugReviewsGet200Response {
  @override
  final BuiltList<V1ProvidersSlugReviewsGet200ResponseItemsInner> items;
  @override
  final String nextCursor;

  factory _$V1ProvidersSlugReviewsGet200Response([
    void Function(V1ProvidersSlugReviewsGet200ResponseBuilder)? updates,
  ]) =>
      (V1ProvidersSlugReviewsGet200ResponseBuilder()..update(updates))._build();

  _$V1ProvidersSlugReviewsGet200Response._({
    required this.items,
    required this.nextCursor,
  }) : super._();
  @override
  V1ProvidersSlugReviewsGet200Response rebuild(
    void Function(V1ProvidersSlugReviewsGet200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1ProvidersSlugReviewsGet200ResponseBuilder toBuilder() =>
      V1ProvidersSlugReviewsGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersSlugReviewsGet200Response &&
        items == other.items &&
        nextCursor == other.nextCursor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1ProvidersSlugReviewsGet200Response')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class V1ProvidersSlugReviewsGet200ResponseBuilder
    implements
        Builder<
          V1ProvidersSlugReviewsGet200Response,
          V1ProvidersSlugReviewsGet200ResponseBuilder
        > {
  _$V1ProvidersSlugReviewsGet200Response? _$v;

  ListBuilder<V1ProvidersSlugReviewsGet200ResponseItemsInner>? _items;
  ListBuilder<V1ProvidersSlugReviewsGet200ResponseItemsInner> get items =>
      _$this._items ??=
          ListBuilder<V1ProvidersSlugReviewsGet200ResponseItemsInner>();
  set items(
    ListBuilder<V1ProvidersSlugReviewsGet200ResponseItemsInner>? items,
  ) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  V1ProvidersSlugReviewsGet200ResponseBuilder() {
    V1ProvidersSlugReviewsGet200Response._defaults(this);
  }

  V1ProvidersSlugReviewsGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersSlugReviewsGet200Response other) {
    _$v = other as _$V1ProvidersSlugReviewsGet200Response;
  }

  @override
  void update(
    void Function(V1ProvidersSlugReviewsGet200ResponseBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersSlugReviewsGet200Response build() => _build();

  _$V1ProvidersSlugReviewsGet200Response _build() {
    _$V1ProvidersSlugReviewsGet200Response _$result;
    try {
      _$result =
          _$v ??
          _$V1ProvidersSlugReviewsGet200Response._(
            items: items.build(),
            nextCursor: BuiltValueNullFieldError.checkNotNull(
              nextCursor,
              r'V1ProvidersSlugReviewsGet200Response',
              'nextCursor',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'V1ProvidersSlugReviewsGet200Response',
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

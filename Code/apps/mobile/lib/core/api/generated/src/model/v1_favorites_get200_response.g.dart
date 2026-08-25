// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_favorites_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1FavoritesGet200Response extends V1FavoritesGet200Response {
  @override
  final BuiltList<V1FavoritesGet200ResponseItemsInner> items;
  @override
  final String nextCursor;

  factory _$V1FavoritesGet200Response([
    void Function(V1FavoritesGet200ResponseBuilder)? updates,
  ]) => (V1FavoritesGet200ResponseBuilder()..update(updates))._build();

  _$V1FavoritesGet200Response._({required this.items, required this.nextCursor})
    : super._();
  @override
  V1FavoritesGet200Response rebuild(
    void Function(V1FavoritesGet200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1FavoritesGet200ResponseBuilder toBuilder() =>
      V1FavoritesGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1FavoritesGet200Response &&
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
    return (newBuiltValueToStringHelper(r'V1FavoritesGet200Response')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class V1FavoritesGet200ResponseBuilder
    implements
        Builder<V1FavoritesGet200Response, V1FavoritesGet200ResponseBuilder> {
  _$V1FavoritesGet200Response? _$v;

  ListBuilder<V1FavoritesGet200ResponseItemsInner>? _items;
  ListBuilder<V1FavoritesGet200ResponseItemsInner> get items =>
      _$this._items ??= ListBuilder<V1FavoritesGet200ResponseItemsInner>();
  set items(ListBuilder<V1FavoritesGet200ResponseItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  V1FavoritesGet200ResponseBuilder() {
    V1FavoritesGet200Response._defaults(this);
  }

  V1FavoritesGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1FavoritesGet200Response other) {
    _$v = other as _$V1FavoritesGet200Response;
  }

  @override
  void update(void Function(V1FavoritesGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1FavoritesGet200Response build() => _build();

  _$V1FavoritesGet200Response _build() {
    _$V1FavoritesGet200Response _$result;
    try {
      _$result =
          _$v ??
          _$V1FavoritesGet200Response._(
            items: items.build(),
            nextCursor: BuiltValueNullFieldError.checkNotNull(
              nextCursor,
              r'V1FavoritesGet200Response',
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
          r'V1FavoritesGet200Response',
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

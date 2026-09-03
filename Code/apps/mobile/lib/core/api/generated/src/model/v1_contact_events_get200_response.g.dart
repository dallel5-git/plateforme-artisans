// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_contact_events_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ContactEventsGet200Response extends V1ContactEventsGet200Response {
  @override
  final BuiltList<V1ContactEventsGet200ResponseItemsInner> items;
  @override
  final String nextCursor;

  factory _$V1ContactEventsGet200Response(
          [void Function(V1ContactEventsGet200ResponseBuilder)? updates]) =>
      (V1ContactEventsGet200ResponseBuilder()..update(updates))._build();

  _$V1ContactEventsGet200Response._(
      {required this.items, required this.nextCursor})
      : super._();
  @override
  V1ContactEventsGet200Response rebuild(
          void Function(V1ContactEventsGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ContactEventsGet200ResponseBuilder toBuilder() =>
      V1ContactEventsGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ContactEventsGet200Response &&
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
    return (newBuiltValueToStringHelper(r'V1ContactEventsGet200Response')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class V1ContactEventsGet200ResponseBuilder
    implements
        Builder<V1ContactEventsGet200Response,
            V1ContactEventsGet200ResponseBuilder> {
  _$V1ContactEventsGet200Response? _$v;

  ListBuilder<V1ContactEventsGet200ResponseItemsInner>? _items;
  ListBuilder<V1ContactEventsGet200ResponseItemsInner> get items =>
      _$this._items ??= ListBuilder<V1ContactEventsGet200ResponseItemsInner>();
  set items(ListBuilder<V1ContactEventsGet200ResponseItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  V1ContactEventsGet200ResponseBuilder() {
    V1ContactEventsGet200Response._defaults(this);
  }

  V1ContactEventsGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ContactEventsGet200Response other) {
    _$v = other as _$V1ContactEventsGet200Response;
  }

  @override
  void update(void Function(V1ContactEventsGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ContactEventsGet200Response build() => _build();

  _$V1ContactEventsGet200Response _build() {
    _$V1ContactEventsGet200Response _$result;
    try {
      _$result = _$v ??
          _$V1ContactEventsGet200Response._(
            items: items.build(),
            nextCursor: BuiltValueNullFieldError.checkNotNull(
                nextCursor, r'V1ContactEventsGet200Response', 'nextCursor'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1ContactEventsGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

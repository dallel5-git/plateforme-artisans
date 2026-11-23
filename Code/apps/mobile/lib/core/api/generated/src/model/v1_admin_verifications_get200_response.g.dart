// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_admin_verifications_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1AdminVerificationsGet200Response
    extends V1AdminVerificationsGet200Response {
  @override
  final BuiltList<V1AdminVerificationsGet200ResponseItemsInner> items;
  @override
  final String nextCursor;
  @override
  final int totalPending;

  factory _$V1AdminVerificationsGet200Response(
          [void Function(V1AdminVerificationsGet200ResponseBuilder)?
              updates]) =>
      (V1AdminVerificationsGet200ResponseBuilder()..update(updates))._build();

  _$V1AdminVerificationsGet200Response._(
      {required this.items,
      required this.nextCursor,
      required this.totalPending})
      : super._();
  @override
  V1AdminVerificationsGet200Response rebuild(
          void Function(V1AdminVerificationsGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1AdminVerificationsGet200ResponseBuilder toBuilder() =>
      V1AdminVerificationsGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AdminVerificationsGet200Response &&
        items == other.items &&
        nextCursor == other.nextCursor &&
        totalPending == other.totalPending;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, totalPending.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1AdminVerificationsGet200Response')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('totalPending', totalPending))
        .toString();
  }
}

class V1AdminVerificationsGet200ResponseBuilder
    implements
        Builder<V1AdminVerificationsGet200Response,
            V1AdminVerificationsGet200ResponseBuilder> {
  _$V1AdminVerificationsGet200Response? _$v;

  ListBuilder<V1AdminVerificationsGet200ResponseItemsInner>? _items;
  ListBuilder<V1AdminVerificationsGet200ResponseItemsInner> get items =>
      _$this._items ??=
          ListBuilder<V1AdminVerificationsGet200ResponseItemsInner>();
  set items(ListBuilder<V1AdminVerificationsGet200ResponseItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _totalPending;
  int? get totalPending => _$this._totalPending;
  set totalPending(int? totalPending) => _$this._totalPending = totalPending;

  V1AdminVerificationsGet200ResponseBuilder() {
    V1AdminVerificationsGet200Response._defaults(this);
  }

  V1AdminVerificationsGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _totalPending = $v.totalPending;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AdminVerificationsGet200Response other) {
    _$v = other as _$V1AdminVerificationsGet200Response;
  }

  @override
  void update(
      void Function(V1AdminVerificationsGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AdminVerificationsGet200Response build() => _build();

  _$V1AdminVerificationsGet200Response _build() {
    _$V1AdminVerificationsGet200Response _$result;
    try {
      _$result = _$v ??
          _$V1AdminVerificationsGet200Response._(
            items: items.build(),
            nextCursor: BuiltValueNullFieldError.checkNotNull(nextCursor,
                r'V1AdminVerificationsGet200Response', 'nextCursor'),
            totalPending: BuiltValueNullFieldError.checkNotNull(totalPending,
                r'V1AdminVerificationsGet200Response', 'totalPending'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1AdminVerificationsGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

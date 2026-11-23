// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_admin_verifications_get200_response_items_inner_reviewed_by.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1AdminVerificationsGet200ResponseItemsInnerReviewedBy
    extends V1AdminVerificationsGet200ResponseItemsInnerReviewedBy {
  @override
  final String id;
  @override
  final String phone;

  factory _$V1AdminVerificationsGet200ResponseItemsInnerReviewedBy(
          [void Function(
                  V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder)?
              updates]) =>
      (V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder()
            ..update(updates))
          ._build();

  _$V1AdminVerificationsGet200ResponseItemsInnerReviewedBy._(
      {required this.id, required this.phone})
      : super._();
  @override
  V1AdminVerificationsGet200ResponseItemsInnerReviewedBy rebuild(
          void Function(
                  V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder toBuilder() =>
      V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AdminVerificationsGet200ResponseItemsInnerReviewedBy &&
        id == other.id &&
        phone == other.phone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1AdminVerificationsGet200ResponseItemsInnerReviewedBy')
          ..add('id', id)
          ..add('phone', phone))
        .toString();
  }
}

class V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder
    implements
        Builder<V1AdminVerificationsGet200ResponseItemsInnerReviewedBy,
            V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder> {
  _$V1AdminVerificationsGet200ResponseItemsInnerReviewedBy? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder() {
    V1AdminVerificationsGet200ResponseItemsInnerReviewedBy._defaults(this);
  }

  V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AdminVerificationsGet200ResponseItemsInnerReviewedBy other) {
    _$v = other as _$V1AdminVerificationsGet200ResponseItemsInnerReviewedBy;
  }

  @override
  void update(
      void Function(
              V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AdminVerificationsGet200ResponseItemsInnerReviewedBy build() => _build();

  _$V1AdminVerificationsGet200ResponseItemsInnerReviewedBy _build() {
    final _$result = _$v ??
        _$V1AdminVerificationsGet200ResponseItemsInnerReviewedBy._(
          id: BuiltValueNullFieldError.checkNotNull(id,
              r'V1AdminVerificationsGet200ResponseItemsInnerReviewedBy', 'id'),
          phone: BuiltValueNullFieldError.checkNotNull(
              phone,
              r'V1AdminVerificationsGet200ResponseItemsInnerReviewedBy',
              'phone'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

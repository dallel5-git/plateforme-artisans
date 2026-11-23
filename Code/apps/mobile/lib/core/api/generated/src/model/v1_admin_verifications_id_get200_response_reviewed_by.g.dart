// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_admin_verifications_id_get200_response_reviewed_by.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1AdminVerificationsIdGet200ResponseReviewedBy
    extends V1AdminVerificationsIdGet200ResponseReviewedBy {
  @override
  final String id;
  @override
  final String phone;

  factory _$V1AdminVerificationsIdGet200ResponseReviewedBy(
          [void Function(V1AdminVerificationsIdGet200ResponseReviewedByBuilder)?
              updates]) =>
      (V1AdminVerificationsIdGet200ResponseReviewedByBuilder()..update(updates))
          ._build();

  _$V1AdminVerificationsIdGet200ResponseReviewedBy._(
      {required this.id, required this.phone})
      : super._();
  @override
  V1AdminVerificationsIdGet200ResponseReviewedBy rebuild(
          void Function(V1AdminVerificationsIdGet200ResponseReviewedByBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1AdminVerificationsIdGet200ResponseReviewedByBuilder toBuilder() =>
      V1AdminVerificationsIdGet200ResponseReviewedByBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AdminVerificationsIdGet200ResponseReviewedBy &&
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
            r'V1AdminVerificationsIdGet200ResponseReviewedBy')
          ..add('id', id)
          ..add('phone', phone))
        .toString();
  }
}

class V1AdminVerificationsIdGet200ResponseReviewedByBuilder
    implements
        Builder<V1AdminVerificationsIdGet200ResponseReviewedBy,
            V1AdminVerificationsIdGet200ResponseReviewedByBuilder> {
  _$V1AdminVerificationsIdGet200ResponseReviewedBy? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  V1AdminVerificationsIdGet200ResponseReviewedByBuilder() {
    V1AdminVerificationsIdGet200ResponseReviewedBy._defaults(this);
  }

  V1AdminVerificationsIdGet200ResponseReviewedByBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AdminVerificationsIdGet200ResponseReviewedBy other) {
    _$v = other as _$V1AdminVerificationsIdGet200ResponseReviewedBy;
  }

  @override
  void update(
      void Function(V1AdminVerificationsIdGet200ResponseReviewedByBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AdminVerificationsIdGet200ResponseReviewedBy build() => _build();

  _$V1AdminVerificationsIdGet200ResponseReviewedBy _build() {
    final _$result = _$v ??
        _$V1AdminVerificationsIdGet200ResponseReviewedBy._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'V1AdminVerificationsIdGet200ResponseReviewedBy', 'id'),
          phone: BuiltValueNullFieldError.checkNotNull(phone,
              r'V1AdminVerificationsIdGet200ResponseReviewedBy', 'phone'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

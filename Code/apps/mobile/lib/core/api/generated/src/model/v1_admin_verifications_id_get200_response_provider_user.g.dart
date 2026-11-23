// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_admin_verifications_id_get200_response_provider_user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1AdminVerificationsIdGet200ResponseProviderUser
    extends V1AdminVerificationsIdGet200ResponseProviderUser {
  @override
  final String id;
  @override
  final String phone;

  factory _$V1AdminVerificationsIdGet200ResponseProviderUser(
          [void Function(
                  V1AdminVerificationsIdGet200ResponseProviderUserBuilder)?
              updates]) =>
      (V1AdminVerificationsIdGet200ResponseProviderUserBuilder()
            ..update(updates))
          ._build();

  _$V1AdminVerificationsIdGet200ResponseProviderUser._(
      {required this.id, required this.phone})
      : super._();
  @override
  V1AdminVerificationsIdGet200ResponseProviderUser rebuild(
          void Function(V1AdminVerificationsIdGet200ResponseProviderUserBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1AdminVerificationsIdGet200ResponseProviderUserBuilder toBuilder() =>
      V1AdminVerificationsIdGet200ResponseProviderUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AdminVerificationsIdGet200ResponseProviderUser &&
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
            r'V1AdminVerificationsIdGet200ResponseProviderUser')
          ..add('id', id)
          ..add('phone', phone))
        .toString();
  }
}

class V1AdminVerificationsIdGet200ResponseProviderUserBuilder
    implements
        Builder<V1AdminVerificationsIdGet200ResponseProviderUser,
            V1AdminVerificationsIdGet200ResponseProviderUserBuilder> {
  _$V1AdminVerificationsIdGet200ResponseProviderUser? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  V1AdminVerificationsIdGet200ResponseProviderUserBuilder() {
    V1AdminVerificationsIdGet200ResponseProviderUser._defaults(this);
  }

  V1AdminVerificationsIdGet200ResponseProviderUserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AdminVerificationsIdGet200ResponseProviderUser other) {
    _$v = other as _$V1AdminVerificationsIdGet200ResponseProviderUser;
  }

  @override
  void update(
      void Function(V1AdminVerificationsIdGet200ResponseProviderUserBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AdminVerificationsIdGet200ResponseProviderUser build() => _build();

  _$V1AdminVerificationsIdGet200ResponseProviderUser _build() {
    final _$result = _$v ??
        _$V1AdminVerificationsIdGet200ResponseProviderUser._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'V1AdminVerificationsIdGet200ResponseProviderUser', 'id'),
          phone: BuiltValueNullFieldError.checkNotNull(phone,
              r'V1AdminVerificationsIdGet200ResponseProviderUser', 'phone'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

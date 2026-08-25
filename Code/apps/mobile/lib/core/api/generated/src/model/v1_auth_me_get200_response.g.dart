// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_auth_me_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1AuthMeGet200ResponseStatusEnum
_$v1AuthMeGet200ResponseStatusEnum_PENDING_VERIFICATION =
    const V1AuthMeGet200ResponseStatusEnum._('PENDING_VERIFICATION');
const V1AuthMeGet200ResponseStatusEnum
_$v1AuthMeGet200ResponseStatusEnum_ACTIVE =
    const V1AuthMeGet200ResponseStatusEnum._('ACTIVE');
const V1AuthMeGet200ResponseStatusEnum
_$v1AuthMeGet200ResponseStatusEnum_SUSPENDED =
    const V1AuthMeGet200ResponseStatusEnum._('SUSPENDED');
const V1AuthMeGet200ResponseStatusEnum
_$v1AuthMeGet200ResponseStatusEnum_DELETED =
    const V1AuthMeGet200ResponseStatusEnum._('DELETED');

V1AuthMeGet200ResponseStatusEnum _$v1AuthMeGet200ResponseStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'PENDING_VERIFICATION':
      return _$v1AuthMeGet200ResponseStatusEnum_PENDING_VERIFICATION;
    case 'ACTIVE':
      return _$v1AuthMeGet200ResponseStatusEnum_ACTIVE;
    case 'SUSPENDED':
      return _$v1AuthMeGet200ResponseStatusEnum_SUSPENDED;
    case 'DELETED':
      return _$v1AuthMeGet200ResponseStatusEnum_DELETED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1AuthMeGet200ResponseStatusEnum>
_$v1AuthMeGet200ResponseStatusEnumValues =
    BuiltSet<V1AuthMeGet200ResponseStatusEnum>(
      const <V1AuthMeGet200ResponseStatusEnum>[
        _$v1AuthMeGet200ResponseStatusEnum_PENDING_VERIFICATION,
        _$v1AuthMeGet200ResponseStatusEnum_ACTIVE,
        _$v1AuthMeGet200ResponseStatusEnum_SUSPENDED,
        _$v1AuthMeGet200ResponseStatusEnum_DELETED,
      ],
    );

Serializer<V1AuthMeGet200ResponseStatusEnum>
_$v1AuthMeGet200ResponseStatusEnumSerializer =
    _$V1AuthMeGet200ResponseStatusEnumSerializer();

class _$V1AuthMeGet200ResponseStatusEnumSerializer
    implements PrimitiveSerializer<V1AuthMeGet200ResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING_VERIFICATION': 'PENDING_VERIFICATION',
    'ACTIVE': 'ACTIVE',
    'SUSPENDED': 'SUSPENDED',
    'DELETED': 'DELETED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING_VERIFICATION': 'PENDING_VERIFICATION',
    'ACTIVE': 'ACTIVE',
    'SUSPENDED': 'SUSPENDED',
    'DELETED': 'DELETED',
  };

  @override
  final Iterable<Type> types = const <Type>[V1AuthMeGet200ResponseStatusEnum];
  @override
  final String wireName = 'V1AuthMeGet200ResponseStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    V1AuthMeGet200ResponseStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  V1AuthMeGet200ResponseStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => V1AuthMeGet200ResponseStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$V1AuthMeGet200Response extends V1AuthMeGet200Response {
  @override
  final String id;
  @override
  final String phone;
  @override
  final DateTime phoneVerifiedAt;
  @override
  final String email;
  @override
  final DateTime emailVerifiedAt;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String avatarMediaId;
  @override
  final BuiltList<V1AuthOtpVerifyPost200ResponseUserRolesEnum> roles;
  @override
  final V1AuthMeGet200ResponseStatusEnum status;
  @override
  final String locale;
  @override
  final DateTime lastLoginAt;
  @override
  final bool marketingOptIn;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$V1AuthMeGet200Response([
    void Function(V1AuthMeGet200ResponseBuilder)? updates,
  ]) => (V1AuthMeGet200ResponseBuilder()..update(updates))._build();

  _$V1AuthMeGet200Response._({
    required this.id,
    required this.phone,
    required this.phoneVerifiedAt,
    required this.email,
    required this.emailVerifiedAt,
    required this.firstName,
    required this.lastName,
    required this.avatarMediaId,
    required this.roles,
    required this.status,
    required this.locale,
    required this.lastLoginAt,
    required this.marketingOptIn,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();
  @override
  V1AuthMeGet200Response rebuild(
    void Function(V1AuthMeGet200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1AuthMeGet200ResponseBuilder toBuilder() =>
      V1AuthMeGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AuthMeGet200Response &&
        id == other.id &&
        phone == other.phone &&
        phoneVerifiedAt == other.phoneVerifiedAt &&
        email == other.email &&
        emailVerifiedAt == other.emailVerifiedAt &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        avatarMediaId == other.avatarMediaId &&
        roles == other.roles &&
        status == other.status &&
        locale == other.locale &&
        lastLoginAt == other.lastLoginAt &&
        marketingOptIn == other.marketingOptIn &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, phoneVerifiedAt.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, emailVerifiedAt.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, avatarMediaId.hashCode);
    _$hash = $jc(_$hash, roles.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, locale.hashCode);
    _$hash = $jc(_$hash, lastLoginAt.hashCode);
    _$hash = $jc(_$hash, marketingOptIn.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1AuthMeGet200Response')
          ..add('id', id)
          ..add('phone', phone)
          ..add('phoneVerifiedAt', phoneVerifiedAt)
          ..add('email', email)
          ..add('emailVerifiedAt', emailVerifiedAt)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('avatarMediaId', avatarMediaId)
          ..add('roles', roles)
          ..add('status', status)
          ..add('locale', locale)
          ..add('lastLoginAt', lastLoginAt)
          ..add('marketingOptIn', marketingOptIn)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class V1AuthMeGet200ResponseBuilder
    implements Builder<V1AuthMeGet200Response, V1AuthMeGet200ResponseBuilder> {
  _$V1AuthMeGet200Response? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  DateTime? _phoneVerifiedAt;
  DateTime? get phoneVerifiedAt => _$this._phoneVerifiedAt;
  set phoneVerifiedAt(DateTime? phoneVerifiedAt) =>
      _$this._phoneVerifiedAt = phoneVerifiedAt;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  DateTime? _emailVerifiedAt;
  DateTime? get emailVerifiedAt => _$this._emailVerifiedAt;
  set emailVerifiedAt(DateTime? emailVerifiedAt) =>
      _$this._emailVerifiedAt = emailVerifiedAt;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _avatarMediaId;
  String? get avatarMediaId => _$this._avatarMediaId;
  set avatarMediaId(String? avatarMediaId) =>
      _$this._avatarMediaId = avatarMediaId;

  ListBuilder<V1AuthOtpVerifyPost200ResponseUserRolesEnum>? _roles;
  ListBuilder<V1AuthOtpVerifyPost200ResponseUserRolesEnum> get roles =>
      _$this._roles ??=
          ListBuilder<V1AuthOtpVerifyPost200ResponseUserRolesEnum>();
  set roles(ListBuilder<V1AuthOtpVerifyPost200ResponseUserRolesEnum>? roles) =>
      _$this._roles = roles;

  V1AuthMeGet200ResponseStatusEnum? _status;
  V1AuthMeGet200ResponseStatusEnum? get status => _$this._status;
  set status(V1AuthMeGet200ResponseStatusEnum? status) =>
      _$this._status = status;

  String? _locale;
  String? get locale => _$this._locale;
  set locale(String? locale) => _$this._locale = locale;

  DateTime? _lastLoginAt;
  DateTime? get lastLoginAt => _$this._lastLoginAt;
  set lastLoginAt(DateTime? lastLoginAt) => _$this._lastLoginAt = lastLoginAt;

  bool? _marketingOptIn;
  bool? get marketingOptIn => _$this._marketingOptIn;
  set marketingOptIn(bool? marketingOptIn) =>
      _$this._marketingOptIn = marketingOptIn;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  V1AuthMeGet200ResponseBuilder() {
    V1AuthMeGet200Response._defaults(this);
  }

  V1AuthMeGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _phone = $v.phone;
      _phoneVerifiedAt = $v.phoneVerifiedAt;
      _email = $v.email;
      _emailVerifiedAt = $v.emailVerifiedAt;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _avatarMediaId = $v.avatarMediaId;
      _roles = $v.roles.toBuilder();
      _status = $v.status;
      _locale = $v.locale;
      _lastLoginAt = $v.lastLoginAt;
      _marketingOptIn = $v.marketingOptIn;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AuthMeGet200Response other) {
    _$v = other as _$V1AuthMeGet200Response;
  }

  @override
  void update(void Function(V1AuthMeGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AuthMeGet200Response build() => _build();

  _$V1AuthMeGet200Response _build() {
    _$V1AuthMeGet200Response _$result;
    try {
      _$result =
          _$v ??
          _$V1AuthMeGet200Response._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'V1AuthMeGet200Response',
              'id',
            ),
            phone: BuiltValueNullFieldError.checkNotNull(
              phone,
              r'V1AuthMeGet200Response',
              'phone',
            ),
            phoneVerifiedAt: BuiltValueNullFieldError.checkNotNull(
              phoneVerifiedAt,
              r'V1AuthMeGet200Response',
              'phoneVerifiedAt',
            ),
            email: BuiltValueNullFieldError.checkNotNull(
              email,
              r'V1AuthMeGet200Response',
              'email',
            ),
            emailVerifiedAt: BuiltValueNullFieldError.checkNotNull(
              emailVerifiedAt,
              r'V1AuthMeGet200Response',
              'emailVerifiedAt',
            ),
            firstName: BuiltValueNullFieldError.checkNotNull(
              firstName,
              r'V1AuthMeGet200Response',
              'firstName',
            ),
            lastName: BuiltValueNullFieldError.checkNotNull(
              lastName,
              r'V1AuthMeGet200Response',
              'lastName',
            ),
            avatarMediaId: BuiltValueNullFieldError.checkNotNull(
              avatarMediaId,
              r'V1AuthMeGet200Response',
              'avatarMediaId',
            ),
            roles: roles.build(),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'V1AuthMeGet200Response',
              'status',
            ),
            locale: BuiltValueNullFieldError.checkNotNull(
              locale,
              r'V1AuthMeGet200Response',
              'locale',
            ),
            lastLoginAt: BuiltValueNullFieldError.checkNotNull(
              lastLoginAt,
              r'V1AuthMeGet200Response',
              'lastLoginAt',
            ),
            marketingOptIn: BuiltValueNullFieldError.checkNotNull(
              marketingOptIn,
              r'V1AuthMeGet200Response',
              'marketingOptIn',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'V1AuthMeGet200Response',
              'createdAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'V1AuthMeGet200Response',
              'updatedAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'roles';
        roles.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'V1AuthMeGet200Response',
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

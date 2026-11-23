// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_admin_verifications_id_get200_response_provider.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
    _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_NOT_SUBMITTED =
    const V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum._(
        'NOT_SUBMITTED');
const V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
    _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_PENDING =
    const V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum._(
        'PENDING');
const V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
    _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_MORE_INFO_REQUIRED =
    const V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum._(
        'MORE_INFO_REQUIRED');
const V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
    _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_APPROVED =
    const V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum._(
        'APPROVED');
const V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
    _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_REJECTED =
    const V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum._(
        'REJECTED');

V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
    _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'NOT_SUBMITTED':
      return _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_NOT_SUBMITTED;
    case 'PENDING':
      return _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_PENDING;
    case 'MORE_INFO_REQUIRED':
      return _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_MORE_INFO_REQUIRED;
    case 'APPROVED':
      return _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_APPROVED;
    case 'REJECTED':
      return _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<
        V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum>
    _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnumValues =
    BuiltSet<
        V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum>(const <V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum>[
  _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_NOT_SUBMITTED,
  _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_PENDING,
  _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_MORE_INFO_REQUIRED,
  _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_APPROVED,
  _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum_REJECTED,
]);

Serializer<V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum>
    _$v1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnumSerializer =
    _$V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnumSerializer();

class _$V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnumSerializer
    implements
        PrimitiveSerializer<
            V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_SUBMITTED': 'NOT_SUBMITTED',
    'PENDING': 'PENDING',
    'MORE_INFO_REQUIRED': 'MORE_INFO_REQUIRED',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_SUBMITTED': 'NOT_SUBMITTED',
    'PENDING': 'PENDING',
    'MORE_INFO_REQUIRED': 'MORE_INFO_REQUIRED',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
  ];
  @override
  final String wireName =
      'V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum';

  @override
  Object serialize(
          Serializers serializers,
          V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
              object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
      deserialize(Serializers serializers, Object serialized,
              {FullType specifiedType = FullType.unspecified}) =>
          V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
              .valueOf(_fromWire[serialized] ??
                  (serialized is String ? serialized : ''));
}

class _$V1AdminVerificationsIdGet200ResponseProvider
    extends V1AdminVerificationsIdGet200ResponseProvider {
  @override
  final String id;
  @override
  final String businessName;
  @override
  final String slug;
  @override
  final String headline;
  @override
  final String baseGovernorateId;
  @override
  final bool isVerified;
  @override
  final V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum
      verificationStatus;
  @override
  final V1AdminVerificationsIdGet200ResponseProviderUser user;

  factory _$V1AdminVerificationsIdGet200ResponseProvider(
          [void Function(V1AdminVerificationsIdGet200ResponseProviderBuilder)?
              updates]) =>
      (V1AdminVerificationsIdGet200ResponseProviderBuilder()..update(updates))
          ._build();

  _$V1AdminVerificationsIdGet200ResponseProvider._(
      {required this.id,
      required this.businessName,
      required this.slug,
      required this.headline,
      required this.baseGovernorateId,
      required this.isVerified,
      required this.verificationStatus,
      required this.user})
      : super._();
  @override
  V1AdminVerificationsIdGet200ResponseProvider rebuild(
          void Function(V1AdminVerificationsIdGet200ResponseProviderBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1AdminVerificationsIdGet200ResponseProviderBuilder toBuilder() =>
      V1AdminVerificationsIdGet200ResponseProviderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AdminVerificationsIdGet200ResponseProvider &&
        id == other.id &&
        businessName == other.businessName &&
        slug == other.slug &&
        headline == other.headline &&
        baseGovernorateId == other.baseGovernorateId &&
        isVerified == other.isVerified &&
        verificationStatus == other.verificationStatus &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, businessName.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, headline.hashCode);
    _$hash = $jc(_$hash, baseGovernorateId.hashCode);
    _$hash = $jc(_$hash, isVerified.hashCode);
    _$hash = $jc(_$hash, verificationStatus.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1AdminVerificationsIdGet200ResponseProvider')
          ..add('id', id)
          ..add('businessName', businessName)
          ..add('slug', slug)
          ..add('headline', headline)
          ..add('baseGovernorateId', baseGovernorateId)
          ..add('isVerified', isVerified)
          ..add('verificationStatus', verificationStatus)
          ..add('user', user))
        .toString();
  }
}

class V1AdminVerificationsIdGet200ResponseProviderBuilder
    implements
        Builder<V1AdminVerificationsIdGet200ResponseProvider,
            V1AdminVerificationsIdGet200ResponseProviderBuilder> {
  _$V1AdminVerificationsIdGet200ResponseProvider? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _businessName;
  String? get businessName => _$this._businessName;
  set businessName(String? businessName) => _$this._businessName = businessName;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _headline;
  String? get headline => _$this._headline;
  set headline(String? headline) => _$this._headline = headline;

  String? _baseGovernorateId;
  String? get baseGovernorateId => _$this._baseGovernorateId;
  set baseGovernorateId(String? baseGovernorateId) =>
      _$this._baseGovernorateId = baseGovernorateId;

  bool? _isVerified;
  bool? get isVerified => _$this._isVerified;
  set isVerified(bool? isVerified) => _$this._isVerified = isVerified;

  V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum?
      _verificationStatus;
  V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum?
      get verificationStatus => _$this._verificationStatus;
  set verificationStatus(
          V1AdminVerificationsIdGet200ResponseProviderVerificationStatusEnum?
              verificationStatus) =>
      _$this._verificationStatus = verificationStatus;

  V1AdminVerificationsIdGet200ResponseProviderUserBuilder? _user;
  V1AdminVerificationsIdGet200ResponseProviderUserBuilder get user =>
      _$this._user ??=
          V1AdminVerificationsIdGet200ResponseProviderUserBuilder();
  set user(V1AdminVerificationsIdGet200ResponseProviderUserBuilder? user) =>
      _$this._user = user;

  V1AdminVerificationsIdGet200ResponseProviderBuilder() {
    V1AdminVerificationsIdGet200ResponseProvider._defaults(this);
  }

  V1AdminVerificationsIdGet200ResponseProviderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _businessName = $v.businessName;
      _slug = $v.slug;
      _headline = $v.headline;
      _baseGovernorateId = $v.baseGovernorateId;
      _isVerified = $v.isVerified;
      _verificationStatus = $v.verificationStatus;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AdminVerificationsIdGet200ResponseProvider other) {
    _$v = other as _$V1AdminVerificationsIdGet200ResponseProvider;
  }

  @override
  void update(
      void Function(V1AdminVerificationsIdGet200ResponseProviderBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AdminVerificationsIdGet200ResponseProvider build() => _build();

  _$V1AdminVerificationsIdGet200ResponseProvider _build() {
    _$V1AdminVerificationsIdGet200ResponseProvider _$result;
    try {
      _$result = _$v ??
          _$V1AdminVerificationsIdGet200ResponseProvider._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'V1AdminVerificationsIdGet200ResponseProvider', 'id'),
            businessName: BuiltValueNullFieldError.checkNotNull(
                businessName,
                r'V1AdminVerificationsIdGet200ResponseProvider',
                'businessName'),
            slug: BuiltValueNullFieldError.checkNotNull(
                slug, r'V1AdminVerificationsIdGet200ResponseProvider', 'slug'),
            headline: BuiltValueNullFieldError.checkNotNull(headline,
                r'V1AdminVerificationsIdGet200ResponseProvider', 'headline'),
            baseGovernorateId: BuiltValueNullFieldError.checkNotNull(
                baseGovernorateId,
                r'V1AdminVerificationsIdGet200ResponseProvider',
                'baseGovernorateId'),
            isVerified: BuiltValueNullFieldError.checkNotNull(isVerified,
                r'V1AdminVerificationsIdGet200ResponseProvider', 'isVerified'),
            verificationStatus: BuiltValueNullFieldError.checkNotNull(
                verificationStatus,
                r'V1AdminVerificationsIdGet200ResponseProvider',
                'verificationStatus'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1AdminVerificationsIdGet200ResponseProvider',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

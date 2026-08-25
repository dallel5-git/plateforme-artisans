// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ProvidersMePostRequestSpokenLanguagesEnum
_$v1ProvidersMePostRequestSpokenLanguagesEnum_FR =
    const V1ProvidersMePostRequestSpokenLanguagesEnum._('FR');
const V1ProvidersMePostRequestSpokenLanguagesEnum
_$v1ProvidersMePostRequestSpokenLanguagesEnum_AR =
    const V1ProvidersMePostRequestSpokenLanguagesEnum._('AR');
const V1ProvidersMePostRequestSpokenLanguagesEnum
_$v1ProvidersMePostRequestSpokenLanguagesEnum_EN =
    const V1ProvidersMePostRequestSpokenLanguagesEnum._('EN');

V1ProvidersMePostRequestSpokenLanguagesEnum
_$v1ProvidersMePostRequestSpokenLanguagesEnumValueOf(String name) {
  switch (name) {
    case 'FR':
      return _$v1ProvidersMePostRequestSpokenLanguagesEnum_FR;
    case 'AR':
      return _$v1ProvidersMePostRequestSpokenLanguagesEnum_AR;
    case 'EN':
      return _$v1ProvidersMePostRequestSpokenLanguagesEnum_EN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProvidersMePostRequestSpokenLanguagesEnum>
_$v1ProvidersMePostRequestSpokenLanguagesEnumValues =
    BuiltSet<V1ProvidersMePostRequestSpokenLanguagesEnum>(
      const <V1ProvidersMePostRequestSpokenLanguagesEnum>[
        _$v1ProvidersMePostRequestSpokenLanguagesEnum_FR,
        _$v1ProvidersMePostRequestSpokenLanguagesEnum_AR,
        _$v1ProvidersMePostRequestSpokenLanguagesEnum_EN,
      ],
    );

Serializer<V1ProvidersMePostRequestSpokenLanguagesEnum>
_$v1ProvidersMePostRequestSpokenLanguagesEnumSerializer =
    _$V1ProvidersMePostRequestSpokenLanguagesEnumSerializer();

class _$V1ProvidersMePostRequestSpokenLanguagesEnumSerializer
    implements
        PrimitiveSerializer<V1ProvidersMePostRequestSpokenLanguagesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FR': 'FR',
    'AR': 'AR',
    'EN': 'EN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FR': 'FR',
    'AR': 'AR',
    'EN': 'EN',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1ProvidersMePostRequestSpokenLanguagesEnum,
  ];
  @override
  final String wireName = 'V1ProvidersMePostRequestSpokenLanguagesEnum';

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMePostRequestSpokenLanguagesEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  V1ProvidersMePostRequestSpokenLanguagesEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => V1ProvidersMePostRequestSpokenLanguagesEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$V1ProvidersMePostRequest extends V1ProvidersMePostRequest {
  @override
  final String businessName;
  @override
  final String baseGovernorateId;
  @override
  final String? baseDelegationId;
  @override
  final String? headline;
  @override
  final String? bio;
  @override
  final int? yearsExperience;
  @override
  final String? whatsappPhone;
  @override
  final String? publicPhone;
  @override
  final BuiltList<V1ProvidersMePostRequestSpokenLanguagesEnum>? spokenLanguages;

  factory _$V1ProvidersMePostRequest([
    void Function(V1ProvidersMePostRequestBuilder)? updates,
  ]) => (V1ProvidersMePostRequestBuilder()..update(updates))._build();

  _$V1ProvidersMePostRequest._({
    required this.businessName,
    required this.baseGovernorateId,
    this.baseDelegationId,
    this.headline,
    this.bio,
    this.yearsExperience,
    this.whatsappPhone,
    this.publicPhone,
    this.spokenLanguages,
  }) : super._();
  @override
  V1ProvidersMePostRequest rebuild(
    void Function(V1ProvidersMePostRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMePostRequestBuilder toBuilder() =>
      V1ProvidersMePostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMePostRequest &&
        businessName == other.businessName &&
        baseGovernorateId == other.baseGovernorateId &&
        baseDelegationId == other.baseDelegationId &&
        headline == other.headline &&
        bio == other.bio &&
        yearsExperience == other.yearsExperience &&
        whatsappPhone == other.whatsappPhone &&
        publicPhone == other.publicPhone &&
        spokenLanguages == other.spokenLanguages;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, businessName.hashCode);
    _$hash = $jc(_$hash, baseGovernorateId.hashCode);
    _$hash = $jc(_$hash, baseDelegationId.hashCode);
    _$hash = $jc(_$hash, headline.hashCode);
    _$hash = $jc(_$hash, bio.hashCode);
    _$hash = $jc(_$hash, yearsExperience.hashCode);
    _$hash = $jc(_$hash, whatsappPhone.hashCode);
    _$hash = $jc(_$hash, publicPhone.hashCode);
    _$hash = $jc(_$hash, spokenLanguages.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1ProvidersMePostRequest')
          ..add('businessName', businessName)
          ..add('baseGovernorateId', baseGovernorateId)
          ..add('baseDelegationId', baseDelegationId)
          ..add('headline', headline)
          ..add('bio', bio)
          ..add('yearsExperience', yearsExperience)
          ..add('whatsappPhone', whatsappPhone)
          ..add('publicPhone', publicPhone)
          ..add('spokenLanguages', spokenLanguages))
        .toString();
  }
}

class V1ProvidersMePostRequestBuilder
    implements
        Builder<V1ProvidersMePostRequest, V1ProvidersMePostRequestBuilder> {
  _$V1ProvidersMePostRequest? _$v;

  String? _businessName;
  String? get businessName => _$this._businessName;
  set businessName(String? businessName) => _$this._businessName = businessName;

  String? _baseGovernorateId;
  String? get baseGovernorateId => _$this._baseGovernorateId;
  set baseGovernorateId(String? baseGovernorateId) =>
      _$this._baseGovernorateId = baseGovernorateId;

  String? _baseDelegationId;
  String? get baseDelegationId => _$this._baseDelegationId;
  set baseDelegationId(String? baseDelegationId) =>
      _$this._baseDelegationId = baseDelegationId;

  String? _headline;
  String? get headline => _$this._headline;
  set headline(String? headline) => _$this._headline = headline;

  String? _bio;
  String? get bio => _$this._bio;
  set bio(String? bio) => _$this._bio = bio;

  int? _yearsExperience;
  int? get yearsExperience => _$this._yearsExperience;
  set yearsExperience(int? yearsExperience) =>
      _$this._yearsExperience = yearsExperience;

  String? _whatsappPhone;
  String? get whatsappPhone => _$this._whatsappPhone;
  set whatsappPhone(String? whatsappPhone) =>
      _$this._whatsappPhone = whatsappPhone;

  String? _publicPhone;
  String? get publicPhone => _$this._publicPhone;
  set publicPhone(String? publicPhone) => _$this._publicPhone = publicPhone;

  ListBuilder<V1ProvidersMePostRequestSpokenLanguagesEnum>? _spokenLanguages;
  ListBuilder<V1ProvidersMePostRequestSpokenLanguagesEnum>
  get spokenLanguages => _$this._spokenLanguages ??=
      ListBuilder<V1ProvidersMePostRequestSpokenLanguagesEnum>();
  set spokenLanguages(
    ListBuilder<V1ProvidersMePostRequestSpokenLanguagesEnum>? spokenLanguages,
  ) => _$this._spokenLanguages = spokenLanguages;

  V1ProvidersMePostRequestBuilder() {
    V1ProvidersMePostRequest._defaults(this);
  }

  V1ProvidersMePostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _businessName = $v.businessName;
      _baseGovernorateId = $v.baseGovernorateId;
      _baseDelegationId = $v.baseDelegationId;
      _headline = $v.headline;
      _bio = $v.bio;
      _yearsExperience = $v.yearsExperience;
      _whatsappPhone = $v.whatsappPhone;
      _publicPhone = $v.publicPhone;
      _spokenLanguages = $v.spokenLanguages?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMePostRequest other) {
    _$v = other as _$V1ProvidersMePostRequest;
  }

  @override
  void update(void Function(V1ProvidersMePostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMePostRequest build() => _build();

  _$V1ProvidersMePostRequest _build() {
    _$V1ProvidersMePostRequest _$result;
    try {
      _$result =
          _$v ??
          _$V1ProvidersMePostRequest._(
            businessName: BuiltValueNullFieldError.checkNotNull(
              businessName,
              r'V1ProvidersMePostRequest',
              'businessName',
            ),
            baseGovernorateId: BuiltValueNullFieldError.checkNotNull(
              baseGovernorateId,
              r'V1ProvidersMePostRequest',
              'baseGovernorateId',
            ),
            baseDelegationId: baseDelegationId,
            headline: headline,
            bio: bio,
            yearsExperience: yearsExperience,
            whatsappPhone: whatsappPhone,
            publicPhone: publicPhone,
            spokenLanguages: _spokenLanguages?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'spokenLanguages';
        _spokenLanguages?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'V1ProvidersMePostRequest',
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

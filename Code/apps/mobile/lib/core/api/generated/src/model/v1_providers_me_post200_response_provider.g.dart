// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_post200_response_provider.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ProvidersMePost200ResponseProviderPublicationStatusEnum
    _$v1ProvidersMePost200ResponseProviderPublicationStatusEnum_DRAFT =
    const V1ProvidersMePost200ResponseProviderPublicationStatusEnum._('DRAFT');
const V1ProvidersMePost200ResponseProviderPublicationStatusEnum
    _$v1ProvidersMePost200ResponseProviderPublicationStatusEnum_PUBLISHED =
    const V1ProvidersMePost200ResponseProviderPublicationStatusEnum._(
        'PUBLISHED');
const V1ProvidersMePost200ResponseProviderPublicationStatusEnum
    _$v1ProvidersMePost200ResponseProviderPublicationStatusEnum_HIDDEN =
    const V1ProvidersMePost200ResponseProviderPublicationStatusEnum._('HIDDEN');
const V1ProvidersMePost200ResponseProviderPublicationStatusEnum
    _$v1ProvidersMePost200ResponseProviderPublicationStatusEnum_SUSPENDED =
    const V1ProvidersMePost200ResponseProviderPublicationStatusEnum._(
        'SUSPENDED');

V1ProvidersMePost200ResponseProviderPublicationStatusEnum
    _$v1ProvidersMePost200ResponseProviderPublicationStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'DRAFT':
      return _$v1ProvidersMePost200ResponseProviderPublicationStatusEnum_DRAFT;
    case 'PUBLISHED':
      return _$v1ProvidersMePost200ResponseProviderPublicationStatusEnum_PUBLISHED;
    case 'HIDDEN':
      return _$v1ProvidersMePost200ResponseProviderPublicationStatusEnum_HIDDEN;
    case 'SUSPENDED':
      return _$v1ProvidersMePost200ResponseProviderPublicationStatusEnum_SUSPENDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProvidersMePost200ResponseProviderPublicationStatusEnum>
    _$v1ProvidersMePost200ResponseProviderPublicationStatusEnumValues =
    BuiltSet<
        V1ProvidersMePost200ResponseProviderPublicationStatusEnum>(const <V1ProvidersMePost200ResponseProviderPublicationStatusEnum>[
  _$v1ProvidersMePost200ResponseProviderPublicationStatusEnum_DRAFT,
  _$v1ProvidersMePost200ResponseProviderPublicationStatusEnum_PUBLISHED,
  _$v1ProvidersMePost200ResponseProviderPublicationStatusEnum_HIDDEN,
  _$v1ProvidersMePost200ResponseProviderPublicationStatusEnum_SUSPENDED,
]);

const V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum
    _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnum_AVAILABLE =
    const V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum._(
        'AVAILABLE');
const V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum
    _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnum_BUSY =
    const V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum._('BUSY');
const V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum
    _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnum_ON_HOLIDAY =
    const V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum._(
        'ON_HOLIDAY');

V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum
    _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'AVAILABLE':
      return _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnum_AVAILABLE;
    case 'BUSY':
      return _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnum_BUSY;
    case 'ON_HOLIDAY':
      return _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnum_ON_HOLIDAY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum>
    _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnumValues =
    BuiltSet<
        V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum>(const <V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum>[
  _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnum_AVAILABLE,
  _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnum_BUSY,
  _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnum_ON_HOLIDAY,
]);

Serializer<V1ProvidersMePost200ResponseProviderPublicationStatusEnum>
    _$v1ProvidersMePost200ResponseProviderPublicationStatusEnumSerializer =
    _$V1ProvidersMePost200ResponseProviderPublicationStatusEnumSerializer();
Serializer<V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum>
    _$v1ProvidersMePost200ResponseProviderAvailabilityStatusEnumSerializer =
    _$V1ProvidersMePost200ResponseProviderAvailabilityStatusEnumSerializer();

class _$V1ProvidersMePost200ResponseProviderPublicationStatusEnumSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersMePost200ResponseProviderPublicationStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'PUBLISHED': 'PUBLISHED',
    'HIDDEN': 'HIDDEN',
    'SUSPENDED': 'SUSPENDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'PUBLISHED': 'PUBLISHED',
    'HIDDEN': 'HIDDEN',
    'SUSPENDED': 'SUSPENDED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1ProvidersMePost200ResponseProviderPublicationStatusEnum
  ];
  @override
  final String wireName =
      'V1ProvidersMePost200ResponseProviderPublicationStatusEnum';

  @override
  Object serialize(Serializers serializers,
          V1ProvidersMePost200ResponseProviderPublicationStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ProvidersMePost200ResponseProviderPublicationStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ProvidersMePost200ResponseProviderPublicationStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ProvidersMePost200ResponseProviderAvailabilityStatusEnumSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AVAILABLE': 'AVAILABLE',
    'BUSY': 'BUSY',
    'ON_HOLIDAY': 'ON_HOLIDAY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AVAILABLE': 'AVAILABLE',
    'BUSY': 'BUSY',
    'ON_HOLIDAY': 'ON_HOLIDAY',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum
  ];
  @override
  final String wireName =
      'V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum';

  @override
  Object serialize(Serializers serializers,
          V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ProvidersMePost200ResponseProvider
    extends V1ProvidersMePost200ResponseProvider {
  @override
  final String id;
  @override
  final String slug;
  @override
  final String businessName;
  @override
  final String headline;
  @override
  final String bio;
  @override
  final int yearsExperience;
  @override
  final String whatsappPhone;
  @override
  final String publicPhone;
  @override
  final BuiltList<V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>
      spokenLanguages;
  @override
  final String baseGovernorateId;
  @override
  final String baseDelegationId;
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final V1ProvidersMePost200ResponseProviderPublicationStatusEnum
      publicationStatus;
  @override
  final V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum
      availabilityStatus;
  @override
  final DateTime availableAgainAt;
  @override
  final bool acceptsEmergency;
  @override
  final JsonObject workingHours;
  @override
  final bool isVerified;
  @override
  final DateTime verifiedAt;
  @override
  final num ratingAvg;
  @override
  final int ratingCount;
  @override
  final int totalProfileViews;
  @override
  final int totalContacts;
  @override
  final int completionScore;
  @override
  final num rankingScore;
  @override
  final DateTime lastActiveAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final BuiltList<V1ProvidersMePost200ResponseProviderCategoriesInner>
      categories;
  @override
  final BuiltList<V1ProvidersMePost200ResponseProviderCoverageAreasInner>
      coverageAreas;
  @override
  final BuiltList<V1ProvidersMePost200ResponseProviderPortfolioInner> portfolio;

  factory _$V1ProvidersMePost200ResponseProvider(
          [void Function(V1ProvidersMePost200ResponseProviderBuilder)?
              updates]) =>
      (V1ProvidersMePost200ResponseProviderBuilder()..update(updates))._build();

  _$V1ProvidersMePost200ResponseProvider._(
      {required this.id,
      required this.slug,
      required this.businessName,
      required this.headline,
      required this.bio,
      required this.yearsExperience,
      required this.whatsappPhone,
      required this.publicPhone,
      required this.spokenLanguages,
      required this.baseGovernorateId,
      required this.baseDelegationId,
      required this.latitude,
      required this.longitude,
      required this.publicationStatus,
      required this.availabilityStatus,
      required this.availableAgainAt,
      required this.acceptsEmergency,
      required this.workingHours,
      required this.isVerified,
      required this.verifiedAt,
      required this.ratingAvg,
      required this.ratingCount,
      required this.totalProfileViews,
      required this.totalContacts,
      required this.completionScore,
      required this.rankingScore,
      required this.lastActiveAt,
      required this.createdAt,
      required this.updatedAt,
      required this.categories,
      required this.coverageAreas,
      required this.portfolio})
      : super._();
  @override
  V1ProvidersMePost200ResponseProvider rebuild(
          void Function(V1ProvidersMePost200ResponseProviderBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMePost200ResponseProviderBuilder toBuilder() =>
      V1ProvidersMePost200ResponseProviderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMePost200ResponseProvider &&
        id == other.id &&
        slug == other.slug &&
        businessName == other.businessName &&
        headline == other.headline &&
        bio == other.bio &&
        yearsExperience == other.yearsExperience &&
        whatsappPhone == other.whatsappPhone &&
        publicPhone == other.publicPhone &&
        spokenLanguages == other.spokenLanguages &&
        baseGovernorateId == other.baseGovernorateId &&
        baseDelegationId == other.baseDelegationId &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        publicationStatus == other.publicationStatus &&
        availabilityStatus == other.availabilityStatus &&
        availableAgainAt == other.availableAgainAt &&
        acceptsEmergency == other.acceptsEmergency &&
        workingHours == other.workingHours &&
        isVerified == other.isVerified &&
        verifiedAt == other.verifiedAt &&
        ratingAvg == other.ratingAvg &&
        ratingCount == other.ratingCount &&
        totalProfileViews == other.totalProfileViews &&
        totalContacts == other.totalContacts &&
        completionScore == other.completionScore &&
        rankingScore == other.rankingScore &&
        lastActiveAt == other.lastActiveAt &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        categories == other.categories &&
        coverageAreas == other.coverageAreas &&
        portfolio == other.portfolio;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, businessName.hashCode);
    _$hash = $jc(_$hash, headline.hashCode);
    _$hash = $jc(_$hash, bio.hashCode);
    _$hash = $jc(_$hash, yearsExperience.hashCode);
    _$hash = $jc(_$hash, whatsappPhone.hashCode);
    _$hash = $jc(_$hash, publicPhone.hashCode);
    _$hash = $jc(_$hash, spokenLanguages.hashCode);
    _$hash = $jc(_$hash, baseGovernorateId.hashCode);
    _$hash = $jc(_$hash, baseDelegationId.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, publicationStatus.hashCode);
    _$hash = $jc(_$hash, availabilityStatus.hashCode);
    _$hash = $jc(_$hash, availableAgainAt.hashCode);
    _$hash = $jc(_$hash, acceptsEmergency.hashCode);
    _$hash = $jc(_$hash, workingHours.hashCode);
    _$hash = $jc(_$hash, isVerified.hashCode);
    _$hash = $jc(_$hash, verifiedAt.hashCode);
    _$hash = $jc(_$hash, ratingAvg.hashCode);
    _$hash = $jc(_$hash, ratingCount.hashCode);
    _$hash = $jc(_$hash, totalProfileViews.hashCode);
    _$hash = $jc(_$hash, totalContacts.hashCode);
    _$hash = $jc(_$hash, completionScore.hashCode);
    _$hash = $jc(_$hash, rankingScore.hashCode);
    _$hash = $jc(_$hash, lastActiveAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, coverageAreas.hashCode);
    _$hash = $jc(_$hash, portfolio.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1ProvidersMePost200ResponseProvider')
          ..add('id', id)
          ..add('slug', slug)
          ..add('businessName', businessName)
          ..add('headline', headline)
          ..add('bio', bio)
          ..add('yearsExperience', yearsExperience)
          ..add('whatsappPhone', whatsappPhone)
          ..add('publicPhone', publicPhone)
          ..add('spokenLanguages', spokenLanguages)
          ..add('baseGovernorateId', baseGovernorateId)
          ..add('baseDelegationId', baseDelegationId)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('publicationStatus', publicationStatus)
          ..add('availabilityStatus', availabilityStatus)
          ..add('availableAgainAt', availableAgainAt)
          ..add('acceptsEmergency', acceptsEmergency)
          ..add('workingHours', workingHours)
          ..add('isVerified', isVerified)
          ..add('verifiedAt', verifiedAt)
          ..add('ratingAvg', ratingAvg)
          ..add('ratingCount', ratingCount)
          ..add('totalProfileViews', totalProfileViews)
          ..add('totalContacts', totalContacts)
          ..add('completionScore', completionScore)
          ..add('rankingScore', rankingScore)
          ..add('lastActiveAt', lastActiveAt)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('categories', categories)
          ..add('coverageAreas', coverageAreas)
          ..add('portfolio', portfolio))
        .toString();
  }
}

class V1ProvidersMePost200ResponseProviderBuilder
    implements
        Builder<V1ProvidersMePost200ResponseProvider,
            V1ProvidersMePost200ResponseProviderBuilder> {
  _$V1ProvidersMePost200ResponseProvider? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _businessName;
  String? get businessName => _$this._businessName;
  set businessName(String? businessName) => _$this._businessName = businessName;

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

  ListBuilder<V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>?
      _spokenLanguages;
  ListBuilder<V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>
      get spokenLanguages => _$this._spokenLanguages ??= ListBuilder<
          V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>();
  set spokenLanguages(
          ListBuilder<V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>?
              spokenLanguages) =>
      _$this._spokenLanguages = spokenLanguages;

  String? _baseGovernorateId;
  String? get baseGovernorateId => _$this._baseGovernorateId;
  set baseGovernorateId(String? baseGovernorateId) =>
      _$this._baseGovernorateId = baseGovernorateId;

  String? _baseDelegationId;
  String? get baseDelegationId => _$this._baseDelegationId;
  set baseDelegationId(String? baseDelegationId) =>
      _$this._baseDelegationId = baseDelegationId;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  V1ProvidersMePost200ResponseProviderPublicationStatusEnum? _publicationStatus;
  V1ProvidersMePost200ResponseProviderPublicationStatusEnum?
      get publicationStatus => _$this._publicationStatus;
  set publicationStatus(
          V1ProvidersMePost200ResponseProviderPublicationStatusEnum?
              publicationStatus) =>
      _$this._publicationStatus = publicationStatus;

  V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum?
      _availabilityStatus;
  V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum?
      get availabilityStatus => _$this._availabilityStatus;
  set availabilityStatus(
          V1ProvidersMePost200ResponseProviderAvailabilityStatusEnum?
              availabilityStatus) =>
      _$this._availabilityStatus = availabilityStatus;

  DateTime? _availableAgainAt;
  DateTime? get availableAgainAt => _$this._availableAgainAt;
  set availableAgainAt(DateTime? availableAgainAt) =>
      _$this._availableAgainAt = availableAgainAt;

  bool? _acceptsEmergency;
  bool? get acceptsEmergency => _$this._acceptsEmergency;
  set acceptsEmergency(bool? acceptsEmergency) =>
      _$this._acceptsEmergency = acceptsEmergency;

  JsonObject? _workingHours;
  JsonObject? get workingHours => _$this._workingHours;
  set workingHours(JsonObject? workingHours) =>
      _$this._workingHours = workingHours;

  bool? _isVerified;
  bool? get isVerified => _$this._isVerified;
  set isVerified(bool? isVerified) => _$this._isVerified = isVerified;

  DateTime? _verifiedAt;
  DateTime? get verifiedAt => _$this._verifiedAt;
  set verifiedAt(DateTime? verifiedAt) => _$this._verifiedAt = verifiedAt;

  num? _ratingAvg;
  num? get ratingAvg => _$this._ratingAvg;
  set ratingAvg(num? ratingAvg) => _$this._ratingAvg = ratingAvg;

  int? _ratingCount;
  int? get ratingCount => _$this._ratingCount;
  set ratingCount(int? ratingCount) => _$this._ratingCount = ratingCount;

  int? _totalProfileViews;
  int? get totalProfileViews => _$this._totalProfileViews;
  set totalProfileViews(int? totalProfileViews) =>
      _$this._totalProfileViews = totalProfileViews;

  int? _totalContacts;
  int? get totalContacts => _$this._totalContacts;
  set totalContacts(int? totalContacts) =>
      _$this._totalContacts = totalContacts;

  int? _completionScore;
  int? get completionScore => _$this._completionScore;
  set completionScore(int? completionScore) =>
      _$this._completionScore = completionScore;

  num? _rankingScore;
  num? get rankingScore => _$this._rankingScore;
  set rankingScore(num? rankingScore) => _$this._rankingScore = rankingScore;

  DateTime? _lastActiveAt;
  DateTime? get lastActiveAt => _$this._lastActiveAt;
  set lastActiveAt(DateTime? lastActiveAt) =>
      _$this._lastActiveAt = lastActiveAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ListBuilder<V1ProvidersMePost200ResponseProviderCategoriesInner>? _categories;
  ListBuilder<V1ProvidersMePost200ResponseProviderCategoriesInner>
      get categories => _$this._categories ??=
          ListBuilder<V1ProvidersMePost200ResponseProviderCategoriesInner>();
  set categories(
          ListBuilder<V1ProvidersMePost200ResponseProviderCategoriesInner>?
              categories) =>
      _$this._categories = categories;

  ListBuilder<V1ProvidersMePost200ResponseProviderCoverageAreasInner>?
      _coverageAreas;
  ListBuilder<V1ProvidersMePost200ResponseProviderCoverageAreasInner>
      get coverageAreas => _$this._coverageAreas ??=
          ListBuilder<V1ProvidersMePost200ResponseProviderCoverageAreasInner>();
  set coverageAreas(
          ListBuilder<V1ProvidersMePost200ResponseProviderCoverageAreasInner>?
              coverageAreas) =>
      _$this._coverageAreas = coverageAreas;

  ListBuilder<V1ProvidersMePost200ResponseProviderPortfolioInner>? _portfolio;
  ListBuilder<V1ProvidersMePost200ResponseProviderPortfolioInner>
      get portfolio => _$this._portfolio ??=
          ListBuilder<V1ProvidersMePost200ResponseProviderPortfolioInner>();
  set portfolio(
          ListBuilder<V1ProvidersMePost200ResponseProviderPortfolioInner>?
              portfolio) =>
      _$this._portfolio = portfolio;

  V1ProvidersMePost200ResponseProviderBuilder() {
    V1ProvidersMePost200ResponseProvider._defaults(this);
  }

  V1ProvidersMePost200ResponseProviderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _slug = $v.slug;
      _businessName = $v.businessName;
      _headline = $v.headline;
      _bio = $v.bio;
      _yearsExperience = $v.yearsExperience;
      _whatsappPhone = $v.whatsappPhone;
      _publicPhone = $v.publicPhone;
      _spokenLanguages = $v.spokenLanguages.toBuilder();
      _baseGovernorateId = $v.baseGovernorateId;
      _baseDelegationId = $v.baseDelegationId;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _publicationStatus = $v.publicationStatus;
      _availabilityStatus = $v.availabilityStatus;
      _availableAgainAt = $v.availableAgainAt;
      _acceptsEmergency = $v.acceptsEmergency;
      _workingHours = $v.workingHours;
      _isVerified = $v.isVerified;
      _verifiedAt = $v.verifiedAt;
      _ratingAvg = $v.ratingAvg;
      _ratingCount = $v.ratingCount;
      _totalProfileViews = $v.totalProfileViews;
      _totalContacts = $v.totalContacts;
      _completionScore = $v.completionScore;
      _rankingScore = $v.rankingScore;
      _lastActiveAt = $v.lastActiveAt;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _categories = $v.categories.toBuilder();
      _coverageAreas = $v.coverageAreas.toBuilder();
      _portfolio = $v.portfolio.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMePost200ResponseProvider other) {
    _$v = other as _$V1ProvidersMePost200ResponseProvider;
  }

  @override
  void update(
      void Function(V1ProvidersMePost200ResponseProviderBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMePost200ResponseProvider build() => _build();

  _$V1ProvidersMePost200ResponseProvider _build() {
    _$V1ProvidersMePost200ResponseProvider _$result;
    try {
      _$result = _$v ??
          _$V1ProvidersMePost200ResponseProvider._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'V1ProvidersMePost200ResponseProvider', 'id'),
            slug: BuiltValueNullFieldError.checkNotNull(
                slug, r'V1ProvidersMePost200ResponseProvider', 'slug'),
            businessName: BuiltValueNullFieldError.checkNotNull(businessName,
                r'V1ProvidersMePost200ResponseProvider', 'businessName'),
            headline: BuiltValueNullFieldError.checkNotNull(
                headline, r'V1ProvidersMePost200ResponseProvider', 'headline'),
            bio: BuiltValueNullFieldError.checkNotNull(
                bio, r'V1ProvidersMePost200ResponseProvider', 'bio'),
            yearsExperience: BuiltValueNullFieldError.checkNotNull(
                yearsExperience,
                r'V1ProvidersMePost200ResponseProvider',
                'yearsExperience'),
            whatsappPhone: BuiltValueNullFieldError.checkNotNull(whatsappPhone,
                r'V1ProvidersMePost200ResponseProvider', 'whatsappPhone'),
            publicPhone: BuiltValueNullFieldError.checkNotNull(publicPhone,
                r'V1ProvidersMePost200ResponseProvider', 'publicPhone'),
            spokenLanguages: spokenLanguages.build(),
            baseGovernorateId: BuiltValueNullFieldError.checkNotNull(
                baseGovernorateId,
                r'V1ProvidersMePost200ResponseProvider',
                'baseGovernorateId'),
            baseDelegationId: BuiltValueNullFieldError.checkNotNull(
                baseDelegationId,
                r'V1ProvidersMePost200ResponseProvider',
                'baseDelegationId'),
            latitude: BuiltValueNullFieldError.checkNotNull(
                latitude, r'V1ProvidersMePost200ResponseProvider', 'latitude'),
            longitude: BuiltValueNullFieldError.checkNotNull(longitude,
                r'V1ProvidersMePost200ResponseProvider', 'longitude'),
            publicationStatus: BuiltValueNullFieldError.checkNotNull(
                publicationStatus,
                r'V1ProvidersMePost200ResponseProvider',
                'publicationStatus'),
            availabilityStatus: BuiltValueNullFieldError.checkNotNull(
                availabilityStatus,
                r'V1ProvidersMePost200ResponseProvider',
                'availabilityStatus'),
            availableAgainAt: BuiltValueNullFieldError.checkNotNull(
                availableAgainAt,
                r'V1ProvidersMePost200ResponseProvider',
                'availableAgainAt'),
            acceptsEmergency: BuiltValueNullFieldError.checkNotNull(
                acceptsEmergency,
                r'V1ProvidersMePost200ResponseProvider',
                'acceptsEmergency'),
            workingHours: BuiltValueNullFieldError.checkNotNull(workingHours,
                r'V1ProvidersMePost200ResponseProvider', 'workingHours'),
            isVerified: BuiltValueNullFieldError.checkNotNull(isVerified,
                r'V1ProvidersMePost200ResponseProvider', 'isVerified'),
            verifiedAt: BuiltValueNullFieldError.checkNotNull(verifiedAt,
                r'V1ProvidersMePost200ResponseProvider', 'verifiedAt'),
            ratingAvg: BuiltValueNullFieldError.checkNotNull(ratingAvg,
                r'V1ProvidersMePost200ResponseProvider', 'ratingAvg'),
            ratingCount: BuiltValueNullFieldError.checkNotNull(ratingCount,
                r'V1ProvidersMePost200ResponseProvider', 'ratingCount'),
            totalProfileViews: BuiltValueNullFieldError.checkNotNull(
                totalProfileViews,
                r'V1ProvidersMePost200ResponseProvider',
                'totalProfileViews'),
            totalContacts: BuiltValueNullFieldError.checkNotNull(totalContacts,
                r'V1ProvidersMePost200ResponseProvider', 'totalContacts'),
            completionScore: BuiltValueNullFieldError.checkNotNull(
                completionScore,
                r'V1ProvidersMePost200ResponseProvider',
                'completionScore'),
            rankingScore: BuiltValueNullFieldError.checkNotNull(rankingScore,
                r'V1ProvidersMePost200ResponseProvider', 'rankingScore'),
            lastActiveAt: BuiltValueNullFieldError.checkNotNull(lastActiveAt,
                r'V1ProvidersMePost200ResponseProvider', 'lastActiveAt'),
            createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
                r'V1ProvidersMePost200ResponseProvider', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt,
                r'V1ProvidersMePost200ResponseProvider', 'updatedAt'),
            categories: categories.build(),
            coverageAreas: coverageAreas.build(),
            portfolio: portfolio.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'spokenLanguages';
        spokenLanguages.build();

        _$failedField = 'categories';
        categories.build();
        _$failedField = 'coverageAreas';
        coverageAreas.build();
        _$failedField = 'portfolio';
        portfolio.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1ProvidersMePost200ResponseProvider',
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

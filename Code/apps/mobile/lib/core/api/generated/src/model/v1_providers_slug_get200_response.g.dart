// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_slug_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ProvidersSlugGet200ResponseAvailabilityStatusEnum
_$v1ProvidersSlugGet200ResponseAvailabilityStatusEnum_AVAILABLE =
    const V1ProvidersSlugGet200ResponseAvailabilityStatusEnum._('AVAILABLE');
const V1ProvidersSlugGet200ResponseAvailabilityStatusEnum
_$v1ProvidersSlugGet200ResponseAvailabilityStatusEnum_BUSY =
    const V1ProvidersSlugGet200ResponseAvailabilityStatusEnum._('BUSY');
const V1ProvidersSlugGet200ResponseAvailabilityStatusEnum
_$v1ProvidersSlugGet200ResponseAvailabilityStatusEnum_ON_HOLIDAY =
    const V1ProvidersSlugGet200ResponseAvailabilityStatusEnum._('ON_HOLIDAY');

V1ProvidersSlugGet200ResponseAvailabilityStatusEnum
_$v1ProvidersSlugGet200ResponseAvailabilityStatusEnumValueOf(String name) {
  switch (name) {
    case 'AVAILABLE':
      return _$v1ProvidersSlugGet200ResponseAvailabilityStatusEnum_AVAILABLE;
    case 'BUSY':
      return _$v1ProvidersSlugGet200ResponseAvailabilityStatusEnum_BUSY;
    case 'ON_HOLIDAY':
      return _$v1ProvidersSlugGet200ResponseAvailabilityStatusEnum_ON_HOLIDAY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProvidersSlugGet200ResponseAvailabilityStatusEnum>
_$v1ProvidersSlugGet200ResponseAvailabilityStatusEnumValues =
    BuiltSet<V1ProvidersSlugGet200ResponseAvailabilityStatusEnum>(
      const <V1ProvidersSlugGet200ResponseAvailabilityStatusEnum>[
        _$v1ProvidersSlugGet200ResponseAvailabilityStatusEnum_AVAILABLE,
        _$v1ProvidersSlugGet200ResponseAvailabilityStatusEnum_BUSY,
        _$v1ProvidersSlugGet200ResponseAvailabilityStatusEnum_ON_HOLIDAY,
      ],
    );

Serializer<V1ProvidersSlugGet200ResponseAvailabilityStatusEnum>
_$v1ProvidersSlugGet200ResponseAvailabilityStatusEnumSerializer =
    _$V1ProvidersSlugGet200ResponseAvailabilityStatusEnumSerializer();

class _$V1ProvidersSlugGet200ResponseAvailabilityStatusEnumSerializer
    implements
        PrimitiveSerializer<
          V1ProvidersSlugGet200ResponseAvailabilityStatusEnum
        > {
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
    V1ProvidersSlugGet200ResponseAvailabilityStatusEnum,
  ];
  @override
  final String wireName = 'V1ProvidersSlugGet200ResponseAvailabilityStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersSlugGet200ResponseAvailabilityStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  V1ProvidersSlugGet200ResponseAvailabilityStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => V1ProvidersSlugGet200ResponseAvailabilityStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$V1ProvidersSlugGet200Response extends V1ProvidersSlugGet200Response {
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
  final BuiltList<V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>
  spokenLanguages;
  @override
  final V1ProvidersSlugGet200ResponseBaseGovernorate baseGovernorate;
  @override
  final V1ProvidersSlugGet200ResponseBaseDelegation baseDelegation;
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final bool isVerified;
  @override
  final V1ProvidersSlugGet200ResponseAvailabilityStatusEnum availabilityStatus;
  @override
  final DateTime availableAgainAt;
  @override
  final bool acceptsEmergency;
  @override
  final int completionScore;
  @override
  final BuiltList<V1ProvidersSlugGet200ResponseCategoriesInner> categories;
  @override
  final BuiltList<V1ProvidersSlugGet200ResponseOfferingsInner> offerings;
  @override
  final BuiltList<V1ProvidersSlugGet200ResponseCoverageAreasInner>
  coverageAreas;
  @override
  final BuiltList<V1ProvidersSlugGet200ResponseGalleryInner> gallery;
  @override
  final V1ProvidersSlugGet200ResponseReviewAggregate reviewAggregate;

  factory _$V1ProvidersSlugGet200Response([
    void Function(V1ProvidersSlugGet200ResponseBuilder)? updates,
  ]) => (V1ProvidersSlugGet200ResponseBuilder()..update(updates))._build();

  _$V1ProvidersSlugGet200Response._({
    required this.id,
    required this.slug,
    required this.businessName,
    required this.headline,
    required this.bio,
    required this.yearsExperience,
    required this.spokenLanguages,
    required this.baseGovernorate,
    required this.baseDelegation,
    required this.latitude,
    required this.longitude,
    required this.isVerified,
    required this.availabilityStatus,
    required this.availableAgainAt,
    required this.acceptsEmergency,
    required this.completionScore,
    required this.categories,
    required this.offerings,
    required this.coverageAreas,
    required this.gallery,
    required this.reviewAggregate,
  }) : super._();
  @override
  V1ProvidersSlugGet200Response rebuild(
    void Function(V1ProvidersSlugGet200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1ProvidersSlugGet200ResponseBuilder toBuilder() =>
      V1ProvidersSlugGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersSlugGet200Response &&
        id == other.id &&
        slug == other.slug &&
        businessName == other.businessName &&
        headline == other.headline &&
        bio == other.bio &&
        yearsExperience == other.yearsExperience &&
        spokenLanguages == other.spokenLanguages &&
        baseGovernorate == other.baseGovernorate &&
        baseDelegation == other.baseDelegation &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        isVerified == other.isVerified &&
        availabilityStatus == other.availabilityStatus &&
        availableAgainAt == other.availableAgainAt &&
        acceptsEmergency == other.acceptsEmergency &&
        completionScore == other.completionScore &&
        categories == other.categories &&
        offerings == other.offerings &&
        coverageAreas == other.coverageAreas &&
        gallery == other.gallery &&
        reviewAggregate == other.reviewAggregate;
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
    _$hash = $jc(_$hash, spokenLanguages.hashCode);
    _$hash = $jc(_$hash, baseGovernorate.hashCode);
    _$hash = $jc(_$hash, baseDelegation.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, isVerified.hashCode);
    _$hash = $jc(_$hash, availabilityStatus.hashCode);
    _$hash = $jc(_$hash, availableAgainAt.hashCode);
    _$hash = $jc(_$hash, acceptsEmergency.hashCode);
    _$hash = $jc(_$hash, completionScore.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, offerings.hashCode);
    _$hash = $jc(_$hash, coverageAreas.hashCode);
    _$hash = $jc(_$hash, gallery.hashCode);
    _$hash = $jc(_$hash, reviewAggregate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1ProvidersSlugGet200Response')
          ..add('id', id)
          ..add('slug', slug)
          ..add('businessName', businessName)
          ..add('headline', headline)
          ..add('bio', bio)
          ..add('yearsExperience', yearsExperience)
          ..add('spokenLanguages', spokenLanguages)
          ..add('baseGovernorate', baseGovernorate)
          ..add('baseDelegation', baseDelegation)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('isVerified', isVerified)
          ..add('availabilityStatus', availabilityStatus)
          ..add('availableAgainAt', availableAgainAt)
          ..add('acceptsEmergency', acceptsEmergency)
          ..add('completionScore', completionScore)
          ..add('categories', categories)
          ..add('offerings', offerings)
          ..add('coverageAreas', coverageAreas)
          ..add('gallery', gallery)
          ..add('reviewAggregate', reviewAggregate))
        .toString();
  }
}

class V1ProvidersSlugGet200ResponseBuilder
    implements
        Builder<
          V1ProvidersSlugGet200Response,
          V1ProvidersSlugGet200ResponseBuilder
        > {
  _$V1ProvidersSlugGet200Response? _$v;

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

  ListBuilder<V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>?
  _spokenLanguages;
  ListBuilder<V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>
  get spokenLanguages => _$this._spokenLanguages ??=
      ListBuilder<V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>();
  set spokenLanguages(
    ListBuilder<V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>?
    spokenLanguages,
  ) => _$this._spokenLanguages = spokenLanguages;

  V1ProvidersSlugGet200ResponseBaseGovernorateBuilder? _baseGovernorate;
  V1ProvidersSlugGet200ResponseBaseGovernorateBuilder get baseGovernorate =>
      _$this._baseGovernorate ??=
          V1ProvidersSlugGet200ResponseBaseGovernorateBuilder();
  set baseGovernorate(
    V1ProvidersSlugGet200ResponseBaseGovernorateBuilder? baseGovernorate,
  ) => _$this._baseGovernorate = baseGovernorate;

  V1ProvidersSlugGet200ResponseBaseDelegationBuilder? _baseDelegation;
  V1ProvidersSlugGet200ResponseBaseDelegationBuilder get baseDelegation =>
      _$this._baseDelegation ??=
          V1ProvidersSlugGet200ResponseBaseDelegationBuilder();
  set baseDelegation(
    V1ProvidersSlugGet200ResponseBaseDelegationBuilder? baseDelegation,
  ) => _$this._baseDelegation = baseDelegation;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  bool? _isVerified;
  bool? get isVerified => _$this._isVerified;
  set isVerified(bool? isVerified) => _$this._isVerified = isVerified;

  V1ProvidersSlugGet200ResponseAvailabilityStatusEnum? _availabilityStatus;
  V1ProvidersSlugGet200ResponseAvailabilityStatusEnum? get availabilityStatus =>
      _$this._availabilityStatus;
  set availabilityStatus(
    V1ProvidersSlugGet200ResponseAvailabilityStatusEnum? availabilityStatus,
  ) => _$this._availabilityStatus = availabilityStatus;

  DateTime? _availableAgainAt;
  DateTime? get availableAgainAt => _$this._availableAgainAt;
  set availableAgainAt(DateTime? availableAgainAt) =>
      _$this._availableAgainAt = availableAgainAt;

  bool? _acceptsEmergency;
  bool? get acceptsEmergency => _$this._acceptsEmergency;
  set acceptsEmergency(bool? acceptsEmergency) =>
      _$this._acceptsEmergency = acceptsEmergency;

  int? _completionScore;
  int? get completionScore => _$this._completionScore;
  set completionScore(int? completionScore) =>
      _$this._completionScore = completionScore;

  ListBuilder<V1ProvidersSlugGet200ResponseCategoriesInner>? _categories;
  ListBuilder<V1ProvidersSlugGet200ResponseCategoriesInner> get categories =>
      _$this._categories ??=
          ListBuilder<V1ProvidersSlugGet200ResponseCategoriesInner>();
  set categories(
    ListBuilder<V1ProvidersSlugGet200ResponseCategoriesInner>? categories,
  ) => _$this._categories = categories;

  ListBuilder<V1ProvidersSlugGet200ResponseOfferingsInner>? _offerings;
  ListBuilder<V1ProvidersSlugGet200ResponseOfferingsInner> get offerings =>
      _$this._offerings ??=
          ListBuilder<V1ProvidersSlugGet200ResponseOfferingsInner>();
  set offerings(
    ListBuilder<V1ProvidersSlugGet200ResponseOfferingsInner>? offerings,
  ) => _$this._offerings = offerings;

  ListBuilder<V1ProvidersSlugGet200ResponseCoverageAreasInner>? _coverageAreas;
  ListBuilder<V1ProvidersSlugGet200ResponseCoverageAreasInner>
  get coverageAreas => _$this._coverageAreas ??=
      ListBuilder<V1ProvidersSlugGet200ResponseCoverageAreasInner>();
  set coverageAreas(
    ListBuilder<V1ProvidersSlugGet200ResponseCoverageAreasInner>? coverageAreas,
  ) => _$this._coverageAreas = coverageAreas;

  ListBuilder<V1ProvidersSlugGet200ResponseGalleryInner>? _gallery;
  ListBuilder<V1ProvidersSlugGet200ResponseGalleryInner> get gallery =>
      _$this._gallery ??=
          ListBuilder<V1ProvidersSlugGet200ResponseGalleryInner>();
  set gallery(
    ListBuilder<V1ProvidersSlugGet200ResponseGalleryInner>? gallery,
  ) => _$this._gallery = gallery;

  V1ProvidersSlugGet200ResponseReviewAggregateBuilder? _reviewAggregate;
  V1ProvidersSlugGet200ResponseReviewAggregateBuilder get reviewAggregate =>
      _$this._reviewAggregate ??=
          V1ProvidersSlugGet200ResponseReviewAggregateBuilder();
  set reviewAggregate(
    V1ProvidersSlugGet200ResponseReviewAggregateBuilder? reviewAggregate,
  ) => _$this._reviewAggregate = reviewAggregate;

  V1ProvidersSlugGet200ResponseBuilder() {
    V1ProvidersSlugGet200Response._defaults(this);
  }

  V1ProvidersSlugGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _slug = $v.slug;
      _businessName = $v.businessName;
      _headline = $v.headline;
      _bio = $v.bio;
      _yearsExperience = $v.yearsExperience;
      _spokenLanguages = $v.spokenLanguages.toBuilder();
      _baseGovernorate = $v.baseGovernorate.toBuilder();
      _baseDelegation = $v.baseDelegation.toBuilder();
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _isVerified = $v.isVerified;
      _availabilityStatus = $v.availabilityStatus;
      _availableAgainAt = $v.availableAgainAt;
      _acceptsEmergency = $v.acceptsEmergency;
      _completionScore = $v.completionScore;
      _categories = $v.categories.toBuilder();
      _offerings = $v.offerings.toBuilder();
      _coverageAreas = $v.coverageAreas.toBuilder();
      _gallery = $v.gallery.toBuilder();
      _reviewAggregate = $v.reviewAggregate.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersSlugGet200Response other) {
    _$v = other as _$V1ProvidersSlugGet200Response;
  }

  @override
  void update(void Function(V1ProvidersSlugGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersSlugGet200Response build() => _build();

  _$V1ProvidersSlugGet200Response _build() {
    _$V1ProvidersSlugGet200Response _$result;
    try {
      _$result =
          _$v ??
          _$V1ProvidersSlugGet200Response._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'V1ProvidersSlugGet200Response',
              'id',
            ),
            slug: BuiltValueNullFieldError.checkNotNull(
              slug,
              r'V1ProvidersSlugGet200Response',
              'slug',
            ),
            businessName: BuiltValueNullFieldError.checkNotNull(
              businessName,
              r'V1ProvidersSlugGet200Response',
              'businessName',
            ),
            headline: BuiltValueNullFieldError.checkNotNull(
              headline,
              r'V1ProvidersSlugGet200Response',
              'headline',
            ),
            bio: BuiltValueNullFieldError.checkNotNull(
              bio,
              r'V1ProvidersSlugGet200Response',
              'bio',
            ),
            yearsExperience: BuiltValueNullFieldError.checkNotNull(
              yearsExperience,
              r'V1ProvidersSlugGet200Response',
              'yearsExperience',
            ),
            spokenLanguages: spokenLanguages.build(),
            baseGovernorate: baseGovernorate.build(),
            baseDelegation: baseDelegation.build(),
            latitude: BuiltValueNullFieldError.checkNotNull(
              latitude,
              r'V1ProvidersSlugGet200Response',
              'latitude',
            ),
            longitude: BuiltValueNullFieldError.checkNotNull(
              longitude,
              r'V1ProvidersSlugGet200Response',
              'longitude',
            ),
            isVerified: BuiltValueNullFieldError.checkNotNull(
              isVerified,
              r'V1ProvidersSlugGet200Response',
              'isVerified',
            ),
            availabilityStatus: BuiltValueNullFieldError.checkNotNull(
              availabilityStatus,
              r'V1ProvidersSlugGet200Response',
              'availabilityStatus',
            ),
            availableAgainAt: BuiltValueNullFieldError.checkNotNull(
              availableAgainAt,
              r'V1ProvidersSlugGet200Response',
              'availableAgainAt',
            ),
            acceptsEmergency: BuiltValueNullFieldError.checkNotNull(
              acceptsEmergency,
              r'V1ProvidersSlugGet200Response',
              'acceptsEmergency',
            ),
            completionScore: BuiltValueNullFieldError.checkNotNull(
              completionScore,
              r'V1ProvidersSlugGet200Response',
              'completionScore',
            ),
            categories: categories.build(),
            offerings: offerings.build(),
            coverageAreas: coverageAreas.build(),
            gallery: gallery.build(),
            reviewAggregate: reviewAggregate.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'spokenLanguages';
        spokenLanguages.build();
        _$failedField = 'baseGovernorate';
        baseGovernorate.build();
        _$failedField = 'baseDelegation';
        baseDelegation.build();

        _$failedField = 'categories';
        categories.build();
        _$failedField = 'offerings';
        offerings.build();
        _$failedField = 'coverageAreas';
        coverageAreas.build();
        _$failedField = 'gallery';
        gallery.build();
        _$failedField = 'reviewAggregate';
        reviewAggregate.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'V1ProvidersSlugGet200Response',
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

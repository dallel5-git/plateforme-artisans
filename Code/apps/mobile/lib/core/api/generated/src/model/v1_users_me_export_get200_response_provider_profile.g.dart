// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_users_me_export_get200_response_provider_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1UsersMeExportGet200ResponseProviderProfile
    extends V1UsersMeExportGet200ResponseProviderProfile {
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
  final BuiltList<String> spokenLanguages;
  @override
  final String baseGovernorate;
  @override
  final String baseDelegation;
  @override
  final String publicationStatus;
  @override
  final String availabilityStatus;
  @override
  final bool isVerified;
  @override
  final DateTime verifiedAt;
  @override
  final num ratingAvg;
  @override
  final int ratingCount;
  @override
  final BuiltList<V1UsersMeExportGet200ResponseProviderProfileCategoriesInner>
      categories;
  @override
  final BuiltList<V1UsersMeExportGet200ResponseProviderProfileOfferingsInner>
      offerings;
  @override
  final BuiltList<
          V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner>
      coverageAreas;
  @override
  final int portfolioCount;

  factory _$V1UsersMeExportGet200ResponseProviderProfile(
          [void Function(V1UsersMeExportGet200ResponseProviderProfileBuilder)?
              updates]) =>
      (V1UsersMeExportGet200ResponseProviderProfileBuilder()..update(updates))
          ._build();

  _$V1UsersMeExportGet200ResponseProviderProfile._(
      {required this.id,
      required this.slug,
      required this.businessName,
      required this.headline,
      required this.bio,
      required this.yearsExperience,
      required this.whatsappPhone,
      required this.publicPhone,
      required this.spokenLanguages,
      required this.baseGovernorate,
      required this.baseDelegation,
      required this.publicationStatus,
      required this.availabilityStatus,
      required this.isVerified,
      required this.verifiedAt,
      required this.ratingAvg,
      required this.ratingCount,
      required this.categories,
      required this.offerings,
      required this.coverageAreas,
      required this.portfolioCount})
      : super._();
  @override
  V1UsersMeExportGet200ResponseProviderProfile rebuild(
          void Function(V1UsersMeExportGet200ResponseProviderProfileBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1UsersMeExportGet200ResponseProviderProfileBuilder toBuilder() =>
      V1UsersMeExportGet200ResponseProviderProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1UsersMeExportGet200ResponseProviderProfile &&
        id == other.id &&
        slug == other.slug &&
        businessName == other.businessName &&
        headline == other.headline &&
        bio == other.bio &&
        yearsExperience == other.yearsExperience &&
        whatsappPhone == other.whatsappPhone &&
        publicPhone == other.publicPhone &&
        spokenLanguages == other.spokenLanguages &&
        baseGovernorate == other.baseGovernorate &&
        baseDelegation == other.baseDelegation &&
        publicationStatus == other.publicationStatus &&
        availabilityStatus == other.availabilityStatus &&
        isVerified == other.isVerified &&
        verifiedAt == other.verifiedAt &&
        ratingAvg == other.ratingAvg &&
        ratingCount == other.ratingCount &&
        categories == other.categories &&
        offerings == other.offerings &&
        coverageAreas == other.coverageAreas &&
        portfolioCount == other.portfolioCount;
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
    _$hash = $jc(_$hash, baseGovernorate.hashCode);
    _$hash = $jc(_$hash, baseDelegation.hashCode);
    _$hash = $jc(_$hash, publicationStatus.hashCode);
    _$hash = $jc(_$hash, availabilityStatus.hashCode);
    _$hash = $jc(_$hash, isVerified.hashCode);
    _$hash = $jc(_$hash, verifiedAt.hashCode);
    _$hash = $jc(_$hash, ratingAvg.hashCode);
    _$hash = $jc(_$hash, ratingCount.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, offerings.hashCode);
    _$hash = $jc(_$hash, coverageAreas.hashCode);
    _$hash = $jc(_$hash, portfolioCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1UsersMeExportGet200ResponseProviderProfile')
          ..add('id', id)
          ..add('slug', slug)
          ..add('businessName', businessName)
          ..add('headline', headline)
          ..add('bio', bio)
          ..add('yearsExperience', yearsExperience)
          ..add('whatsappPhone', whatsappPhone)
          ..add('publicPhone', publicPhone)
          ..add('spokenLanguages', spokenLanguages)
          ..add('baseGovernorate', baseGovernorate)
          ..add('baseDelegation', baseDelegation)
          ..add('publicationStatus', publicationStatus)
          ..add('availabilityStatus', availabilityStatus)
          ..add('isVerified', isVerified)
          ..add('verifiedAt', verifiedAt)
          ..add('ratingAvg', ratingAvg)
          ..add('ratingCount', ratingCount)
          ..add('categories', categories)
          ..add('offerings', offerings)
          ..add('coverageAreas', coverageAreas)
          ..add('portfolioCount', portfolioCount))
        .toString();
  }
}

class V1UsersMeExportGet200ResponseProviderProfileBuilder
    implements
        Builder<V1UsersMeExportGet200ResponseProviderProfile,
            V1UsersMeExportGet200ResponseProviderProfileBuilder> {
  _$V1UsersMeExportGet200ResponseProviderProfile? _$v;

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

  ListBuilder<String>? _spokenLanguages;
  ListBuilder<String> get spokenLanguages =>
      _$this._spokenLanguages ??= ListBuilder<String>();
  set spokenLanguages(ListBuilder<String>? spokenLanguages) =>
      _$this._spokenLanguages = spokenLanguages;

  String? _baseGovernorate;
  String? get baseGovernorate => _$this._baseGovernorate;
  set baseGovernorate(String? baseGovernorate) =>
      _$this._baseGovernorate = baseGovernorate;

  String? _baseDelegation;
  String? get baseDelegation => _$this._baseDelegation;
  set baseDelegation(String? baseDelegation) =>
      _$this._baseDelegation = baseDelegation;

  String? _publicationStatus;
  String? get publicationStatus => _$this._publicationStatus;
  set publicationStatus(String? publicationStatus) =>
      _$this._publicationStatus = publicationStatus;

  String? _availabilityStatus;
  String? get availabilityStatus => _$this._availabilityStatus;
  set availabilityStatus(String? availabilityStatus) =>
      _$this._availabilityStatus = availabilityStatus;

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

  ListBuilder<V1UsersMeExportGet200ResponseProviderProfileCategoriesInner>?
      _categories;
  ListBuilder<V1UsersMeExportGet200ResponseProviderProfileCategoriesInner>
      get categories => _$this._categories ??= ListBuilder<
          V1UsersMeExportGet200ResponseProviderProfileCategoriesInner>();
  set categories(
          ListBuilder<
                  V1UsersMeExportGet200ResponseProviderProfileCategoriesInner>?
              categories) =>
      _$this._categories = categories;

  ListBuilder<V1UsersMeExportGet200ResponseProviderProfileOfferingsInner>?
      _offerings;
  ListBuilder<V1UsersMeExportGet200ResponseProviderProfileOfferingsInner>
      get offerings => _$this._offerings ??= ListBuilder<
          V1UsersMeExportGet200ResponseProviderProfileOfferingsInner>();
  set offerings(
          ListBuilder<
                  V1UsersMeExportGet200ResponseProviderProfileOfferingsInner>?
              offerings) =>
      _$this._offerings = offerings;

  ListBuilder<V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner>?
      _coverageAreas;
  ListBuilder<V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner>
      get coverageAreas => _$this._coverageAreas ??= ListBuilder<
          V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner>();
  set coverageAreas(
          ListBuilder<
                  V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner>?
              coverageAreas) =>
      _$this._coverageAreas = coverageAreas;

  int? _portfolioCount;
  int? get portfolioCount => _$this._portfolioCount;
  set portfolioCount(int? portfolioCount) =>
      _$this._portfolioCount = portfolioCount;

  V1UsersMeExportGet200ResponseProviderProfileBuilder() {
    V1UsersMeExportGet200ResponseProviderProfile._defaults(this);
  }

  V1UsersMeExportGet200ResponseProviderProfileBuilder get _$this {
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
      _baseGovernorate = $v.baseGovernorate;
      _baseDelegation = $v.baseDelegation;
      _publicationStatus = $v.publicationStatus;
      _availabilityStatus = $v.availabilityStatus;
      _isVerified = $v.isVerified;
      _verifiedAt = $v.verifiedAt;
      _ratingAvg = $v.ratingAvg;
      _ratingCount = $v.ratingCount;
      _categories = $v.categories.toBuilder();
      _offerings = $v.offerings.toBuilder();
      _coverageAreas = $v.coverageAreas.toBuilder();
      _portfolioCount = $v.portfolioCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1UsersMeExportGet200ResponseProviderProfile other) {
    _$v = other as _$V1UsersMeExportGet200ResponseProviderProfile;
  }

  @override
  void update(
      void Function(V1UsersMeExportGet200ResponseProviderProfileBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1UsersMeExportGet200ResponseProviderProfile build() => _build();

  _$V1UsersMeExportGet200ResponseProviderProfile _build() {
    _$V1UsersMeExportGet200ResponseProviderProfile _$result;
    try {
      _$result = _$v ??
          _$V1UsersMeExportGet200ResponseProviderProfile._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'V1UsersMeExportGet200ResponseProviderProfile', 'id'),
            slug: BuiltValueNullFieldError.checkNotNull(
                slug, r'V1UsersMeExportGet200ResponseProviderProfile', 'slug'),
            businessName: BuiltValueNullFieldError.checkNotNull(
                businessName,
                r'V1UsersMeExportGet200ResponseProviderProfile',
                'businessName'),
            headline: BuiltValueNullFieldError.checkNotNull(headline,
                r'V1UsersMeExportGet200ResponseProviderProfile', 'headline'),
            bio: BuiltValueNullFieldError.checkNotNull(
                bio, r'V1UsersMeExportGet200ResponseProviderProfile', 'bio'),
            yearsExperience: BuiltValueNullFieldError.checkNotNull(
                yearsExperience,
                r'V1UsersMeExportGet200ResponseProviderProfile',
                'yearsExperience'),
            whatsappPhone: BuiltValueNullFieldError.checkNotNull(
                whatsappPhone,
                r'V1UsersMeExportGet200ResponseProviderProfile',
                'whatsappPhone'),
            publicPhone: BuiltValueNullFieldError.checkNotNull(publicPhone,
                r'V1UsersMeExportGet200ResponseProviderProfile', 'publicPhone'),
            spokenLanguages: spokenLanguages.build(),
            baseGovernorate: BuiltValueNullFieldError.checkNotNull(
                baseGovernorate,
                r'V1UsersMeExportGet200ResponseProviderProfile',
                'baseGovernorate'),
            baseDelegation: BuiltValueNullFieldError.checkNotNull(
                baseDelegation,
                r'V1UsersMeExportGet200ResponseProviderProfile',
                'baseDelegation'),
            publicationStatus: BuiltValueNullFieldError.checkNotNull(
                publicationStatus,
                r'V1UsersMeExportGet200ResponseProviderProfile',
                'publicationStatus'),
            availabilityStatus: BuiltValueNullFieldError.checkNotNull(
                availabilityStatus,
                r'V1UsersMeExportGet200ResponseProviderProfile',
                'availabilityStatus'),
            isVerified: BuiltValueNullFieldError.checkNotNull(isVerified,
                r'V1UsersMeExportGet200ResponseProviderProfile', 'isVerified'),
            verifiedAt: BuiltValueNullFieldError.checkNotNull(verifiedAt,
                r'V1UsersMeExportGet200ResponseProviderProfile', 'verifiedAt'),
            ratingAvg: BuiltValueNullFieldError.checkNotNull(ratingAvg,
                r'V1UsersMeExportGet200ResponseProviderProfile', 'ratingAvg'),
            ratingCount: BuiltValueNullFieldError.checkNotNull(ratingCount,
                r'V1UsersMeExportGet200ResponseProviderProfile', 'ratingCount'),
            categories: categories.build(),
            offerings: offerings.build(),
            coverageAreas: coverageAreas.build(),
            portfolioCount: BuiltValueNullFieldError.checkNotNull(
                portfolioCount,
                r'V1UsersMeExportGet200ResponseProviderProfile',
                'portfolioCount'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'spokenLanguages';
        spokenLanguages.build();

        _$failedField = 'categories';
        categories.build();
        _$failedField = 'offerings';
        offerings.build();
        _$failedField = 'coverageAreas';
        coverageAreas.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1UsersMeExportGet200ResponseProviderProfile',
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

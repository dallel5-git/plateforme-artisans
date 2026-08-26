// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_search_get200_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum
    _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum_AVAILABLE =
    const V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum._(
        'AVAILABLE');
const V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum
    _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum_BUSY =
    const V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum._(
        'BUSY');
const V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum
    _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum_ON_HOLIDAY =
    const V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum._(
        'ON_HOLIDAY');

V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum
    _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'AVAILABLE':
      return _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum_AVAILABLE;
    case 'BUSY':
      return _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum_BUSY;
    case 'ON_HOLIDAY':
      return _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum_ON_HOLIDAY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum>
    _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnumValues =
    BuiltSet<
        V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum>(const <V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum>[
  _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum_AVAILABLE,
  _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum_BUSY,
  _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum_ON_HOLIDAY,
]);

Serializer<V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum>
    _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnumSerializer =
    _$V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnumSerializer();

class _$V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnumSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum> {
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
    V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum
  ];
  @override
  final String wireName =
      'V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum';

  @override
  Object serialize(
          Serializers serializers,
          V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum
              object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ProvidersSearchGet200ResponseItemsInner
    extends V1ProvidersSearchGet200ResponseItemsInner {
  @override
  final String id;
  @override
  final String slug;
  @override
  final String businessName;
  @override
  final String headline;
  @override
  final bool isVerified;
  @override
  final num ratingAvg;
  @override
  final int ratingCount;
  @override
  final int completionScore;
  @override
  final V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum
      availabilityStatus;
  @override
  final BuiltList<V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner>
      categories;
  @override
  final num? score;
  @override
  final V1ProvidersSearchGet200ResponseItemsInnerMatchReason? matchReason;

  factory _$V1ProvidersSearchGet200ResponseItemsInner(
          [void Function(V1ProvidersSearchGet200ResponseItemsInnerBuilder)?
              updates]) =>
      (V1ProvidersSearchGet200ResponseItemsInnerBuilder()..update(updates))
          ._build();

  _$V1ProvidersSearchGet200ResponseItemsInner._(
      {required this.id,
      required this.slug,
      required this.businessName,
      required this.headline,
      required this.isVerified,
      required this.ratingAvg,
      required this.ratingCount,
      required this.completionScore,
      required this.availabilityStatus,
      required this.categories,
      this.score,
      this.matchReason})
      : super._();
  @override
  V1ProvidersSearchGet200ResponseItemsInner rebuild(
          void Function(V1ProvidersSearchGet200ResponseItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersSearchGet200ResponseItemsInnerBuilder toBuilder() =>
      V1ProvidersSearchGet200ResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersSearchGet200ResponseItemsInner &&
        id == other.id &&
        slug == other.slug &&
        businessName == other.businessName &&
        headline == other.headline &&
        isVerified == other.isVerified &&
        ratingAvg == other.ratingAvg &&
        ratingCount == other.ratingCount &&
        completionScore == other.completionScore &&
        availabilityStatus == other.availabilityStatus &&
        categories == other.categories &&
        score == other.score &&
        matchReason == other.matchReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, businessName.hashCode);
    _$hash = $jc(_$hash, headline.hashCode);
    _$hash = $jc(_$hash, isVerified.hashCode);
    _$hash = $jc(_$hash, ratingAvg.hashCode);
    _$hash = $jc(_$hash, ratingCount.hashCode);
    _$hash = $jc(_$hash, completionScore.hashCode);
    _$hash = $jc(_$hash, availabilityStatus.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jc(_$hash, matchReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersSearchGet200ResponseItemsInner')
          ..add('id', id)
          ..add('slug', slug)
          ..add('businessName', businessName)
          ..add('headline', headline)
          ..add('isVerified', isVerified)
          ..add('ratingAvg', ratingAvg)
          ..add('ratingCount', ratingCount)
          ..add('completionScore', completionScore)
          ..add('availabilityStatus', availabilityStatus)
          ..add('categories', categories)
          ..add('score', score)
          ..add('matchReason', matchReason))
        .toString();
  }
}

class V1ProvidersSearchGet200ResponseItemsInnerBuilder
    implements
        Builder<V1ProvidersSearchGet200ResponseItemsInner,
            V1ProvidersSearchGet200ResponseItemsInnerBuilder> {
  _$V1ProvidersSearchGet200ResponseItemsInner? _$v;

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

  bool? _isVerified;
  bool? get isVerified => _$this._isVerified;
  set isVerified(bool? isVerified) => _$this._isVerified = isVerified;

  num? _ratingAvg;
  num? get ratingAvg => _$this._ratingAvg;
  set ratingAvg(num? ratingAvg) => _$this._ratingAvg = ratingAvg;

  int? _ratingCount;
  int? get ratingCount => _$this._ratingCount;
  set ratingCount(int? ratingCount) => _$this._ratingCount = ratingCount;

  int? _completionScore;
  int? get completionScore => _$this._completionScore;
  set completionScore(int? completionScore) =>
      _$this._completionScore = completionScore;

  V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum?
      _availabilityStatus;
  V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum?
      get availabilityStatus => _$this._availabilityStatus;
  set availabilityStatus(
          V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum?
              availabilityStatus) =>
      _$this._availabilityStatus = availabilityStatus;

  ListBuilder<V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner>?
      _categories;
  ListBuilder<V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner>
      get categories => _$this._categories ??= ListBuilder<
          V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner>();
  set categories(
          ListBuilder<V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner>?
              categories) =>
      _$this._categories = categories;

  num? _score;
  num? get score => _$this._score;
  set score(num? score) => _$this._score = score;

  V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder? _matchReason;
  V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder get matchReason =>
      _$this._matchReason ??=
          V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder();
  set matchReason(
          V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder?
              matchReason) =>
      _$this._matchReason = matchReason;

  V1ProvidersSearchGet200ResponseItemsInnerBuilder() {
    V1ProvidersSearchGet200ResponseItemsInner._defaults(this);
  }

  V1ProvidersSearchGet200ResponseItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _slug = $v.slug;
      _businessName = $v.businessName;
      _headline = $v.headline;
      _isVerified = $v.isVerified;
      _ratingAvg = $v.ratingAvg;
      _ratingCount = $v.ratingCount;
      _completionScore = $v.completionScore;
      _availabilityStatus = $v.availabilityStatus;
      _categories = $v.categories.toBuilder();
      _score = $v.score;
      _matchReason = $v.matchReason?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersSearchGet200ResponseItemsInner other) {
    _$v = other as _$V1ProvidersSearchGet200ResponseItemsInner;
  }

  @override
  void update(
      void Function(V1ProvidersSearchGet200ResponseItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersSearchGet200ResponseItemsInner build() => _build();

  _$V1ProvidersSearchGet200ResponseItemsInner _build() {
    _$V1ProvidersSearchGet200ResponseItemsInner _$result;
    try {
      _$result = _$v ??
          _$V1ProvidersSearchGet200ResponseItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'V1ProvidersSearchGet200ResponseItemsInner', 'id'),
            slug: BuiltValueNullFieldError.checkNotNull(
                slug, r'V1ProvidersSearchGet200ResponseItemsInner', 'slug'),
            businessName: BuiltValueNullFieldError.checkNotNull(businessName,
                r'V1ProvidersSearchGet200ResponseItemsInner', 'businessName'),
            headline: BuiltValueNullFieldError.checkNotNull(headline,
                r'V1ProvidersSearchGet200ResponseItemsInner', 'headline'),
            isVerified: BuiltValueNullFieldError.checkNotNull(isVerified,
                r'V1ProvidersSearchGet200ResponseItemsInner', 'isVerified'),
            ratingAvg: BuiltValueNullFieldError.checkNotNull(ratingAvg,
                r'V1ProvidersSearchGet200ResponseItemsInner', 'ratingAvg'),
            ratingCount: BuiltValueNullFieldError.checkNotNull(ratingCount,
                r'V1ProvidersSearchGet200ResponseItemsInner', 'ratingCount'),
            completionScore: BuiltValueNullFieldError.checkNotNull(
                completionScore,
                r'V1ProvidersSearchGet200ResponseItemsInner',
                'completionScore'),
            availabilityStatus: BuiltValueNullFieldError.checkNotNull(
                availabilityStatus,
                r'V1ProvidersSearchGet200ResponseItemsInner',
                'availabilityStatus'),
            categories: categories.build(),
            score: score,
            matchReason: _matchReason?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categories';
        categories.build();

        _$failedField = 'matchReason';
        _matchReason?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1ProvidersSearchGet200ResponseItemsInner',
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

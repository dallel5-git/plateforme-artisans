// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_favorites_get200_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum
_$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum_AVAILABLE =
    const V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum._(
      'AVAILABLE',
    );
const V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum
_$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum_BUSY =
    const V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum._('BUSY');
const V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum
_$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum_ON_HOLIDAY =
    const V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum._(
      'ON_HOLIDAY',
    );

V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum
_$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'AVAILABLE':
      return _$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum_AVAILABLE;
    case 'BUSY':
      return _$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum_BUSY;
    case 'ON_HOLIDAY':
      return _$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum_ON_HOLIDAY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum>
_$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnumValues =
    BuiltSet<V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum>(
      const <V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum>[
        _$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum_AVAILABLE,
        _$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum_BUSY,
        _$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum_ON_HOLIDAY,
      ],
    );

Serializer<V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum>
_$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnumSerializer =
    _$V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnumSerializer();

class _$V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnumSerializer
    implements
        PrimitiveSerializer<
          V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum
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
    V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum,
  ];
  @override
  final String wireName =
      'V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$V1FavoritesGet200ResponseItemsInner
    extends V1FavoritesGet200ResponseItemsInner {
  @override
  final String providerId;
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
  final num ratingCount;
  @override
  final V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum
  availabilityStatus;
  @override
  final DateTime favoritedAt;

  factory _$V1FavoritesGet200ResponseItemsInner([
    void Function(V1FavoritesGet200ResponseItemsInnerBuilder)? updates,
  ]) =>
      (V1FavoritesGet200ResponseItemsInnerBuilder()..update(updates))._build();

  _$V1FavoritesGet200ResponseItemsInner._({
    required this.providerId,
    required this.slug,
    required this.businessName,
    required this.headline,
    required this.isVerified,
    required this.ratingAvg,
    required this.ratingCount,
    required this.availabilityStatus,
    required this.favoritedAt,
  }) : super._();
  @override
  V1FavoritesGet200ResponseItemsInner rebuild(
    void Function(V1FavoritesGet200ResponseItemsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1FavoritesGet200ResponseItemsInnerBuilder toBuilder() =>
      V1FavoritesGet200ResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1FavoritesGet200ResponseItemsInner &&
        providerId == other.providerId &&
        slug == other.slug &&
        businessName == other.businessName &&
        headline == other.headline &&
        isVerified == other.isVerified &&
        ratingAvg == other.ratingAvg &&
        ratingCount == other.ratingCount &&
        availabilityStatus == other.availabilityStatus &&
        favoritedAt == other.favoritedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, providerId.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, businessName.hashCode);
    _$hash = $jc(_$hash, headline.hashCode);
    _$hash = $jc(_$hash, isVerified.hashCode);
    _$hash = $jc(_$hash, ratingAvg.hashCode);
    _$hash = $jc(_$hash, ratingCount.hashCode);
    _$hash = $jc(_$hash, availabilityStatus.hashCode);
    _$hash = $jc(_$hash, favoritedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1FavoritesGet200ResponseItemsInner')
          ..add('providerId', providerId)
          ..add('slug', slug)
          ..add('businessName', businessName)
          ..add('headline', headline)
          ..add('isVerified', isVerified)
          ..add('ratingAvg', ratingAvg)
          ..add('ratingCount', ratingCount)
          ..add('availabilityStatus', availabilityStatus)
          ..add('favoritedAt', favoritedAt))
        .toString();
  }
}

class V1FavoritesGet200ResponseItemsInnerBuilder
    implements
        Builder<
          V1FavoritesGet200ResponseItemsInner,
          V1FavoritesGet200ResponseItemsInnerBuilder
        > {
  _$V1FavoritesGet200ResponseItemsInner? _$v;

  String? _providerId;
  String? get providerId => _$this._providerId;
  set providerId(String? providerId) => _$this._providerId = providerId;

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

  num? _ratingCount;
  num? get ratingCount => _$this._ratingCount;
  set ratingCount(num? ratingCount) => _$this._ratingCount = ratingCount;

  V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum?
  _availabilityStatus;
  V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum?
  get availabilityStatus => _$this._availabilityStatus;
  set availabilityStatus(
    V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum?
    availabilityStatus,
  ) => _$this._availabilityStatus = availabilityStatus;

  DateTime? _favoritedAt;
  DateTime? get favoritedAt => _$this._favoritedAt;
  set favoritedAt(DateTime? favoritedAt) => _$this._favoritedAt = favoritedAt;

  V1FavoritesGet200ResponseItemsInnerBuilder() {
    V1FavoritesGet200ResponseItemsInner._defaults(this);
  }

  V1FavoritesGet200ResponseItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _providerId = $v.providerId;
      _slug = $v.slug;
      _businessName = $v.businessName;
      _headline = $v.headline;
      _isVerified = $v.isVerified;
      _ratingAvg = $v.ratingAvg;
      _ratingCount = $v.ratingCount;
      _availabilityStatus = $v.availabilityStatus;
      _favoritedAt = $v.favoritedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1FavoritesGet200ResponseItemsInner other) {
    _$v = other as _$V1FavoritesGet200ResponseItemsInner;
  }

  @override
  void update(
    void Function(V1FavoritesGet200ResponseItemsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  V1FavoritesGet200ResponseItemsInner build() => _build();

  _$V1FavoritesGet200ResponseItemsInner _build() {
    final _$result =
        _$v ??
        _$V1FavoritesGet200ResponseItemsInner._(
          providerId: BuiltValueNullFieldError.checkNotNull(
            providerId,
            r'V1FavoritesGet200ResponseItemsInner',
            'providerId',
          ),
          slug: BuiltValueNullFieldError.checkNotNull(
            slug,
            r'V1FavoritesGet200ResponseItemsInner',
            'slug',
          ),
          businessName: BuiltValueNullFieldError.checkNotNull(
            businessName,
            r'V1FavoritesGet200ResponseItemsInner',
            'businessName',
          ),
          headline: BuiltValueNullFieldError.checkNotNull(
            headline,
            r'V1FavoritesGet200ResponseItemsInner',
            'headline',
          ),
          isVerified: BuiltValueNullFieldError.checkNotNull(
            isVerified,
            r'V1FavoritesGet200ResponseItemsInner',
            'isVerified',
          ),
          ratingAvg: BuiltValueNullFieldError.checkNotNull(
            ratingAvg,
            r'V1FavoritesGet200ResponseItemsInner',
            'ratingAvg',
          ),
          ratingCount: BuiltValueNullFieldError.checkNotNull(
            ratingCount,
            r'V1FavoritesGet200ResponseItemsInner',
            'ratingCount',
          ),
          availabilityStatus: BuiltValueNullFieldError.checkNotNull(
            availabilityStatus,
            r'V1FavoritesGet200ResponseItemsInner',
            'availabilityStatus',
          ),
          favoritedAt: BuiltValueNullFieldError.checkNotNull(
            favoritedAt,
            r'V1FavoritesGet200ResponseItemsInner',
            'favoritedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

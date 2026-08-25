// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_slug_get200_response_offerings_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum
_$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_FIXED =
    const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum._('FIXED');
const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum
_$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_HOUR =
    const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum._('HOUR');
const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum
_$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_DAY =
    const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum._('DAY');
const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum
_$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_SQUARE_METER =
    const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum._(
      'SQUARE_METER',
    );
const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum
_$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_LINEAR_METER =
    const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum._(
      'LINEAR_METER',
    );
const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum
_$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_ON_QUOTE =
    const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum._(
      'ON_QUOTE',
    );

V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum
_$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnumValueOf(String name) {
  switch (name) {
    case 'FIXED':
      return _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_FIXED;
    case 'HOUR':
      return _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_HOUR;
    case 'DAY':
      return _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_DAY;
    case 'SQUARE_METER':
      return _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_SQUARE_METER;
    case 'LINEAR_METER':
      return _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_LINEAR_METER;
    case 'ON_QUOTE':
      return _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_ON_QUOTE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum>
_$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnumValues =
    BuiltSet<V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum>(
      const <V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum>[
        _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_FIXED,
        _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_HOUR,
        _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_DAY,
        _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_SQUARE_METER,
        _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_LINEAR_METER,
        _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_ON_QUOTE,
      ],
    );

Serializer<V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum>
_$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnumSerializer =
    _$V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnumSerializer();

class _$V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnumSerializer
    implements
        PrimitiveSerializer<
          V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FIXED': 'FIXED',
    'HOUR': 'HOUR',
    'DAY': 'DAY',
    'SQUARE_METER': 'SQUARE_METER',
    'LINEAR_METER': 'LINEAR_METER',
    'ON_QUOTE': 'ON_QUOTE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FIXED': 'FIXED',
    'HOUR': 'HOUR',
    'DAY': 'DAY',
    'SQUARE_METER': 'SQUARE_METER',
    'LINEAR_METER': 'LINEAR_METER',
    'ON_QUOTE': 'ON_QUOTE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum,
  ];
  @override
  final String wireName =
      'V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum';

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$V1ProvidersSlugGet200ResponseOfferingsInner
    extends V1ProvidersSlugGet200ResponseOfferingsInner {
  @override
  final String id;
  @override
  final V1ProvidersSlugGet200ResponseOfferingsInnerCategory category;
  @override
  final String titleFr;
  @override
  final String titleAr;
  @override
  final String description;
  @override
  final num priceMin;
  @override
  final num priceMax;
  @override
  final V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum priceUnit;
  @override
  final bool isNegotiable;
  @override
  final String displayPrice;

  factory _$V1ProvidersSlugGet200ResponseOfferingsInner([
    void Function(V1ProvidersSlugGet200ResponseOfferingsInnerBuilder)? updates,
  ]) => (V1ProvidersSlugGet200ResponseOfferingsInnerBuilder()..update(updates))
      ._build();

  _$V1ProvidersSlugGet200ResponseOfferingsInner._({
    required this.id,
    required this.category,
    required this.titleFr,
    required this.titleAr,
    required this.description,
    required this.priceMin,
    required this.priceMax,
    required this.priceUnit,
    required this.isNegotiable,
    required this.displayPrice,
  }) : super._();
  @override
  V1ProvidersSlugGet200ResponseOfferingsInner rebuild(
    void Function(V1ProvidersSlugGet200ResponseOfferingsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1ProvidersSlugGet200ResponseOfferingsInnerBuilder toBuilder() =>
      V1ProvidersSlugGet200ResponseOfferingsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersSlugGet200ResponseOfferingsInner &&
        id == other.id &&
        category == other.category &&
        titleFr == other.titleFr &&
        titleAr == other.titleAr &&
        description == other.description &&
        priceMin == other.priceMin &&
        priceMax == other.priceMax &&
        priceUnit == other.priceUnit &&
        isNegotiable == other.isNegotiable &&
        displayPrice == other.displayPrice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, titleFr.hashCode);
    _$hash = $jc(_$hash, titleAr.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, priceMin.hashCode);
    _$hash = $jc(_$hash, priceMax.hashCode);
    _$hash = $jc(_$hash, priceUnit.hashCode);
    _$hash = $jc(_$hash, isNegotiable.hashCode);
    _$hash = $jc(_$hash, displayPrice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersSlugGet200ResponseOfferingsInner',
          )
          ..add('id', id)
          ..add('category', category)
          ..add('titleFr', titleFr)
          ..add('titleAr', titleAr)
          ..add('description', description)
          ..add('priceMin', priceMin)
          ..add('priceMax', priceMax)
          ..add('priceUnit', priceUnit)
          ..add('isNegotiable', isNegotiable)
          ..add('displayPrice', displayPrice))
        .toString();
  }
}

class V1ProvidersSlugGet200ResponseOfferingsInnerBuilder
    implements
        Builder<
          V1ProvidersSlugGet200ResponseOfferingsInner,
          V1ProvidersSlugGet200ResponseOfferingsInnerBuilder
        > {
  _$V1ProvidersSlugGet200ResponseOfferingsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder? _category;
  V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder get category =>
      _$this._category ??=
          V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder();
  set category(
    V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder? category,
  ) => _$this._category = category;

  String? _titleFr;
  String? get titleFr => _$this._titleFr;
  set titleFr(String? titleFr) => _$this._titleFr = titleFr;

  String? _titleAr;
  String? get titleAr => _$this._titleAr;
  set titleAr(String? titleAr) => _$this._titleAr = titleAr;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  num? _priceMin;
  num? get priceMin => _$this._priceMin;
  set priceMin(num? priceMin) => _$this._priceMin = priceMin;

  num? _priceMax;
  num? get priceMax => _$this._priceMax;
  set priceMax(num? priceMax) => _$this._priceMax = priceMax;

  V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum? _priceUnit;
  V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum? get priceUnit =>
      _$this._priceUnit;
  set priceUnit(
    V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum? priceUnit,
  ) => _$this._priceUnit = priceUnit;

  bool? _isNegotiable;
  bool? get isNegotiable => _$this._isNegotiable;
  set isNegotiable(bool? isNegotiable) => _$this._isNegotiable = isNegotiable;

  String? _displayPrice;
  String? get displayPrice => _$this._displayPrice;
  set displayPrice(String? displayPrice) => _$this._displayPrice = displayPrice;

  V1ProvidersSlugGet200ResponseOfferingsInnerBuilder() {
    V1ProvidersSlugGet200ResponseOfferingsInner._defaults(this);
  }

  V1ProvidersSlugGet200ResponseOfferingsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _category = $v.category.toBuilder();
      _titleFr = $v.titleFr;
      _titleAr = $v.titleAr;
      _description = $v.description;
      _priceMin = $v.priceMin;
      _priceMax = $v.priceMax;
      _priceUnit = $v.priceUnit;
      _isNegotiable = $v.isNegotiable;
      _displayPrice = $v.displayPrice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersSlugGet200ResponseOfferingsInner other) {
    _$v = other as _$V1ProvidersSlugGet200ResponseOfferingsInner;
  }

  @override
  void update(
    void Function(V1ProvidersSlugGet200ResponseOfferingsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersSlugGet200ResponseOfferingsInner build() => _build();

  _$V1ProvidersSlugGet200ResponseOfferingsInner _build() {
    _$V1ProvidersSlugGet200ResponseOfferingsInner _$result;
    try {
      _$result =
          _$v ??
          _$V1ProvidersSlugGet200ResponseOfferingsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'V1ProvidersSlugGet200ResponseOfferingsInner',
              'id',
            ),
            category: category.build(),
            titleFr: BuiltValueNullFieldError.checkNotNull(
              titleFr,
              r'V1ProvidersSlugGet200ResponseOfferingsInner',
              'titleFr',
            ),
            titleAr: BuiltValueNullFieldError.checkNotNull(
              titleAr,
              r'V1ProvidersSlugGet200ResponseOfferingsInner',
              'titleAr',
            ),
            description: BuiltValueNullFieldError.checkNotNull(
              description,
              r'V1ProvidersSlugGet200ResponseOfferingsInner',
              'description',
            ),
            priceMin: BuiltValueNullFieldError.checkNotNull(
              priceMin,
              r'V1ProvidersSlugGet200ResponseOfferingsInner',
              'priceMin',
            ),
            priceMax: BuiltValueNullFieldError.checkNotNull(
              priceMax,
              r'V1ProvidersSlugGet200ResponseOfferingsInner',
              'priceMax',
            ),
            priceUnit: BuiltValueNullFieldError.checkNotNull(
              priceUnit,
              r'V1ProvidersSlugGet200ResponseOfferingsInner',
              'priceUnit',
            ),
            isNegotiable: BuiltValueNullFieldError.checkNotNull(
              isNegotiable,
              r'V1ProvidersSlugGet200ResponseOfferingsInner',
              'isNegotiable',
            ),
            displayPrice: BuiltValueNullFieldError.checkNotNull(
              displayPrice,
              r'V1ProvidersSlugGet200ResponseOfferingsInner',
              'displayPrice',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'category';
        category.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'V1ProvidersSlugGet200ResponseOfferingsInner',
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

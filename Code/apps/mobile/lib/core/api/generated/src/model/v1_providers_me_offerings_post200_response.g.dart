// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_offerings_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum
    _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_FIXED =
    const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum._('FIXED');
const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum
    _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_HOUR =
    const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum._('HOUR');
const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum
    _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_DAY =
    const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum._('DAY');
const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum
    _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_SQUARE_METER =
    const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum._('SQUARE_METER');
const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum
    _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_LINEAR_METER =
    const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum._('LINEAR_METER');
const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum
    _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_ON_QUOTE =
    const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum._('ON_QUOTE');

V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum
    _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnumValueOf(String name) {
  switch (name) {
    case 'FIXED':
      return _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_FIXED;
    case 'HOUR':
      return _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_HOUR;
    case 'DAY':
      return _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_DAY;
    case 'SQUARE_METER':
      return _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_SQUARE_METER;
    case 'LINEAR_METER':
      return _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_LINEAR_METER;
    case 'ON_QUOTE':
      return _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_ON_QUOTE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum>
    _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnumValues = BuiltSet<
        V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum>(const <V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum>[
  _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_FIXED,
  _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_HOUR,
  _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_DAY,
  _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_SQUARE_METER,
  _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_LINEAR_METER,
  _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_ON_QUOTE,
]);

Serializer<V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum>
    _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnumSerializer =
    _$V1ProvidersMeOfferingsPost200ResponsePriceUnitEnumSerializer();

class _$V1ProvidersMeOfferingsPost200ResponsePriceUnitEnumSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum> {
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
    V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum
  ];
  @override
  final String wireName = 'V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum';

  @override
  Object serialize(Serializers serializers,
          V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ProvidersMeOfferingsPost200Response
    extends V1ProvidersMeOfferingsPost200Response {
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
  final V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum priceUnit;
  @override
  final bool isNegotiable;
  @override
  final String displayPrice;

  factory _$V1ProvidersMeOfferingsPost200Response(
          [void Function(V1ProvidersMeOfferingsPost200ResponseBuilder)?
              updates]) =>
      (V1ProvidersMeOfferingsPost200ResponseBuilder()..update(updates))
          ._build();

  _$V1ProvidersMeOfferingsPost200Response._(
      {required this.id,
      required this.category,
      required this.titleFr,
      required this.titleAr,
      required this.description,
      required this.priceMin,
      required this.priceMax,
      required this.priceUnit,
      required this.isNegotiable,
      required this.displayPrice})
      : super._();
  @override
  V1ProvidersMeOfferingsPost200Response rebuild(
          void Function(V1ProvidersMeOfferingsPost200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeOfferingsPost200ResponseBuilder toBuilder() =>
      V1ProvidersMeOfferingsPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeOfferingsPost200Response &&
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
            r'V1ProvidersMeOfferingsPost200Response')
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

class V1ProvidersMeOfferingsPost200ResponseBuilder
    implements
        Builder<V1ProvidersMeOfferingsPost200Response,
            V1ProvidersMeOfferingsPost200ResponseBuilder> {
  _$V1ProvidersMeOfferingsPost200Response? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder? _category;
  V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder get category =>
      _$this._category ??=
          V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder();
  set category(
          V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder?
              category) =>
      _$this._category = category;

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

  V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum? _priceUnit;
  V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum? get priceUnit =>
      _$this._priceUnit;
  set priceUnit(
          V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum? priceUnit) =>
      _$this._priceUnit = priceUnit;

  bool? _isNegotiable;
  bool? get isNegotiable => _$this._isNegotiable;
  set isNegotiable(bool? isNegotiable) => _$this._isNegotiable = isNegotiable;

  String? _displayPrice;
  String? get displayPrice => _$this._displayPrice;
  set displayPrice(String? displayPrice) => _$this._displayPrice = displayPrice;

  V1ProvidersMeOfferingsPost200ResponseBuilder() {
    V1ProvidersMeOfferingsPost200Response._defaults(this);
  }

  V1ProvidersMeOfferingsPost200ResponseBuilder get _$this {
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
  void replace(V1ProvidersMeOfferingsPost200Response other) {
    _$v = other as _$V1ProvidersMeOfferingsPost200Response;
  }

  @override
  void update(
      void Function(V1ProvidersMeOfferingsPost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeOfferingsPost200Response build() => _build();

  _$V1ProvidersMeOfferingsPost200Response _build() {
    _$V1ProvidersMeOfferingsPost200Response _$result;
    try {
      _$result = _$v ??
          _$V1ProvidersMeOfferingsPost200Response._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'V1ProvidersMeOfferingsPost200Response', 'id'),
            category: category.build(),
            titleFr: BuiltValueNullFieldError.checkNotNull(
                titleFr, r'V1ProvidersMeOfferingsPost200Response', 'titleFr'),
            titleAr: BuiltValueNullFieldError.checkNotNull(
                titleAr, r'V1ProvidersMeOfferingsPost200Response', 'titleAr'),
            description: BuiltValueNullFieldError.checkNotNull(description,
                r'V1ProvidersMeOfferingsPost200Response', 'description'),
            priceMin: BuiltValueNullFieldError.checkNotNull(
                priceMin, r'V1ProvidersMeOfferingsPost200Response', 'priceMin'),
            priceMax: BuiltValueNullFieldError.checkNotNull(
                priceMax, r'V1ProvidersMeOfferingsPost200Response', 'priceMax'),
            priceUnit: BuiltValueNullFieldError.checkNotNull(priceUnit,
                r'V1ProvidersMeOfferingsPost200Response', 'priceUnit'),
            isNegotiable: BuiltValueNullFieldError.checkNotNull(isNegotiable,
                r'V1ProvidersMeOfferingsPost200Response', 'isNegotiable'),
            displayPrice: BuiltValueNullFieldError.checkNotNull(displayPrice,
                r'V1ProvidersMeOfferingsPost200Response', 'displayPrice'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'category';
        category.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1ProvidersMeOfferingsPost200Response',
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

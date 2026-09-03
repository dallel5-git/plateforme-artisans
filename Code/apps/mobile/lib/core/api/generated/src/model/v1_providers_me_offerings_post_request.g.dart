// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_offerings_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ProvidersMeOfferingsPostRequestPriceUnitEnum
    _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_FIXED =
    const V1ProvidersMeOfferingsPostRequestPriceUnitEnum._('FIXED');
const V1ProvidersMeOfferingsPostRequestPriceUnitEnum
    _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_HOUR =
    const V1ProvidersMeOfferingsPostRequestPriceUnitEnum._('HOUR');
const V1ProvidersMeOfferingsPostRequestPriceUnitEnum
    _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_DAY =
    const V1ProvidersMeOfferingsPostRequestPriceUnitEnum._('DAY');
const V1ProvidersMeOfferingsPostRequestPriceUnitEnum
    _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_SQUARE_METER =
    const V1ProvidersMeOfferingsPostRequestPriceUnitEnum._('SQUARE_METER');
const V1ProvidersMeOfferingsPostRequestPriceUnitEnum
    _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_LINEAR_METER =
    const V1ProvidersMeOfferingsPostRequestPriceUnitEnum._('LINEAR_METER');
const V1ProvidersMeOfferingsPostRequestPriceUnitEnum
    _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_ON_QUOTE =
    const V1ProvidersMeOfferingsPostRequestPriceUnitEnum._('ON_QUOTE');

V1ProvidersMeOfferingsPostRequestPriceUnitEnum
    _$v1ProvidersMeOfferingsPostRequestPriceUnitEnumValueOf(String name) {
  switch (name) {
    case 'FIXED':
      return _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_FIXED;
    case 'HOUR':
      return _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_HOUR;
    case 'DAY':
      return _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_DAY;
    case 'SQUARE_METER':
      return _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_SQUARE_METER;
    case 'LINEAR_METER':
      return _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_LINEAR_METER;
    case 'ON_QUOTE':
      return _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_ON_QUOTE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProvidersMeOfferingsPostRequestPriceUnitEnum>
    _$v1ProvidersMeOfferingsPostRequestPriceUnitEnumValues = BuiltSet<
        V1ProvidersMeOfferingsPostRequestPriceUnitEnum>(const <V1ProvidersMeOfferingsPostRequestPriceUnitEnum>[
  _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_FIXED,
  _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_HOUR,
  _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_DAY,
  _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_SQUARE_METER,
  _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_LINEAR_METER,
  _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_ON_QUOTE,
]);

Serializer<V1ProvidersMeOfferingsPostRequestPriceUnitEnum>
    _$v1ProvidersMeOfferingsPostRequestPriceUnitEnumSerializer =
    _$V1ProvidersMeOfferingsPostRequestPriceUnitEnumSerializer();

class _$V1ProvidersMeOfferingsPostRequestPriceUnitEnumSerializer
    implements
        PrimitiveSerializer<V1ProvidersMeOfferingsPostRequestPriceUnitEnum> {
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
    V1ProvidersMeOfferingsPostRequestPriceUnitEnum
  ];
  @override
  final String wireName = 'V1ProvidersMeOfferingsPostRequestPriceUnitEnum';

  @override
  Object serialize(Serializers serializers,
          V1ProvidersMeOfferingsPostRequestPriceUnitEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ProvidersMeOfferingsPostRequestPriceUnitEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ProvidersMeOfferingsPostRequestPriceUnitEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ProvidersMeOfferingsPostRequest
    extends V1ProvidersMeOfferingsPostRequest {
  @override
  final String categoryId;
  @override
  final String titleFr;
  @override
  final String? titleAr;
  @override
  final String? description;
  @override
  final num? priceMin;
  @override
  final num? priceMax;
  @override
  final V1ProvidersMeOfferingsPostRequestPriceUnitEnum? priceUnit;
  @override
  final bool? isNegotiable;

  factory _$V1ProvidersMeOfferingsPostRequest(
          [void Function(V1ProvidersMeOfferingsPostRequestBuilder)? updates]) =>
      (V1ProvidersMeOfferingsPostRequestBuilder()..update(updates))._build();

  _$V1ProvidersMeOfferingsPostRequest._(
      {required this.categoryId,
      required this.titleFr,
      this.titleAr,
      this.description,
      this.priceMin,
      this.priceMax,
      this.priceUnit,
      this.isNegotiable})
      : super._();
  @override
  V1ProvidersMeOfferingsPostRequest rebuild(
          void Function(V1ProvidersMeOfferingsPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeOfferingsPostRequestBuilder toBuilder() =>
      V1ProvidersMeOfferingsPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeOfferingsPostRequest &&
        categoryId == other.categoryId &&
        titleFr == other.titleFr &&
        titleAr == other.titleAr &&
        description == other.description &&
        priceMin == other.priceMin &&
        priceMax == other.priceMax &&
        priceUnit == other.priceUnit &&
        isNegotiable == other.isNegotiable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, titleFr.hashCode);
    _$hash = $jc(_$hash, titleAr.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, priceMin.hashCode);
    _$hash = $jc(_$hash, priceMax.hashCode);
    _$hash = $jc(_$hash, priceUnit.hashCode);
    _$hash = $jc(_$hash, isNegotiable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1ProvidersMeOfferingsPostRequest')
          ..add('categoryId', categoryId)
          ..add('titleFr', titleFr)
          ..add('titleAr', titleAr)
          ..add('description', description)
          ..add('priceMin', priceMin)
          ..add('priceMax', priceMax)
          ..add('priceUnit', priceUnit)
          ..add('isNegotiable', isNegotiable))
        .toString();
  }
}

class V1ProvidersMeOfferingsPostRequestBuilder
    implements
        Builder<V1ProvidersMeOfferingsPostRequest,
            V1ProvidersMeOfferingsPostRequestBuilder> {
  _$V1ProvidersMeOfferingsPostRequest? _$v;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

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

  V1ProvidersMeOfferingsPostRequestPriceUnitEnum? _priceUnit;
  V1ProvidersMeOfferingsPostRequestPriceUnitEnum? get priceUnit =>
      _$this._priceUnit;
  set priceUnit(V1ProvidersMeOfferingsPostRequestPriceUnitEnum? priceUnit) =>
      _$this._priceUnit = priceUnit;

  bool? _isNegotiable;
  bool? get isNegotiable => _$this._isNegotiable;
  set isNegotiable(bool? isNegotiable) => _$this._isNegotiable = isNegotiable;

  V1ProvidersMeOfferingsPostRequestBuilder() {
    V1ProvidersMeOfferingsPostRequest._defaults(this);
  }

  V1ProvidersMeOfferingsPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryId = $v.categoryId;
      _titleFr = $v.titleFr;
      _titleAr = $v.titleAr;
      _description = $v.description;
      _priceMin = $v.priceMin;
      _priceMax = $v.priceMax;
      _priceUnit = $v.priceUnit;
      _isNegotiable = $v.isNegotiable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeOfferingsPostRequest other) {
    _$v = other as _$V1ProvidersMeOfferingsPostRequest;
  }

  @override
  void update(
      void Function(V1ProvidersMeOfferingsPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeOfferingsPostRequest build() => _build();

  _$V1ProvidersMeOfferingsPostRequest _build() {
    final _$result = _$v ??
        _$V1ProvidersMeOfferingsPostRequest._(
          categoryId: BuiltValueNullFieldError.checkNotNull(
              categoryId, r'V1ProvidersMeOfferingsPostRequest', 'categoryId'),
          titleFr: BuiltValueNullFieldError.checkNotNull(
              titleFr, r'V1ProvidersMeOfferingsPostRequest', 'titleFr'),
          titleAr: titleAr,
          description: description,
          priceMin: priceMin,
          priceMax: priceMax,
          priceUnit: priceUnit,
          isNegotiable: isNegotiable,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

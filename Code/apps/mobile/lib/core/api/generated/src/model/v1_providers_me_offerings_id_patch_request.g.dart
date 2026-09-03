// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_offerings_id_patch_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum
    _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_FIXED =
    const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum._('FIXED');
const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum
    _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_HOUR =
    const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum._('HOUR');
const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum
    _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_DAY =
    const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum._('DAY');
const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum
    _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_SQUARE_METER =
    const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum._('SQUARE_METER');
const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum
    _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_LINEAR_METER =
    const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum._('LINEAR_METER');
const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum
    _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_ON_QUOTE =
    const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum._('ON_QUOTE');

V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum
    _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnumValueOf(String name) {
  switch (name) {
    case 'FIXED':
      return _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_FIXED;
    case 'HOUR':
      return _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_HOUR;
    case 'DAY':
      return _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_DAY;
    case 'SQUARE_METER':
      return _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_SQUARE_METER;
    case 'LINEAR_METER':
      return _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_LINEAR_METER;
    case 'ON_QUOTE':
      return _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_ON_QUOTE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum>
    _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnumValues = BuiltSet<
        V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum>(const <V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum>[
  _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_FIXED,
  _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_HOUR,
  _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_DAY,
  _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_SQUARE_METER,
  _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_LINEAR_METER,
  _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_ON_QUOTE,
]);

Serializer<V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum>
    _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnumSerializer =
    _$V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnumSerializer();

class _$V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnumSerializer
    implements
        PrimitiveSerializer<V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum> {
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
    V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum
  ];
  @override
  final String wireName = 'V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum';

  @override
  Object serialize(Serializers serializers,
          V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ProvidersMeOfferingsIdPatchRequest
    extends V1ProvidersMeOfferingsIdPatchRequest {
  @override
  final String? titleFr;
  @override
  final String? titleAr;
  @override
  final String? description;
  @override
  final num? priceMin;
  @override
  final num? priceMax;
  @override
  final V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum? priceUnit;
  @override
  final bool? isNegotiable;

  factory _$V1ProvidersMeOfferingsIdPatchRequest(
          [void Function(V1ProvidersMeOfferingsIdPatchRequestBuilder)?
              updates]) =>
      (V1ProvidersMeOfferingsIdPatchRequestBuilder()..update(updates))._build();

  _$V1ProvidersMeOfferingsIdPatchRequest._(
      {this.titleFr,
      this.titleAr,
      this.description,
      this.priceMin,
      this.priceMax,
      this.priceUnit,
      this.isNegotiable})
      : super._();
  @override
  V1ProvidersMeOfferingsIdPatchRequest rebuild(
          void Function(V1ProvidersMeOfferingsIdPatchRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeOfferingsIdPatchRequestBuilder toBuilder() =>
      V1ProvidersMeOfferingsIdPatchRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeOfferingsIdPatchRequest &&
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
    return (newBuiltValueToStringHelper(r'V1ProvidersMeOfferingsIdPatchRequest')
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

class V1ProvidersMeOfferingsIdPatchRequestBuilder
    implements
        Builder<V1ProvidersMeOfferingsIdPatchRequest,
            V1ProvidersMeOfferingsIdPatchRequestBuilder> {
  _$V1ProvidersMeOfferingsIdPatchRequest? _$v;

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

  V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum? _priceUnit;
  V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum? get priceUnit =>
      _$this._priceUnit;
  set priceUnit(V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum? priceUnit) =>
      _$this._priceUnit = priceUnit;

  bool? _isNegotiable;
  bool? get isNegotiable => _$this._isNegotiable;
  set isNegotiable(bool? isNegotiable) => _$this._isNegotiable = isNegotiable;

  V1ProvidersMeOfferingsIdPatchRequestBuilder() {
    V1ProvidersMeOfferingsIdPatchRequest._defaults(this);
  }

  V1ProvidersMeOfferingsIdPatchRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
  void replace(V1ProvidersMeOfferingsIdPatchRequest other) {
    _$v = other as _$V1ProvidersMeOfferingsIdPatchRequest;
  }

  @override
  void update(
      void Function(V1ProvidersMeOfferingsIdPatchRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeOfferingsIdPatchRequest build() => _build();

  _$V1ProvidersMeOfferingsIdPatchRequest _build() {
    final _$result = _$v ??
        _$V1ProvidersMeOfferingsIdPatchRequest._(
          titleFr: titleFr,
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

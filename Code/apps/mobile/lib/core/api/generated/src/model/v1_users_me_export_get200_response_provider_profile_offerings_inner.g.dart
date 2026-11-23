// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_users_me_export_get200_response_provider_profile_offerings_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1UsersMeExportGet200ResponseProviderProfileOfferingsInner
    extends V1UsersMeExportGet200ResponseProviderProfileOfferingsInner {
  @override
  final String id;
  @override
  final String titleFr;
  @override
  final String titleAr;
  @override
  final num priceMin;
  @override
  final num priceMax;
  @override
  final String priceUnit;

  factory _$V1UsersMeExportGet200ResponseProviderProfileOfferingsInner(
          [void Function(
                  V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerBuilder)?
              updates]) =>
      (V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerBuilder()
            ..update(updates))
          ._build();

  _$V1UsersMeExportGet200ResponseProviderProfileOfferingsInner._(
      {required this.id,
      required this.titleFr,
      required this.titleAr,
      required this.priceMin,
      required this.priceMax,
      required this.priceUnit})
      : super._();
  @override
  V1UsersMeExportGet200ResponseProviderProfileOfferingsInner rebuild(
          void Function(
                  V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerBuilder
      toBuilder() =>
          V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerBuilder()
            ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is V1UsersMeExportGet200ResponseProviderProfileOfferingsInner &&
        id == other.id &&
        titleFr == other.titleFr &&
        titleAr == other.titleAr &&
        priceMin == other.priceMin &&
        priceMax == other.priceMax &&
        priceUnit == other.priceUnit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, titleFr.hashCode);
    _$hash = $jc(_$hash, titleAr.hashCode);
    _$hash = $jc(_$hash, priceMin.hashCode);
    _$hash = $jc(_$hash, priceMax.hashCode);
    _$hash = $jc(_$hash, priceUnit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1UsersMeExportGet200ResponseProviderProfileOfferingsInner')
          ..add('id', id)
          ..add('titleFr', titleFr)
          ..add('titleAr', titleAr)
          ..add('priceMin', priceMin)
          ..add('priceMax', priceMax)
          ..add('priceUnit', priceUnit))
        .toString();
  }
}

class V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerBuilder
    implements
        Builder<V1UsersMeExportGet200ResponseProviderProfileOfferingsInner,
            V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerBuilder> {
  _$V1UsersMeExportGet200ResponseProviderProfileOfferingsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _titleFr;
  String? get titleFr => _$this._titleFr;
  set titleFr(String? titleFr) => _$this._titleFr = titleFr;

  String? _titleAr;
  String? get titleAr => _$this._titleAr;
  set titleAr(String? titleAr) => _$this._titleAr = titleAr;

  num? _priceMin;
  num? get priceMin => _$this._priceMin;
  set priceMin(num? priceMin) => _$this._priceMin = priceMin;

  num? _priceMax;
  num? get priceMax => _$this._priceMax;
  set priceMax(num? priceMax) => _$this._priceMax = priceMax;

  String? _priceUnit;
  String? get priceUnit => _$this._priceUnit;
  set priceUnit(String? priceUnit) => _$this._priceUnit = priceUnit;

  V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerBuilder() {
    V1UsersMeExportGet200ResponseProviderProfileOfferingsInner._defaults(this);
  }

  V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _titleFr = $v.titleFr;
      _titleAr = $v.titleAr;
      _priceMin = $v.priceMin;
      _priceMax = $v.priceMax;
      _priceUnit = $v.priceUnit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
      V1UsersMeExportGet200ResponseProviderProfileOfferingsInner other) {
    _$v = other as _$V1UsersMeExportGet200ResponseProviderProfileOfferingsInner;
  }

  @override
  void update(
      void Function(
              V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1UsersMeExportGet200ResponseProviderProfileOfferingsInner build() =>
      _build();

  _$V1UsersMeExportGet200ResponseProviderProfileOfferingsInner _build() {
    final _$result = _$v ??
        _$V1UsersMeExportGet200ResponseProviderProfileOfferingsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'V1UsersMeExportGet200ResponseProviderProfileOfferingsInner',
              'id'),
          titleFr: BuiltValueNullFieldError.checkNotNull(
              titleFr,
              r'V1UsersMeExportGet200ResponseProviderProfileOfferingsInner',
              'titleFr'),
          titleAr: BuiltValueNullFieldError.checkNotNull(
              titleAr,
              r'V1UsersMeExportGet200ResponseProviderProfileOfferingsInner',
              'titleAr'),
          priceMin: BuiltValueNullFieldError.checkNotNull(
              priceMin,
              r'V1UsersMeExportGet200ResponseProviderProfileOfferingsInner',
              'priceMin'),
          priceMax: BuiltValueNullFieldError.checkNotNull(
              priceMax,
              r'V1UsersMeExportGet200ResponseProviderProfileOfferingsInner',
              'priceMax'),
          priceUnit: BuiltValueNullFieldError.checkNotNull(
              priceUnit,
              r'V1UsersMeExportGet200ResponseProviderProfileOfferingsInner',
              'priceUnit'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

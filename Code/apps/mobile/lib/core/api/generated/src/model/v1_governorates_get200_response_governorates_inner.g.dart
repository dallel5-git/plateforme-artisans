// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_governorates_get200_response_governorates_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1GovernoratesGet200ResponseGovernoratesInner
    extends V1GovernoratesGet200ResponseGovernoratesInner {
  @override
  final String id;
  @override
  final String code;
  @override
  final String nameFr;
  @override
  final String nameAr;
  @override
  final String slug;
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final int sortOrder;

  factory _$V1GovernoratesGet200ResponseGovernoratesInner([
    void Function(V1GovernoratesGet200ResponseGovernoratesInnerBuilder)?
    updates,
  ]) =>
      (V1GovernoratesGet200ResponseGovernoratesInnerBuilder()..update(updates))
          ._build();

  _$V1GovernoratesGet200ResponseGovernoratesInner._({
    required this.id,
    required this.code,
    required this.nameFr,
    required this.nameAr,
    required this.slug,
    required this.latitude,
    required this.longitude,
    required this.sortOrder,
  }) : super._();
  @override
  V1GovernoratesGet200ResponseGovernoratesInner rebuild(
    void Function(V1GovernoratesGet200ResponseGovernoratesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1GovernoratesGet200ResponseGovernoratesInnerBuilder toBuilder() =>
      V1GovernoratesGet200ResponseGovernoratesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1GovernoratesGet200ResponseGovernoratesInner &&
        id == other.id &&
        code == other.code &&
        nameFr == other.nameFr &&
        nameAr == other.nameAr &&
        slug == other.slug &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        sortOrder == other.sortOrder;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, nameFr.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, sortOrder.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1GovernoratesGet200ResponseGovernoratesInner',
          )
          ..add('id', id)
          ..add('code', code)
          ..add('nameFr', nameFr)
          ..add('nameAr', nameAr)
          ..add('slug', slug)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('sortOrder', sortOrder))
        .toString();
  }
}

class V1GovernoratesGet200ResponseGovernoratesInnerBuilder
    implements
        Builder<
          V1GovernoratesGet200ResponseGovernoratesInner,
          V1GovernoratesGet200ResponseGovernoratesInnerBuilder
        > {
  _$V1GovernoratesGet200ResponseGovernoratesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _nameFr;
  String? get nameFr => _$this._nameFr;
  set nameFr(String? nameFr) => _$this._nameFr = nameFr;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  int? _sortOrder;
  int? get sortOrder => _$this._sortOrder;
  set sortOrder(int? sortOrder) => _$this._sortOrder = sortOrder;

  V1GovernoratesGet200ResponseGovernoratesInnerBuilder() {
    V1GovernoratesGet200ResponseGovernoratesInner._defaults(this);
  }

  V1GovernoratesGet200ResponseGovernoratesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _nameFr = $v.nameFr;
      _nameAr = $v.nameAr;
      _slug = $v.slug;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _sortOrder = $v.sortOrder;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1GovernoratesGet200ResponseGovernoratesInner other) {
    _$v = other as _$V1GovernoratesGet200ResponseGovernoratesInner;
  }

  @override
  void update(
    void Function(V1GovernoratesGet200ResponseGovernoratesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  V1GovernoratesGet200ResponseGovernoratesInner build() => _build();

  _$V1GovernoratesGet200ResponseGovernoratesInner _build() {
    final _$result =
        _$v ??
        _$V1GovernoratesGet200ResponseGovernoratesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'V1GovernoratesGet200ResponseGovernoratesInner',
            'id',
          ),
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'V1GovernoratesGet200ResponseGovernoratesInner',
            'code',
          ),
          nameFr: BuiltValueNullFieldError.checkNotNull(
            nameFr,
            r'V1GovernoratesGet200ResponseGovernoratesInner',
            'nameFr',
          ),
          nameAr: BuiltValueNullFieldError.checkNotNull(
            nameAr,
            r'V1GovernoratesGet200ResponseGovernoratesInner',
            'nameAr',
          ),
          slug: BuiltValueNullFieldError.checkNotNull(
            slug,
            r'V1GovernoratesGet200ResponseGovernoratesInner',
            'slug',
          ),
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'V1GovernoratesGet200ResponseGovernoratesInner',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'V1GovernoratesGet200ResponseGovernoratesInner',
            'longitude',
          ),
          sortOrder: BuiltValueNullFieldError.checkNotNull(
            sortOrder,
            r'V1GovernoratesGet200ResponseGovernoratesInner',
            'sortOrder',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

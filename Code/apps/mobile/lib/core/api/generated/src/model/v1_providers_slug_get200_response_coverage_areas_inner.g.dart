// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_slug_get200_response_coverage_areas_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersSlugGet200ResponseCoverageAreasInner
    extends V1ProvidersSlugGet200ResponseCoverageAreasInner {
  @override
  final V1ProvidersSlugGet200ResponseOfferingsInnerCategory governorate;
  @override
  final V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation delegation;
  @override
  final num travelFee;

  factory _$V1ProvidersSlugGet200ResponseCoverageAreasInner(
          [void Function(
                  V1ProvidersSlugGet200ResponseCoverageAreasInnerBuilder)?
              updates]) =>
      (V1ProvidersSlugGet200ResponseCoverageAreasInnerBuilder()
            ..update(updates))
          ._build();

  _$V1ProvidersSlugGet200ResponseCoverageAreasInner._(
      {required this.governorate,
      required this.delegation,
      required this.travelFee})
      : super._();
  @override
  V1ProvidersSlugGet200ResponseCoverageAreasInner rebuild(
          void Function(V1ProvidersSlugGet200ResponseCoverageAreasInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersSlugGet200ResponseCoverageAreasInnerBuilder toBuilder() =>
      V1ProvidersSlugGet200ResponseCoverageAreasInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersSlugGet200ResponseCoverageAreasInner &&
        governorate == other.governorate &&
        delegation == other.delegation &&
        travelFee == other.travelFee;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, governorate.hashCode);
    _$hash = $jc(_$hash, delegation.hashCode);
    _$hash = $jc(_$hash, travelFee.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersSlugGet200ResponseCoverageAreasInner')
          ..add('governorate', governorate)
          ..add('delegation', delegation)
          ..add('travelFee', travelFee))
        .toString();
  }
}

class V1ProvidersSlugGet200ResponseCoverageAreasInnerBuilder
    implements
        Builder<V1ProvidersSlugGet200ResponseCoverageAreasInner,
            V1ProvidersSlugGet200ResponseCoverageAreasInnerBuilder> {
  _$V1ProvidersSlugGet200ResponseCoverageAreasInner? _$v;

  V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder? _governorate;
  V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder get governorate =>
      _$this._governorate ??=
          V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder();
  set governorate(
          V1ProvidersSlugGet200ResponseOfferingsInnerCategoryBuilder?
              governorate) =>
      _$this._governorate = governorate;

  V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegationBuilder? _delegation;
  V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegationBuilder
      get delegation => _$this._delegation ??=
          V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegationBuilder();
  set delegation(
          V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegationBuilder?
              delegation) =>
      _$this._delegation = delegation;

  num? _travelFee;
  num? get travelFee => _$this._travelFee;
  set travelFee(num? travelFee) => _$this._travelFee = travelFee;

  V1ProvidersSlugGet200ResponseCoverageAreasInnerBuilder() {
    V1ProvidersSlugGet200ResponseCoverageAreasInner._defaults(this);
  }

  V1ProvidersSlugGet200ResponseCoverageAreasInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _governorate = $v.governorate.toBuilder();
      _delegation = $v.delegation.toBuilder();
      _travelFee = $v.travelFee;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersSlugGet200ResponseCoverageAreasInner other) {
    _$v = other as _$V1ProvidersSlugGet200ResponseCoverageAreasInner;
  }

  @override
  void update(
      void Function(V1ProvidersSlugGet200ResponseCoverageAreasInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersSlugGet200ResponseCoverageAreasInner build() => _build();

  _$V1ProvidersSlugGet200ResponseCoverageAreasInner _build() {
    _$V1ProvidersSlugGet200ResponseCoverageAreasInner _$result;
    try {
      _$result = _$v ??
          _$V1ProvidersSlugGet200ResponseCoverageAreasInner._(
            governorate: governorate.build(),
            delegation: delegation.build(),
            travelFee: BuiltValueNullFieldError.checkNotNull(
                travelFee,
                r'V1ProvidersSlugGet200ResponseCoverageAreasInner',
                'travelFee'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'governorate';
        governorate.build();
        _$failedField = 'delegation';
        delegation.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1ProvidersSlugGet200ResponseCoverageAreasInner',
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

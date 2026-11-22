// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_get200_response_coverage_areas_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMeGet200ResponseCoverageAreasInner
    extends V1ProvidersMeGet200ResponseCoverageAreasInner {
  @override
  final String id;
  @override
  final String governorateId;
  @override
  final String delegationId;
  @override
  final num travelFee;

  factory _$V1ProvidersMeGet200ResponseCoverageAreasInner(
          [void Function(V1ProvidersMeGet200ResponseCoverageAreasInnerBuilder)?
              updates]) =>
      (V1ProvidersMeGet200ResponseCoverageAreasInnerBuilder()..update(updates))
          ._build();

  _$V1ProvidersMeGet200ResponseCoverageAreasInner._(
      {required this.id,
      required this.governorateId,
      required this.delegationId,
      required this.travelFee})
      : super._();
  @override
  V1ProvidersMeGet200ResponseCoverageAreasInner rebuild(
          void Function(V1ProvidersMeGet200ResponseCoverageAreasInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeGet200ResponseCoverageAreasInnerBuilder toBuilder() =>
      V1ProvidersMeGet200ResponseCoverageAreasInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeGet200ResponseCoverageAreasInner &&
        id == other.id &&
        governorateId == other.governorateId &&
        delegationId == other.delegationId &&
        travelFee == other.travelFee;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, governorateId.hashCode);
    _$hash = $jc(_$hash, delegationId.hashCode);
    _$hash = $jc(_$hash, travelFee.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersMeGet200ResponseCoverageAreasInner')
          ..add('id', id)
          ..add('governorateId', governorateId)
          ..add('delegationId', delegationId)
          ..add('travelFee', travelFee))
        .toString();
  }
}

class V1ProvidersMeGet200ResponseCoverageAreasInnerBuilder
    implements
        Builder<V1ProvidersMeGet200ResponseCoverageAreasInner,
            V1ProvidersMeGet200ResponseCoverageAreasInnerBuilder> {
  _$V1ProvidersMeGet200ResponseCoverageAreasInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _governorateId;
  String? get governorateId => _$this._governorateId;
  set governorateId(String? governorateId) =>
      _$this._governorateId = governorateId;

  String? _delegationId;
  String? get delegationId => _$this._delegationId;
  set delegationId(String? delegationId) => _$this._delegationId = delegationId;

  num? _travelFee;
  num? get travelFee => _$this._travelFee;
  set travelFee(num? travelFee) => _$this._travelFee = travelFee;

  V1ProvidersMeGet200ResponseCoverageAreasInnerBuilder() {
    V1ProvidersMeGet200ResponseCoverageAreasInner._defaults(this);
  }

  V1ProvidersMeGet200ResponseCoverageAreasInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _governorateId = $v.governorateId;
      _delegationId = $v.delegationId;
      _travelFee = $v.travelFee;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeGet200ResponseCoverageAreasInner other) {
    _$v = other as _$V1ProvidersMeGet200ResponseCoverageAreasInner;
  }

  @override
  void update(
      void Function(V1ProvidersMeGet200ResponseCoverageAreasInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeGet200ResponseCoverageAreasInner build() => _build();

  _$V1ProvidersMeGet200ResponseCoverageAreasInner _build() {
    final _$result = _$v ??
        _$V1ProvidersMeGet200ResponseCoverageAreasInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'V1ProvidersMeGet200ResponseCoverageAreasInner', 'id'),
          governorateId: BuiltValueNullFieldError.checkNotNull(
              governorateId,
              r'V1ProvidersMeGet200ResponseCoverageAreasInner',
              'governorateId'),
          delegationId: BuiltValueNullFieldError.checkNotNull(delegationId,
              r'V1ProvidersMeGet200ResponseCoverageAreasInner', 'delegationId'),
          travelFee: BuiltValueNullFieldError.checkNotNull(travelFee,
              r'V1ProvidersMeGet200ResponseCoverageAreasInner', 'travelFee'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

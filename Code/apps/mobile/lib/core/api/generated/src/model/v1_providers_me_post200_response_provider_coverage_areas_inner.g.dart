// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_post200_response_provider_coverage_areas_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMePost200ResponseProviderCoverageAreasInner
    extends V1ProvidersMePost200ResponseProviderCoverageAreasInner {
  @override
  final String id;
  @override
  final String governorateId;
  @override
  final String delegationId;
  @override
  final num travelFee;

  factory _$V1ProvidersMePost200ResponseProviderCoverageAreasInner(
          [void Function(
                  V1ProvidersMePost200ResponseProviderCoverageAreasInnerBuilder)?
              updates]) =>
      (V1ProvidersMePost200ResponseProviderCoverageAreasInnerBuilder()
            ..update(updates))
          ._build();

  _$V1ProvidersMePost200ResponseProviderCoverageAreasInner._(
      {required this.id,
      required this.governorateId,
      required this.delegationId,
      required this.travelFee})
      : super._();
  @override
  V1ProvidersMePost200ResponseProviderCoverageAreasInner rebuild(
          void Function(
                  V1ProvidersMePost200ResponseProviderCoverageAreasInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMePost200ResponseProviderCoverageAreasInnerBuilder toBuilder() =>
      V1ProvidersMePost200ResponseProviderCoverageAreasInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMePost200ResponseProviderCoverageAreasInner &&
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
            r'V1ProvidersMePost200ResponseProviderCoverageAreasInner')
          ..add('id', id)
          ..add('governorateId', governorateId)
          ..add('delegationId', delegationId)
          ..add('travelFee', travelFee))
        .toString();
  }
}

class V1ProvidersMePost200ResponseProviderCoverageAreasInnerBuilder
    implements
        Builder<V1ProvidersMePost200ResponseProviderCoverageAreasInner,
            V1ProvidersMePost200ResponseProviderCoverageAreasInnerBuilder> {
  _$V1ProvidersMePost200ResponseProviderCoverageAreasInner? _$v;

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

  V1ProvidersMePost200ResponseProviderCoverageAreasInnerBuilder() {
    V1ProvidersMePost200ResponseProviderCoverageAreasInner._defaults(this);
  }

  V1ProvidersMePost200ResponseProviderCoverageAreasInnerBuilder get _$this {
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
  void replace(V1ProvidersMePost200ResponseProviderCoverageAreasInner other) {
    _$v = other as _$V1ProvidersMePost200ResponseProviderCoverageAreasInner;
  }

  @override
  void update(
      void Function(
              V1ProvidersMePost200ResponseProviderCoverageAreasInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMePost200ResponseProviderCoverageAreasInner build() => _build();

  _$V1ProvidersMePost200ResponseProviderCoverageAreasInner _build() {
    final _$result = _$v ??
        _$V1ProvidersMePost200ResponseProviderCoverageAreasInner._(
          id: BuiltValueNullFieldError.checkNotNull(id,
              r'V1ProvidersMePost200ResponseProviderCoverageAreasInner', 'id'),
          governorateId: BuiltValueNullFieldError.checkNotNull(
              governorateId,
              r'V1ProvidersMePost200ResponseProviderCoverageAreasInner',
              'governorateId'),
          delegationId: BuiltValueNullFieldError.checkNotNull(
              delegationId,
              r'V1ProvidersMePost200ResponseProviderCoverageAreasInner',
              'delegationId'),
          travelFee: BuiltValueNullFieldError.checkNotNull(
              travelFee,
              r'V1ProvidersMePost200ResponseProviderCoverageAreasInner',
              'travelFee'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

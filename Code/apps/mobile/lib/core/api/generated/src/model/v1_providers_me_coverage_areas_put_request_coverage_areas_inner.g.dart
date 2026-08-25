// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_coverage_areas_put_request_coverage_areas_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner
    extends V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner {
  @override
  final String governorateId;
  @override
  final String? delegationId;
  @override
  final int? travelFee;

  factory _$V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner([
    void Function(
      V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerBuilder,
    )?
    updates,
  ]) =>
      (V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerBuilder()
            ..update(updates))
          ._build();

  _$V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner._({
    required this.governorateId,
    this.delegationId,
    this.travelFee,
  }) : super._();
  @override
  V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner rebuild(
    void Function(V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerBuilder toBuilder() =>
      V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner &&
        governorateId == other.governorateId &&
        delegationId == other.delegationId &&
        travelFee == other.travelFee;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, governorateId.hashCode);
    _$hash = $jc(_$hash, delegationId.hashCode);
    _$hash = $jc(_$hash, travelFee.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner',
          )
          ..add('governorateId', governorateId)
          ..add('delegationId', delegationId)
          ..add('travelFee', travelFee))
        .toString();
  }
}

class V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerBuilder
    implements
        Builder<
          V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner,
          V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerBuilder
        > {
  _$V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner? _$v;

  String? _governorateId;
  String? get governorateId => _$this._governorateId;
  set governorateId(String? governorateId) =>
      _$this._governorateId = governorateId;

  String? _delegationId;
  String? get delegationId => _$this._delegationId;
  set delegationId(String? delegationId) => _$this._delegationId = delegationId;

  int? _travelFee;
  int? get travelFee => _$this._travelFee;
  set travelFee(int? travelFee) => _$this._travelFee = travelFee;

  V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerBuilder() {
    V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner._defaults(this);
  }

  V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _governorateId = $v.governorateId;
      _delegationId = $v.delegationId;
      _travelFee = $v.travelFee;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner other) {
    _$v = other as _$V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner;
  }

  @override
  void update(
    void Function(
      V1ProvidersMeCoverageAreasPutRequestCoverageAreasInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner build() => _build();

  _$V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner _build() {
    final _$result =
        _$v ??
        _$V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner._(
          governorateId: BuiltValueNullFieldError.checkNotNull(
            governorateId,
            r'V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner',
            'governorateId',
          ),
          delegationId: delegationId,
          travelFee: travelFee,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

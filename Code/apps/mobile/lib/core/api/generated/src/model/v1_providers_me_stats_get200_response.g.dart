// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_stats_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMeStatsGet200Response
    extends V1ProvidersMeStatsGet200Response {
  @override
  final V1ProvidersMeStatsGet200ResponseTotals totals;
  @override
  final BuiltList<V1ProvidersMeStatsGet200ResponseSeriesInner> series;

  factory _$V1ProvidersMeStatsGet200Response([
    void Function(V1ProvidersMeStatsGet200ResponseBuilder)? updates,
  ]) => (V1ProvidersMeStatsGet200ResponseBuilder()..update(updates))._build();

  _$V1ProvidersMeStatsGet200Response._({
    required this.totals,
    required this.series,
  }) : super._();
  @override
  V1ProvidersMeStatsGet200Response rebuild(
    void Function(V1ProvidersMeStatsGet200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeStatsGet200ResponseBuilder toBuilder() =>
      V1ProvidersMeStatsGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeStatsGet200Response &&
        totals == other.totals &&
        series == other.series;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, totals.hashCode);
    _$hash = $jc(_$hash, series.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1ProvidersMeStatsGet200Response')
          ..add('totals', totals)
          ..add('series', series))
        .toString();
  }
}

class V1ProvidersMeStatsGet200ResponseBuilder
    implements
        Builder<
          V1ProvidersMeStatsGet200Response,
          V1ProvidersMeStatsGet200ResponseBuilder
        > {
  _$V1ProvidersMeStatsGet200Response? _$v;

  V1ProvidersMeStatsGet200ResponseTotalsBuilder? _totals;
  V1ProvidersMeStatsGet200ResponseTotalsBuilder get totals =>
      _$this._totals ??= V1ProvidersMeStatsGet200ResponseTotalsBuilder();
  set totals(V1ProvidersMeStatsGet200ResponseTotalsBuilder? totals) =>
      _$this._totals = totals;

  ListBuilder<V1ProvidersMeStatsGet200ResponseSeriesInner>? _series;
  ListBuilder<V1ProvidersMeStatsGet200ResponseSeriesInner> get series =>
      _$this._series ??=
          ListBuilder<V1ProvidersMeStatsGet200ResponseSeriesInner>();
  set series(
    ListBuilder<V1ProvidersMeStatsGet200ResponseSeriesInner>? series,
  ) => _$this._series = series;

  V1ProvidersMeStatsGet200ResponseBuilder() {
    V1ProvidersMeStatsGet200Response._defaults(this);
  }

  V1ProvidersMeStatsGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _totals = $v.totals.toBuilder();
      _series = $v.series.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeStatsGet200Response other) {
    _$v = other as _$V1ProvidersMeStatsGet200Response;
  }

  @override
  void update(void Function(V1ProvidersMeStatsGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeStatsGet200Response build() => _build();

  _$V1ProvidersMeStatsGet200Response _build() {
    _$V1ProvidersMeStatsGet200Response _$result;
    try {
      _$result =
          _$v ??
          _$V1ProvidersMeStatsGet200Response._(
            totals: totals.build(),
            series: series.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'totals';
        totals.build();
        _$failedField = 'series';
        series.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'V1ProvidersMeStatsGet200Response',
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

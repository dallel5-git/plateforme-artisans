// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_coverage_areas_put200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMeCoverageAreasPut200Response
    extends V1ProvidersMeCoverageAreasPut200Response {
  @override
  final BuiltList<V1ProvidersMeCoverageAreasPut200ResponseCoverageAreasInner>
      coverageAreas;
  @override
  final int completionScore;

  factory _$V1ProvidersMeCoverageAreasPut200Response(
          [void Function(V1ProvidersMeCoverageAreasPut200ResponseBuilder)?
              updates]) =>
      (V1ProvidersMeCoverageAreasPut200ResponseBuilder()..update(updates))
          ._build();

  _$V1ProvidersMeCoverageAreasPut200Response._(
      {required this.coverageAreas, required this.completionScore})
      : super._();
  @override
  V1ProvidersMeCoverageAreasPut200Response rebuild(
          void Function(V1ProvidersMeCoverageAreasPut200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeCoverageAreasPut200ResponseBuilder toBuilder() =>
      V1ProvidersMeCoverageAreasPut200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeCoverageAreasPut200Response &&
        coverageAreas == other.coverageAreas &&
        completionScore == other.completionScore;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, coverageAreas.hashCode);
    _$hash = $jc(_$hash, completionScore.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersMeCoverageAreasPut200Response')
          ..add('coverageAreas', coverageAreas)
          ..add('completionScore', completionScore))
        .toString();
  }
}

class V1ProvidersMeCoverageAreasPut200ResponseBuilder
    implements
        Builder<V1ProvidersMeCoverageAreasPut200Response,
            V1ProvidersMeCoverageAreasPut200ResponseBuilder> {
  _$V1ProvidersMeCoverageAreasPut200Response? _$v;

  ListBuilder<V1ProvidersMeCoverageAreasPut200ResponseCoverageAreasInner>?
      _coverageAreas;
  ListBuilder<V1ProvidersMeCoverageAreasPut200ResponseCoverageAreasInner>
      get coverageAreas => _$this._coverageAreas ??= ListBuilder<
          V1ProvidersMeCoverageAreasPut200ResponseCoverageAreasInner>();
  set coverageAreas(
          ListBuilder<
                  V1ProvidersMeCoverageAreasPut200ResponseCoverageAreasInner>?
              coverageAreas) =>
      _$this._coverageAreas = coverageAreas;

  int? _completionScore;
  int? get completionScore => _$this._completionScore;
  set completionScore(int? completionScore) =>
      _$this._completionScore = completionScore;

  V1ProvidersMeCoverageAreasPut200ResponseBuilder() {
    V1ProvidersMeCoverageAreasPut200Response._defaults(this);
  }

  V1ProvidersMeCoverageAreasPut200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _coverageAreas = $v.coverageAreas.toBuilder();
      _completionScore = $v.completionScore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeCoverageAreasPut200Response other) {
    _$v = other as _$V1ProvidersMeCoverageAreasPut200Response;
  }

  @override
  void update(
      void Function(V1ProvidersMeCoverageAreasPut200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeCoverageAreasPut200Response build() => _build();

  _$V1ProvidersMeCoverageAreasPut200Response _build() {
    _$V1ProvidersMeCoverageAreasPut200Response _$result;
    try {
      _$result = _$v ??
          _$V1ProvidersMeCoverageAreasPut200Response._(
            coverageAreas: coverageAreas.build(),
            completionScore: BuiltValueNullFieldError.checkNotNull(
                completionScore,
                r'V1ProvidersMeCoverageAreasPut200Response',
                'completionScore'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'coverageAreas';
        coverageAreas.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1ProvidersMeCoverageAreasPut200Response',
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

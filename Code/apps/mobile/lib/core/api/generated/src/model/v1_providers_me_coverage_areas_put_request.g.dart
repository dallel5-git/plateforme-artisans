// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_coverage_areas_put_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMeCoverageAreasPutRequest
    extends V1ProvidersMeCoverageAreasPutRequest {
  @override
  final BuiltList<V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner>
      coverageAreas;

  factory _$V1ProvidersMeCoverageAreasPutRequest(
          [void Function(V1ProvidersMeCoverageAreasPutRequestBuilder)?
              updates]) =>
      (V1ProvidersMeCoverageAreasPutRequestBuilder()..update(updates))._build();

  _$V1ProvidersMeCoverageAreasPutRequest._({required this.coverageAreas})
      : super._();
  @override
  V1ProvidersMeCoverageAreasPutRequest rebuild(
          void Function(V1ProvidersMeCoverageAreasPutRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeCoverageAreasPutRequestBuilder toBuilder() =>
      V1ProvidersMeCoverageAreasPutRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeCoverageAreasPutRequest &&
        coverageAreas == other.coverageAreas;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, coverageAreas.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1ProvidersMeCoverageAreasPutRequest')
          ..add('coverageAreas', coverageAreas))
        .toString();
  }
}

class V1ProvidersMeCoverageAreasPutRequestBuilder
    implements
        Builder<V1ProvidersMeCoverageAreasPutRequest,
            V1ProvidersMeCoverageAreasPutRequestBuilder> {
  _$V1ProvidersMeCoverageAreasPutRequest? _$v;

  ListBuilder<V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner>?
      _coverageAreas;
  ListBuilder<V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner>
      get coverageAreas => _$this._coverageAreas ??=
          ListBuilder<V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner>();
  set coverageAreas(
          ListBuilder<V1ProvidersMeCoverageAreasPutRequestCoverageAreasInner>?
              coverageAreas) =>
      _$this._coverageAreas = coverageAreas;

  V1ProvidersMeCoverageAreasPutRequestBuilder() {
    V1ProvidersMeCoverageAreasPutRequest._defaults(this);
  }

  V1ProvidersMeCoverageAreasPutRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _coverageAreas = $v.coverageAreas.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeCoverageAreasPutRequest other) {
    _$v = other as _$V1ProvidersMeCoverageAreasPutRequest;
  }

  @override
  void update(
      void Function(V1ProvidersMeCoverageAreasPutRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeCoverageAreasPutRequest build() => _build();

  _$V1ProvidersMeCoverageAreasPutRequest _build() {
    _$V1ProvidersMeCoverageAreasPutRequest _$result;
    try {
      _$result = _$v ??
          _$V1ProvidersMeCoverageAreasPutRequest._(
            coverageAreas: coverageAreas.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'coverageAreas';
        coverageAreas.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1ProvidersMeCoverageAreasPutRequest',
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

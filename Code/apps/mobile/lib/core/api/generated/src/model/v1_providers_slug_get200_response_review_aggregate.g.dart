// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_slug_get200_response_review_aggregate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersSlugGet200ResponseReviewAggregate
    extends V1ProvidersSlugGet200ResponseReviewAggregate {
  @override
  final num average;
  @override
  final int count;
  @override
  final V1ProvidersSlugGet200ResponseReviewAggregateBreakdown breakdown;

  factory _$V1ProvidersSlugGet200ResponseReviewAggregate(
          [void Function(V1ProvidersSlugGet200ResponseReviewAggregateBuilder)?
              updates]) =>
      (V1ProvidersSlugGet200ResponseReviewAggregateBuilder()..update(updates))
          ._build();

  _$V1ProvidersSlugGet200ResponseReviewAggregate._(
      {required this.average, required this.count, required this.breakdown})
      : super._();
  @override
  V1ProvidersSlugGet200ResponseReviewAggregate rebuild(
          void Function(V1ProvidersSlugGet200ResponseReviewAggregateBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersSlugGet200ResponseReviewAggregateBuilder toBuilder() =>
      V1ProvidersSlugGet200ResponseReviewAggregateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersSlugGet200ResponseReviewAggregate &&
        average == other.average &&
        count == other.count &&
        breakdown == other.breakdown;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, average.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, breakdown.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersSlugGet200ResponseReviewAggregate')
          ..add('average', average)
          ..add('count', count)
          ..add('breakdown', breakdown))
        .toString();
  }
}

class V1ProvidersSlugGet200ResponseReviewAggregateBuilder
    implements
        Builder<V1ProvidersSlugGet200ResponseReviewAggregate,
            V1ProvidersSlugGet200ResponseReviewAggregateBuilder> {
  _$V1ProvidersSlugGet200ResponseReviewAggregate? _$v;

  num? _average;
  num? get average => _$this._average;
  set average(num? average) => _$this._average = average;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  V1ProvidersSlugGet200ResponseReviewAggregateBreakdownBuilder? _breakdown;
  V1ProvidersSlugGet200ResponseReviewAggregateBreakdownBuilder get breakdown =>
      _$this._breakdown ??=
          V1ProvidersSlugGet200ResponseReviewAggregateBreakdownBuilder();
  set breakdown(
          V1ProvidersSlugGet200ResponseReviewAggregateBreakdownBuilder?
              breakdown) =>
      _$this._breakdown = breakdown;

  V1ProvidersSlugGet200ResponseReviewAggregateBuilder() {
    V1ProvidersSlugGet200ResponseReviewAggregate._defaults(this);
  }

  V1ProvidersSlugGet200ResponseReviewAggregateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _average = $v.average;
      _count = $v.count;
      _breakdown = $v.breakdown.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersSlugGet200ResponseReviewAggregate other) {
    _$v = other as _$V1ProvidersSlugGet200ResponseReviewAggregate;
  }

  @override
  void update(
      void Function(V1ProvidersSlugGet200ResponseReviewAggregateBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersSlugGet200ResponseReviewAggregate build() => _build();

  _$V1ProvidersSlugGet200ResponseReviewAggregate _build() {
    _$V1ProvidersSlugGet200ResponseReviewAggregate _$result;
    try {
      _$result = _$v ??
          _$V1ProvidersSlugGet200ResponseReviewAggregate._(
            average: BuiltValueNullFieldError.checkNotNull(average,
                r'V1ProvidersSlugGet200ResponseReviewAggregate', 'average'),
            count: BuiltValueNullFieldError.checkNotNull(count,
                r'V1ProvidersSlugGet200ResponseReviewAggregate', 'count'),
            breakdown: breakdown.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'breakdown';
        breakdown.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1ProvidersSlugGet200ResponseReviewAggregate',
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

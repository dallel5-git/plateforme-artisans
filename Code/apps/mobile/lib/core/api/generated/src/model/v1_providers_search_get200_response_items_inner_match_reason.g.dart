// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_search_get200_response_items_inner_match_reason.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersSearchGet200ResponseItemsInnerMatchReason
    extends V1ProvidersSearchGet200ResponseItemsInnerMatchReason {
  @override
  final num geo;
  @override
  final num rating;
  @override
  final num trust;
  @override
  final num completion;
  @override
  final num responsiveness;
  @override
  final num plan;
  @override
  final num penalty;

  factory _$V1ProvidersSearchGet200ResponseItemsInnerMatchReason(
          [void Function(
                  V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder)?
              updates]) =>
      (V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder()
            ..update(updates))
          ._build();

  _$V1ProvidersSearchGet200ResponseItemsInnerMatchReason._(
      {required this.geo,
      required this.rating,
      required this.trust,
      required this.completion,
      required this.responsiveness,
      required this.plan,
      required this.penalty})
      : super._();
  @override
  V1ProvidersSearchGet200ResponseItemsInnerMatchReason rebuild(
          void Function(
                  V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder toBuilder() =>
      V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersSearchGet200ResponseItemsInnerMatchReason &&
        geo == other.geo &&
        rating == other.rating &&
        trust == other.trust &&
        completion == other.completion &&
        responsiveness == other.responsiveness &&
        plan == other.plan &&
        penalty == other.penalty;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, geo.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, trust.hashCode);
    _$hash = $jc(_$hash, completion.hashCode);
    _$hash = $jc(_$hash, responsiveness.hashCode);
    _$hash = $jc(_$hash, plan.hashCode);
    _$hash = $jc(_$hash, penalty.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersSearchGet200ResponseItemsInnerMatchReason')
          ..add('geo', geo)
          ..add('rating', rating)
          ..add('trust', trust)
          ..add('completion', completion)
          ..add('responsiveness', responsiveness)
          ..add('plan', plan)
          ..add('penalty', penalty))
        .toString();
  }
}

class V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder
    implements
        Builder<V1ProvidersSearchGet200ResponseItemsInnerMatchReason,
            V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder> {
  _$V1ProvidersSearchGet200ResponseItemsInnerMatchReason? _$v;

  num? _geo;
  num? get geo => _$this._geo;
  set geo(num? geo) => _$this._geo = geo;

  num? _rating;
  num? get rating => _$this._rating;
  set rating(num? rating) => _$this._rating = rating;

  num? _trust;
  num? get trust => _$this._trust;
  set trust(num? trust) => _$this._trust = trust;

  num? _completion;
  num? get completion => _$this._completion;
  set completion(num? completion) => _$this._completion = completion;

  num? _responsiveness;
  num? get responsiveness => _$this._responsiveness;
  set responsiveness(num? responsiveness) =>
      _$this._responsiveness = responsiveness;

  num? _plan;
  num? get plan => _$this._plan;
  set plan(num? plan) => _$this._plan = plan;

  num? _penalty;
  num? get penalty => _$this._penalty;
  set penalty(num? penalty) => _$this._penalty = penalty;

  V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder() {
    V1ProvidersSearchGet200ResponseItemsInnerMatchReason._defaults(this);
  }

  V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _geo = $v.geo;
      _rating = $v.rating;
      _trust = $v.trust;
      _completion = $v.completion;
      _responsiveness = $v.responsiveness;
      _plan = $v.plan;
      _penalty = $v.penalty;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersSearchGet200ResponseItemsInnerMatchReason other) {
    _$v = other as _$V1ProvidersSearchGet200ResponseItemsInnerMatchReason;
  }

  @override
  void update(
      void Function(
              V1ProvidersSearchGet200ResponseItemsInnerMatchReasonBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersSearchGet200ResponseItemsInnerMatchReason build() => _build();

  _$V1ProvidersSearchGet200ResponseItemsInnerMatchReason _build() {
    final _$result = _$v ??
        _$V1ProvidersSearchGet200ResponseItemsInnerMatchReason._(
          geo: BuiltValueNullFieldError.checkNotNull(geo,
              r'V1ProvidersSearchGet200ResponseItemsInnerMatchReason', 'geo'),
          rating: BuiltValueNullFieldError.checkNotNull(
              rating,
              r'V1ProvidersSearchGet200ResponseItemsInnerMatchReason',
              'rating'),
          trust: BuiltValueNullFieldError.checkNotNull(trust,
              r'V1ProvidersSearchGet200ResponseItemsInnerMatchReason', 'trust'),
          completion: BuiltValueNullFieldError.checkNotNull(
              completion,
              r'V1ProvidersSearchGet200ResponseItemsInnerMatchReason',
              'completion'),
          responsiveness: BuiltValueNullFieldError.checkNotNull(
              responsiveness,
              r'V1ProvidersSearchGet200ResponseItemsInnerMatchReason',
              'responsiveness'),
          plan: BuiltValueNullFieldError.checkNotNull(plan,
              r'V1ProvidersSearchGet200ResponseItemsInnerMatchReason', 'plan'),
          penalty: BuiltValueNullFieldError.checkNotNull(
              penalty,
              r'V1ProvidersSearchGet200ResponseItemsInnerMatchReason',
              'penalty'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

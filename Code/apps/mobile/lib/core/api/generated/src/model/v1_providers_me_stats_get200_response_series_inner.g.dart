// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_stats_get200_response_series_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMeStatsGet200ResponseSeriesInner
    extends V1ProvidersMeStatsGet200ResponseSeriesInner {
  @override
  final DateTime date;
  @override
  final int profileViews;
  @override
  final int uniqueProfileViews;
  @override
  final int contacts;

  factory _$V1ProvidersMeStatsGet200ResponseSeriesInner(
          [void Function(V1ProvidersMeStatsGet200ResponseSeriesInnerBuilder)?
              updates]) =>
      (V1ProvidersMeStatsGet200ResponseSeriesInnerBuilder()..update(updates))
          ._build();

  _$V1ProvidersMeStatsGet200ResponseSeriesInner._(
      {required this.date,
      required this.profileViews,
      required this.uniqueProfileViews,
      required this.contacts})
      : super._();
  @override
  V1ProvidersMeStatsGet200ResponseSeriesInner rebuild(
          void Function(V1ProvidersMeStatsGet200ResponseSeriesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeStatsGet200ResponseSeriesInnerBuilder toBuilder() =>
      V1ProvidersMeStatsGet200ResponseSeriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeStatsGet200ResponseSeriesInner &&
        date == other.date &&
        profileViews == other.profileViews &&
        uniqueProfileViews == other.uniqueProfileViews &&
        contacts == other.contacts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, profileViews.hashCode);
    _$hash = $jc(_$hash, uniqueProfileViews.hashCode);
    _$hash = $jc(_$hash, contacts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersMeStatsGet200ResponseSeriesInner')
          ..add('date', date)
          ..add('profileViews', profileViews)
          ..add('uniqueProfileViews', uniqueProfileViews)
          ..add('contacts', contacts))
        .toString();
  }
}

class V1ProvidersMeStatsGet200ResponseSeriesInnerBuilder
    implements
        Builder<V1ProvidersMeStatsGet200ResponseSeriesInner,
            V1ProvidersMeStatsGet200ResponseSeriesInnerBuilder> {
  _$V1ProvidersMeStatsGet200ResponseSeriesInner? _$v;

  DateTime? _date;
  DateTime? get date => _$this._date;
  set date(DateTime? date) => _$this._date = date;

  int? _profileViews;
  int? get profileViews => _$this._profileViews;
  set profileViews(int? profileViews) => _$this._profileViews = profileViews;

  int? _uniqueProfileViews;
  int? get uniqueProfileViews => _$this._uniqueProfileViews;
  set uniqueProfileViews(int? uniqueProfileViews) =>
      _$this._uniqueProfileViews = uniqueProfileViews;

  int? _contacts;
  int? get contacts => _$this._contacts;
  set contacts(int? contacts) => _$this._contacts = contacts;

  V1ProvidersMeStatsGet200ResponseSeriesInnerBuilder() {
    V1ProvidersMeStatsGet200ResponseSeriesInner._defaults(this);
  }

  V1ProvidersMeStatsGet200ResponseSeriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _profileViews = $v.profileViews;
      _uniqueProfileViews = $v.uniqueProfileViews;
      _contacts = $v.contacts;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeStatsGet200ResponseSeriesInner other) {
    _$v = other as _$V1ProvidersMeStatsGet200ResponseSeriesInner;
  }

  @override
  void update(
      void Function(V1ProvidersMeStatsGet200ResponseSeriesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeStatsGet200ResponseSeriesInner build() => _build();

  _$V1ProvidersMeStatsGet200ResponseSeriesInner _build() {
    final _$result = _$v ??
        _$V1ProvidersMeStatsGet200ResponseSeriesInner._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'V1ProvidersMeStatsGet200ResponseSeriesInner', 'date'),
          profileViews: BuiltValueNullFieldError.checkNotNull(profileViews,
              r'V1ProvidersMeStatsGet200ResponseSeriesInner', 'profileViews'),
          uniqueProfileViews: BuiltValueNullFieldError.checkNotNull(
              uniqueProfileViews,
              r'V1ProvidersMeStatsGet200ResponseSeriesInner',
              'uniqueProfileViews'),
          contacts: BuiltValueNullFieldError.checkNotNull(contacts,
              r'V1ProvidersMeStatsGet200ResponseSeriesInner', 'contacts'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

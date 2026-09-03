// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_stats_get200_response_totals.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMeStatsGet200ResponseTotals
    extends V1ProvidersMeStatsGet200ResponseTotals {
  @override
  final int profileViews;
  @override
  final int uniqueProfileViews;
  @override
  final int contacts;
  @override
  final V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel
      contactsByChannel;
  @override
  final num viewToContactRatio;

  factory _$V1ProvidersMeStatsGet200ResponseTotals(
          [void Function(V1ProvidersMeStatsGet200ResponseTotalsBuilder)?
              updates]) =>
      (V1ProvidersMeStatsGet200ResponseTotalsBuilder()..update(updates))
          ._build();

  _$V1ProvidersMeStatsGet200ResponseTotals._(
      {required this.profileViews,
      required this.uniqueProfileViews,
      required this.contacts,
      required this.contactsByChannel,
      required this.viewToContactRatio})
      : super._();
  @override
  V1ProvidersMeStatsGet200ResponseTotals rebuild(
          void Function(V1ProvidersMeStatsGet200ResponseTotalsBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeStatsGet200ResponseTotalsBuilder toBuilder() =>
      V1ProvidersMeStatsGet200ResponseTotalsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeStatsGet200ResponseTotals &&
        profileViews == other.profileViews &&
        uniqueProfileViews == other.uniqueProfileViews &&
        contacts == other.contacts &&
        contactsByChannel == other.contactsByChannel &&
        viewToContactRatio == other.viewToContactRatio;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, profileViews.hashCode);
    _$hash = $jc(_$hash, uniqueProfileViews.hashCode);
    _$hash = $jc(_$hash, contacts.hashCode);
    _$hash = $jc(_$hash, contactsByChannel.hashCode);
    _$hash = $jc(_$hash, viewToContactRatio.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersMeStatsGet200ResponseTotals')
          ..add('profileViews', profileViews)
          ..add('uniqueProfileViews', uniqueProfileViews)
          ..add('contacts', contacts)
          ..add('contactsByChannel', contactsByChannel)
          ..add('viewToContactRatio', viewToContactRatio))
        .toString();
  }
}

class V1ProvidersMeStatsGet200ResponseTotalsBuilder
    implements
        Builder<V1ProvidersMeStatsGet200ResponseTotals,
            V1ProvidersMeStatsGet200ResponseTotalsBuilder> {
  _$V1ProvidersMeStatsGet200ResponseTotals? _$v;

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

  V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder?
      _contactsByChannel;
  V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder
      get contactsByChannel => _$this._contactsByChannel ??=
          V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder();
  set contactsByChannel(
          V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder?
              contactsByChannel) =>
      _$this._contactsByChannel = contactsByChannel;

  num? _viewToContactRatio;
  num? get viewToContactRatio => _$this._viewToContactRatio;
  set viewToContactRatio(num? viewToContactRatio) =>
      _$this._viewToContactRatio = viewToContactRatio;

  V1ProvidersMeStatsGet200ResponseTotalsBuilder() {
    V1ProvidersMeStatsGet200ResponseTotals._defaults(this);
  }

  V1ProvidersMeStatsGet200ResponseTotalsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _profileViews = $v.profileViews;
      _uniqueProfileViews = $v.uniqueProfileViews;
      _contacts = $v.contacts;
      _contactsByChannel = $v.contactsByChannel.toBuilder();
      _viewToContactRatio = $v.viewToContactRatio;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeStatsGet200ResponseTotals other) {
    _$v = other as _$V1ProvidersMeStatsGet200ResponseTotals;
  }

  @override
  void update(
      void Function(V1ProvidersMeStatsGet200ResponseTotalsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeStatsGet200ResponseTotals build() => _build();

  _$V1ProvidersMeStatsGet200ResponseTotals _build() {
    _$V1ProvidersMeStatsGet200ResponseTotals _$result;
    try {
      _$result = _$v ??
          _$V1ProvidersMeStatsGet200ResponseTotals._(
            profileViews: BuiltValueNullFieldError.checkNotNull(profileViews,
                r'V1ProvidersMeStatsGet200ResponseTotals', 'profileViews'),
            uniqueProfileViews: BuiltValueNullFieldError.checkNotNull(
                uniqueProfileViews,
                r'V1ProvidersMeStatsGet200ResponseTotals',
                'uniqueProfileViews'),
            contacts: BuiltValueNullFieldError.checkNotNull(contacts,
                r'V1ProvidersMeStatsGet200ResponseTotals', 'contacts'),
            contactsByChannel: contactsByChannel.build(),
            viewToContactRatio: BuiltValueNullFieldError.checkNotNull(
                viewToContactRatio,
                r'V1ProvidersMeStatsGet200ResponseTotals',
                'viewToContactRatio'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'contactsByChannel';
        contactsByChannel.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1ProvidersMeStatsGet200ResponseTotals',
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

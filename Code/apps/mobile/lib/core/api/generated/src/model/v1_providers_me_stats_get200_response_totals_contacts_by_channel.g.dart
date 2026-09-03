// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_stats_get200_response_totals_contacts_by_channel.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel
    extends V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel {
  @override
  final int phone;
  @override
  final int whatsapp;

  factory _$V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel(
          [void Function(
                  V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder)?
              updates]) =>
      (V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder()
            ..update(updates))
          ._build();

  _$V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel._(
      {required this.phone, required this.whatsapp})
      : super._();
  @override
  V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel rebuild(
          void Function(
                  V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder toBuilder() =>
      V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel &&
        phone == other.phone &&
        whatsapp == other.whatsapp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, whatsapp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel')
          ..add('phone', phone)
          ..add('whatsapp', whatsapp))
        .toString();
  }
}

class V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder
    implements
        Builder<V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel,
            V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder> {
  _$V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel? _$v;

  int? _phone;
  int? get phone => _$this._phone;
  set phone(int? phone) => _$this._phone = phone;

  int? _whatsapp;
  int? get whatsapp => _$this._whatsapp;
  set whatsapp(int? whatsapp) => _$this._whatsapp = whatsapp;

  V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder() {
    V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel._defaults(this);
  }

  V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _whatsapp = $v.whatsapp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel other) {
    _$v = other as _$V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel;
  }

  @override
  void update(
      void Function(
              V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel build() => _build();

  _$V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel _build() {
    final _$result = _$v ??
        _$V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel._(
          phone: BuiltValueNullFieldError.checkNotNull(
              phone,
              r'V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel',
              'phone'),
          whatsapp: BuiltValueNullFieldError.checkNotNull(
              whatsapp,
              r'V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel',
              'whatsapp'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

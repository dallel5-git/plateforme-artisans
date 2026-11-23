// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_users_me_export_get200_response_contact_events_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1UsersMeExportGet200ResponseContactEventsInner
    extends V1UsersMeExportGet200ResponseContactEventsInner {
  @override
  final String id;
  @override
  final String providerId;
  @override
  final String providerBusinessName;
  @override
  final String channel;
  @override
  final DateTime createdAt;

  factory _$V1UsersMeExportGet200ResponseContactEventsInner(
          [void Function(
                  V1UsersMeExportGet200ResponseContactEventsInnerBuilder)?
              updates]) =>
      (V1UsersMeExportGet200ResponseContactEventsInnerBuilder()
            ..update(updates))
          ._build();

  _$V1UsersMeExportGet200ResponseContactEventsInner._(
      {required this.id,
      required this.providerId,
      required this.providerBusinessName,
      required this.channel,
      required this.createdAt})
      : super._();
  @override
  V1UsersMeExportGet200ResponseContactEventsInner rebuild(
          void Function(V1UsersMeExportGet200ResponseContactEventsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1UsersMeExportGet200ResponseContactEventsInnerBuilder toBuilder() =>
      V1UsersMeExportGet200ResponseContactEventsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1UsersMeExportGet200ResponseContactEventsInner &&
        id == other.id &&
        providerId == other.providerId &&
        providerBusinessName == other.providerBusinessName &&
        channel == other.channel &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, providerId.hashCode);
    _$hash = $jc(_$hash, providerBusinessName.hashCode);
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1UsersMeExportGet200ResponseContactEventsInner')
          ..add('id', id)
          ..add('providerId', providerId)
          ..add('providerBusinessName', providerBusinessName)
          ..add('channel', channel)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class V1UsersMeExportGet200ResponseContactEventsInnerBuilder
    implements
        Builder<V1UsersMeExportGet200ResponseContactEventsInner,
            V1UsersMeExportGet200ResponseContactEventsInnerBuilder> {
  _$V1UsersMeExportGet200ResponseContactEventsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _providerId;
  String? get providerId => _$this._providerId;
  set providerId(String? providerId) => _$this._providerId = providerId;

  String? _providerBusinessName;
  String? get providerBusinessName => _$this._providerBusinessName;
  set providerBusinessName(String? providerBusinessName) =>
      _$this._providerBusinessName = providerBusinessName;

  String? _channel;
  String? get channel => _$this._channel;
  set channel(String? channel) => _$this._channel = channel;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  V1UsersMeExportGet200ResponseContactEventsInnerBuilder() {
    V1UsersMeExportGet200ResponseContactEventsInner._defaults(this);
  }

  V1UsersMeExportGet200ResponseContactEventsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _providerId = $v.providerId;
      _providerBusinessName = $v.providerBusinessName;
      _channel = $v.channel;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1UsersMeExportGet200ResponseContactEventsInner other) {
    _$v = other as _$V1UsersMeExportGet200ResponseContactEventsInner;
  }

  @override
  void update(
      void Function(V1UsersMeExportGet200ResponseContactEventsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1UsersMeExportGet200ResponseContactEventsInner build() => _build();

  _$V1UsersMeExportGet200ResponseContactEventsInner _build() {
    final _$result = _$v ??
        _$V1UsersMeExportGet200ResponseContactEventsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'V1UsersMeExportGet200ResponseContactEventsInner', 'id'),
          providerId: BuiltValueNullFieldError.checkNotNull(providerId,
              r'V1UsersMeExportGet200ResponseContactEventsInner', 'providerId'),
          providerBusinessName: BuiltValueNullFieldError.checkNotNull(
              providerBusinessName,
              r'V1UsersMeExportGet200ResponseContactEventsInner',
              'providerBusinessName'),
          channel: BuiltValueNullFieldError.checkNotNull(channel,
              r'V1UsersMeExportGet200ResponseContactEventsInner', 'channel'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'V1UsersMeExportGet200ResponseContactEventsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_contact_events_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ContactEventsPost200ResponseChannelEnum
    _$v1ContactEventsPost200ResponseChannelEnum_PHONE =
    const V1ContactEventsPost200ResponseChannelEnum._('PHONE');
const V1ContactEventsPost200ResponseChannelEnum
    _$v1ContactEventsPost200ResponseChannelEnum_WHATSAPP =
    const V1ContactEventsPost200ResponseChannelEnum._('WHATSAPP');

V1ContactEventsPost200ResponseChannelEnum
    _$v1ContactEventsPost200ResponseChannelEnumValueOf(String name) {
  switch (name) {
    case 'PHONE':
      return _$v1ContactEventsPost200ResponseChannelEnum_PHONE;
    case 'WHATSAPP':
      return _$v1ContactEventsPost200ResponseChannelEnum_WHATSAPP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ContactEventsPost200ResponseChannelEnum>
    _$v1ContactEventsPost200ResponseChannelEnumValues = BuiltSet<
        V1ContactEventsPost200ResponseChannelEnum>(const <V1ContactEventsPost200ResponseChannelEnum>[
  _$v1ContactEventsPost200ResponseChannelEnum_PHONE,
  _$v1ContactEventsPost200ResponseChannelEnum_WHATSAPP,
]);

Serializer<V1ContactEventsPost200ResponseChannelEnum>
    _$v1ContactEventsPost200ResponseChannelEnumSerializer =
    _$V1ContactEventsPost200ResponseChannelEnumSerializer();

class _$V1ContactEventsPost200ResponseChannelEnumSerializer
    implements PrimitiveSerializer<V1ContactEventsPost200ResponseChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PHONE': 'PHONE',
    'WHATSAPP': 'WHATSAPP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PHONE': 'PHONE',
    'WHATSAPP': 'WHATSAPP',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1ContactEventsPost200ResponseChannelEnum
  ];
  @override
  final String wireName = 'V1ContactEventsPost200ResponseChannelEnum';

  @override
  Object serialize(Serializers serializers,
          V1ContactEventsPost200ResponseChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ContactEventsPost200ResponseChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ContactEventsPost200ResponseChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ContactEventsPost200Response extends V1ContactEventsPost200Response {
  @override
  final String contactEventId;
  @override
  final String providerId;
  @override
  final V1ContactEventsPost200ResponseChannelEnum channel;
  @override
  final String phone;
  @override
  final String? whatsappMessage;
  @override
  final bool deduplicated;

  factory _$V1ContactEventsPost200Response(
          [void Function(V1ContactEventsPost200ResponseBuilder)? updates]) =>
      (V1ContactEventsPost200ResponseBuilder()..update(updates))._build();

  _$V1ContactEventsPost200Response._(
      {required this.contactEventId,
      required this.providerId,
      required this.channel,
      required this.phone,
      this.whatsappMessage,
      required this.deduplicated})
      : super._();
  @override
  V1ContactEventsPost200Response rebuild(
          void Function(V1ContactEventsPost200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ContactEventsPost200ResponseBuilder toBuilder() =>
      V1ContactEventsPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ContactEventsPost200Response &&
        contactEventId == other.contactEventId &&
        providerId == other.providerId &&
        channel == other.channel &&
        phone == other.phone &&
        whatsappMessage == other.whatsappMessage &&
        deduplicated == other.deduplicated;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contactEventId.hashCode);
    _$hash = $jc(_$hash, providerId.hashCode);
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, whatsappMessage.hashCode);
    _$hash = $jc(_$hash, deduplicated.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1ContactEventsPost200Response')
          ..add('contactEventId', contactEventId)
          ..add('providerId', providerId)
          ..add('channel', channel)
          ..add('phone', phone)
          ..add('whatsappMessage', whatsappMessage)
          ..add('deduplicated', deduplicated))
        .toString();
  }
}

class V1ContactEventsPost200ResponseBuilder
    implements
        Builder<V1ContactEventsPost200Response,
            V1ContactEventsPost200ResponseBuilder> {
  _$V1ContactEventsPost200Response? _$v;

  String? _contactEventId;
  String? get contactEventId => _$this._contactEventId;
  set contactEventId(String? contactEventId) =>
      _$this._contactEventId = contactEventId;

  String? _providerId;
  String? get providerId => _$this._providerId;
  set providerId(String? providerId) => _$this._providerId = providerId;

  V1ContactEventsPost200ResponseChannelEnum? _channel;
  V1ContactEventsPost200ResponseChannelEnum? get channel => _$this._channel;
  set channel(V1ContactEventsPost200ResponseChannelEnum? channel) =>
      _$this._channel = channel;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _whatsappMessage;
  String? get whatsappMessage => _$this._whatsappMessage;
  set whatsappMessage(String? whatsappMessage) =>
      _$this._whatsappMessage = whatsappMessage;

  bool? _deduplicated;
  bool? get deduplicated => _$this._deduplicated;
  set deduplicated(bool? deduplicated) => _$this._deduplicated = deduplicated;

  V1ContactEventsPost200ResponseBuilder() {
    V1ContactEventsPost200Response._defaults(this);
  }

  V1ContactEventsPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contactEventId = $v.contactEventId;
      _providerId = $v.providerId;
      _channel = $v.channel;
      _phone = $v.phone;
      _whatsappMessage = $v.whatsappMessage;
      _deduplicated = $v.deduplicated;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ContactEventsPost200Response other) {
    _$v = other as _$V1ContactEventsPost200Response;
  }

  @override
  void update(void Function(V1ContactEventsPost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ContactEventsPost200Response build() => _build();

  _$V1ContactEventsPost200Response _build() {
    final _$result = _$v ??
        _$V1ContactEventsPost200Response._(
          contactEventId: BuiltValueNullFieldError.checkNotNull(contactEventId,
              r'V1ContactEventsPost200Response', 'contactEventId'),
          providerId: BuiltValueNullFieldError.checkNotNull(
              providerId, r'V1ContactEventsPost200Response', 'providerId'),
          channel: BuiltValueNullFieldError.checkNotNull(
              channel, r'V1ContactEventsPost200Response', 'channel'),
          phone: BuiltValueNullFieldError.checkNotNull(
              phone, r'V1ContactEventsPost200Response', 'phone'),
          whatsappMessage: whatsappMessage,
          deduplicated: BuiltValueNullFieldError.checkNotNull(
              deduplicated, r'V1ContactEventsPost200Response', 'deduplicated'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

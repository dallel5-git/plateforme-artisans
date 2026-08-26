// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_event_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ContactEventResponseChannelEnum _$contactEventResponseChannelEnum_PHONE =
    const ContactEventResponseChannelEnum._('PHONE');
const ContactEventResponseChannelEnum
    _$contactEventResponseChannelEnum_WHATSAPP =
    const ContactEventResponseChannelEnum._('WHATSAPP');

ContactEventResponseChannelEnum _$contactEventResponseChannelEnumValueOf(
    String name) {
  switch (name) {
    case 'PHONE':
      return _$contactEventResponseChannelEnum_PHONE;
    case 'WHATSAPP':
      return _$contactEventResponseChannelEnum_WHATSAPP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ContactEventResponseChannelEnum>
    _$contactEventResponseChannelEnumValues = BuiltSet<
        ContactEventResponseChannelEnum>(const <ContactEventResponseChannelEnum>[
  _$contactEventResponseChannelEnum_PHONE,
  _$contactEventResponseChannelEnum_WHATSAPP,
]);

Serializer<ContactEventResponseChannelEnum>
    _$contactEventResponseChannelEnumSerializer =
    _$ContactEventResponseChannelEnumSerializer();

class _$ContactEventResponseChannelEnumSerializer
    implements PrimitiveSerializer<ContactEventResponseChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PHONE': 'PHONE',
    'WHATSAPP': 'WHATSAPP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PHONE': 'PHONE',
    'WHATSAPP': 'WHATSAPP',
  };

  @override
  final Iterable<Type> types = const <Type>[ContactEventResponseChannelEnum];
  @override
  final String wireName = 'ContactEventResponseChannelEnum';

  @override
  Object serialize(
          Serializers serializers, ContactEventResponseChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ContactEventResponseChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ContactEventResponseChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ContactEventResponse extends ContactEventResponse {
  @override
  final String contactEventId;
  @override
  final String providerId;
  @override
  final ContactEventResponseChannelEnum channel;
  @override
  final String phone;
  @override
  final String? whatsappMessage;
  @override
  final bool deduplicated;

  factory _$ContactEventResponse(
          [void Function(ContactEventResponseBuilder)? updates]) =>
      (ContactEventResponseBuilder()..update(updates))._build();

  _$ContactEventResponse._(
      {required this.contactEventId,
      required this.providerId,
      required this.channel,
      required this.phone,
      this.whatsappMessage,
      required this.deduplicated})
      : super._();
  @override
  ContactEventResponse rebuild(
          void Function(ContactEventResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContactEventResponseBuilder toBuilder() =>
      ContactEventResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactEventResponse &&
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
    return (newBuiltValueToStringHelper(r'ContactEventResponse')
          ..add('contactEventId', contactEventId)
          ..add('providerId', providerId)
          ..add('channel', channel)
          ..add('phone', phone)
          ..add('whatsappMessage', whatsappMessage)
          ..add('deduplicated', deduplicated))
        .toString();
  }
}

class ContactEventResponseBuilder
    implements Builder<ContactEventResponse, ContactEventResponseBuilder> {
  _$ContactEventResponse? _$v;

  String? _contactEventId;
  String? get contactEventId => _$this._contactEventId;
  set contactEventId(String? contactEventId) =>
      _$this._contactEventId = contactEventId;

  String? _providerId;
  String? get providerId => _$this._providerId;
  set providerId(String? providerId) => _$this._providerId = providerId;

  ContactEventResponseChannelEnum? _channel;
  ContactEventResponseChannelEnum? get channel => _$this._channel;
  set channel(ContactEventResponseChannelEnum? channel) =>
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

  ContactEventResponseBuilder() {
    ContactEventResponse._defaults(this);
  }

  ContactEventResponseBuilder get _$this {
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
  void replace(ContactEventResponse other) {
    _$v = other as _$ContactEventResponse;
  }

  @override
  void update(void Function(ContactEventResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactEventResponse build() => _build();

  _$ContactEventResponse _build() {
    final _$result = _$v ??
        _$ContactEventResponse._(
          contactEventId: BuiltValueNullFieldError.checkNotNull(
              contactEventId, r'ContactEventResponse', 'contactEventId'),
          providerId: BuiltValueNullFieldError.checkNotNull(
              providerId, r'ContactEventResponse', 'providerId'),
          channel: BuiltValueNullFieldError.checkNotNull(
              channel, r'ContactEventResponse', 'channel'),
          phone: BuiltValueNullFieldError.checkNotNull(
              phone, r'ContactEventResponse', 'phone'),
          whatsappMessage: whatsappMessage,
          deduplicated: BuiltValueNullFieldError.checkNotNull(
              deduplicated, r'ContactEventResponse', 'deduplicated'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

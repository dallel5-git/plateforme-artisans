// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_event_response_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ContactEventResponseInputChannelEnum
_$contactEventResponseInputChannelEnum_PHONE =
    const ContactEventResponseInputChannelEnum._('PHONE');
const ContactEventResponseInputChannelEnum
_$contactEventResponseInputChannelEnum_WHATSAPP =
    const ContactEventResponseInputChannelEnum._('WHATSAPP');

ContactEventResponseInputChannelEnum
_$contactEventResponseInputChannelEnumValueOf(String name) {
  switch (name) {
    case 'PHONE':
      return _$contactEventResponseInputChannelEnum_PHONE;
    case 'WHATSAPP':
      return _$contactEventResponseInputChannelEnum_WHATSAPP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ContactEventResponseInputChannelEnum>
_$contactEventResponseInputChannelEnumValues =
    BuiltSet<ContactEventResponseInputChannelEnum>(
      const <ContactEventResponseInputChannelEnum>[
        _$contactEventResponseInputChannelEnum_PHONE,
        _$contactEventResponseInputChannelEnum_WHATSAPP,
      ],
    );

Serializer<ContactEventResponseInputChannelEnum>
_$contactEventResponseInputChannelEnumSerializer =
    _$ContactEventResponseInputChannelEnumSerializer();

class _$ContactEventResponseInputChannelEnumSerializer
    implements PrimitiveSerializer<ContactEventResponseInputChannelEnum> {
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
    ContactEventResponseInputChannelEnum,
  ];
  @override
  final String wireName = 'ContactEventResponseInputChannelEnum';

  @override
  Object serialize(
    Serializers serializers,
    ContactEventResponseInputChannelEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ContactEventResponseInputChannelEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ContactEventResponseInputChannelEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ContactEventResponseInput extends ContactEventResponseInput {
  @override
  final String contactEventId;
  @override
  final String providerId;
  @override
  final ContactEventResponseInputChannelEnum channel;
  @override
  final String phone;
  @override
  final String? whatsappMessage;
  @override
  final bool deduplicated;

  factory _$ContactEventResponseInput([
    void Function(ContactEventResponseInputBuilder)? updates,
  ]) => (ContactEventResponseInputBuilder()..update(updates))._build();

  _$ContactEventResponseInput._({
    required this.contactEventId,
    required this.providerId,
    required this.channel,
    required this.phone,
    this.whatsappMessage,
    required this.deduplicated,
  }) : super._();
  @override
  ContactEventResponseInput rebuild(
    void Function(ContactEventResponseInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ContactEventResponseInputBuilder toBuilder() =>
      ContactEventResponseInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactEventResponseInput &&
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
    return (newBuiltValueToStringHelper(r'ContactEventResponseInput')
          ..add('contactEventId', contactEventId)
          ..add('providerId', providerId)
          ..add('channel', channel)
          ..add('phone', phone)
          ..add('whatsappMessage', whatsappMessage)
          ..add('deduplicated', deduplicated))
        .toString();
  }
}

class ContactEventResponseInputBuilder
    implements
        Builder<ContactEventResponseInput, ContactEventResponseInputBuilder> {
  _$ContactEventResponseInput? _$v;

  String? _contactEventId;
  String? get contactEventId => _$this._contactEventId;
  set contactEventId(String? contactEventId) =>
      _$this._contactEventId = contactEventId;

  String? _providerId;
  String? get providerId => _$this._providerId;
  set providerId(String? providerId) => _$this._providerId = providerId;

  ContactEventResponseInputChannelEnum? _channel;
  ContactEventResponseInputChannelEnum? get channel => _$this._channel;
  set channel(ContactEventResponseInputChannelEnum? channel) =>
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

  ContactEventResponseInputBuilder() {
    ContactEventResponseInput._defaults(this);
  }

  ContactEventResponseInputBuilder get _$this {
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
  void replace(ContactEventResponseInput other) {
    _$v = other as _$ContactEventResponseInput;
  }

  @override
  void update(void Function(ContactEventResponseInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactEventResponseInput build() => _build();

  _$ContactEventResponseInput _build() {
    final _$result =
        _$v ??
        _$ContactEventResponseInput._(
          contactEventId: BuiltValueNullFieldError.checkNotNull(
            contactEventId,
            r'ContactEventResponseInput',
            'contactEventId',
          ),
          providerId: BuiltValueNullFieldError.checkNotNull(
            providerId,
            r'ContactEventResponseInput',
            'providerId',
          ),
          channel: BuiltValueNullFieldError.checkNotNull(
            channel,
            r'ContactEventResponseInput',
            'channel',
          ),
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'ContactEventResponseInput',
            'phone',
          ),
          whatsappMessage: whatsappMessage,
          deduplicated: BuiltValueNullFieldError.checkNotNull(
            deduplicated,
            r'ContactEventResponseInput',
            'deduplicated',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

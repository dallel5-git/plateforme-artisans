//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_event_response_input.g.dart';

/// ContactEventResponseInput
///
/// Properties:
/// * [contactEventId]
/// * [providerId]
/// * [channel]
/// * [phone]
/// * [whatsappMessage]
/// * [deduplicated]
@BuiltValue()
abstract class ContactEventResponseInput
    implements
        Built<ContactEventResponseInput, ContactEventResponseInputBuilder> {
  @BuiltValueField(wireName: r'contactEventId')
  String get contactEventId;

  @BuiltValueField(wireName: r'providerId')
  String get providerId;

  @BuiltValueField(wireName: r'channel')
  ContactEventResponseInputChannelEnum get channel;
  // enum channelEnum {  PHONE,  WHATSAPP,  };

  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'whatsappMessage')
  String? get whatsappMessage;

  @BuiltValueField(wireName: r'deduplicated')
  bool get deduplicated;

  ContactEventResponseInput._();

  factory ContactEventResponseInput(
          [void updates(ContactEventResponseInputBuilder b)]) =
      _$ContactEventResponseInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContactEventResponseInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContactEventResponseInput> get serializer =>
      _$ContactEventResponseInputSerializer();
}

class _$ContactEventResponseInputSerializer
    implements PrimitiveSerializer<ContactEventResponseInput> {
  @override
  final Iterable<Type> types = const [
    ContactEventResponseInput,
    _$ContactEventResponseInput
  ];

  @override
  final String wireName = r'ContactEventResponseInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContactEventResponseInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'contactEventId';
    yield serializers.serialize(
      object.contactEventId,
      specifiedType: const FullType(String),
    );
    yield r'providerId';
    yield serializers.serialize(
      object.providerId,
      specifiedType: const FullType(String),
    );
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(ContactEventResponseInputChannelEnum),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    if (object.whatsappMessage != null) {
      yield r'whatsappMessage';
      yield serializers.serialize(
        object.whatsappMessage,
        specifiedType: const FullType(String),
      );
    }
    yield r'deduplicated';
    yield serializers.serialize(
      object.deduplicated,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContactEventResponseInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContactEventResponseInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'contactEventId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contactEventId = valueDes;
          break;
        case r'providerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerId = valueDes;
          break;
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContactEventResponseInputChannelEnum),
          ) as ContactEventResponseInputChannelEnum;
          result.channel = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        case r'whatsappMessage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.whatsappMessage = valueDes;
          break;
        case r'deduplicated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.deduplicated = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContactEventResponseInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContactEventResponseInputBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class ContactEventResponseInputChannelEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'PHONE')
  static const ContactEventResponseInputChannelEnum PHONE =
      _$contactEventResponseInputChannelEnum_PHONE;
  @BuiltValueEnumConst(wireName: r'WHATSAPP')
  static const ContactEventResponseInputChannelEnum WHATSAPP =
      _$contactEventResponseInputChannelEnum_WHATSAPP;

  static Serializer<ContactEventResponseInputChannelEnum> get serializer =>
      _$contactEventResponseInputChannelEnumSerializer;

  const ContactEventResponseInputChannelEnum._(String name) : super(name);

  static BuiltSet<ContactEventResponseInputChannelEnum> get values =>
      _$contactEventResponseInputChannelEnumValues;
  static ContactEventResponseInputChannelEnum valueOf(String name) =>
      _$contactEventResponseInputChannelEnumValueOf(name);
}

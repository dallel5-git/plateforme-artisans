//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_contact_events_post200_response.g.dart';

/// V1ContactEventsPost200Response
///
/// Properties:
/// * [contactEventId]
/// * [providerId]
/// * [channel]
/// * [phone]
/// * [whatsappMessage]
/// * [deduplicated]
@BuiltValue()
abstract class V1ContactEventsPost200Response
    implements
        Built<V1ContactEventsPost200Response,
            V1ContactEventsPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'contactEventId')
  String get contactEventId;

  @BuiltValueField(wireName: r'providerId')
  String get providerId;

  @BuiltValueField(wireName: r'channel')
  V1ContactEventsPost200ResponseChannelEnum get channel;
  // enum channelEnum {  PHONE,  WHATSAPP,  };

  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'whatsappMessage')
  String? get whatsappMessage;

  @BuiltValueField(wireName: r'deduplicated')
  bool get deduplicated;

  V1ContactEventsPost200Response._();

  factory V1ContactEventsPost200Response(
          [void updates(V1ContactEventsPost200ResponseBuilder b)]) =
      _$V1ContactEventsPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ContactEventsPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ContactEventsPost200Response> get serializer =>
      _$V1ContactEventsPost200ResponseSerializer();
}

class _$V1ContactEventsPost200ResponseSerializer
    implements PrimitiveSerializer<V1ContactEventsPost200Response> {
  @override
  final Iterable<Type> types = const [
    V1ContactEventsPost200Response,
    _$V1ContactEventsPost200Response
  ];

  @override
  final String wireName = r'V1ContactEventsPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ContactEventsPost200Response object, {
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
      specifiedType: const FullType(V1ContactEventsPost200ResponseChannelEnum),
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
    V1ContactEventsPost200Response object, {
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
    required V1ContactEventsPost200ResponseBuilder result,
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
            specifiedType:
                const FullType(V1ContactEventsPost200ResponseChannelEnum),
          ) as V1ContactEventsPost200ResponseChannelEnum;
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
  V1ContactEventsPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ContactEventsPost200ResponseBuilder();
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

class V1ContactEventsPost200ResponseChannelEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'PHONE')
  static const V1ContactEventsPost200ResponseChannelEnum PHONE =
      _$v1ContactEventsPost200ResponseChannelEnum_PHONE;
  @BuiltValueEnumConst(wireName: r'WHATSAPP')
  static const V1ContactEventsPost200ResponseChannelEnum WHATSAPP =
      _$v1ContactEventsPost200ResponseChannelEnum_WHATSAPP;

  static Serializer<V1ContactEventsPost200ResponseChannelEnum> get serializer =>
      _$v1ContactEventsPost200ResponseChannelEnumSerializer;

  const V1ContactEventsPost200ResponseChannelEnum._(String name) : super(name);

  static BuiltSet<V1ContactEventsPost200ResponseChannelEnum> get values =>
      _$v1ContactEventsPost200ResponseChannelEnumValues;
  static V1ContactEventsPost200ResponseChannelEnum valueOf(String name) =>
      _$v1ContactEventsPost200ResponseChannelEnumValueOf(name);
}

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_stats_get200_response_totals_contacts_by_channel.g.dart';

/// V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel
///
/// Properties:
/// * [phone]
/// * [whatsapp]
@BuiltValue()
abstract class V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel
    implements
        Built<V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel,
            V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder> {
  @BuiltValueField(wireName: r'phone')
  int get phone;

  @BuiltValueField(wireName: r'whatsapp')
  int get whatsapp;

  V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel._();

  factory V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel(
      [void updates(
          V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder
              b)]) = _$V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel>
      get serializer =>
          _$V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelSerializer();
}

class _$V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel,
    _$V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel
  ];

  @override
  final String wireName =
      r'V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(int),
    );
    yield r'whatsapp';
    yield serializers.serialize(
      object.whatsapp,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel object, {
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
    required V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder
        result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.phone = valueDes;
          break;
        case r'whatsapp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.whatsapp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1ProvidersMeStatsGet200ResponseTotalsContactsByChannelBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_contact_events_post_request.g.dart';

/// V1ContactEventsPostRequest
///
/// Properties:
/// * [providerId]
/// * [channel]
/// * [categoryId]
/// * [sourceScreen]
@BuiltValue()
abstract class V1ContactEventsPostRequest
    implements
        Built<V1ContactEventsPostRequest, V1ContactEventsPostRequestBuilder> {
  @BuiltValueField(wireName: r'providerId')
  String get providerId;

  @BuiltValueField(wireName: r'channel')
  V1ContactEventsPostRequestChannelEnum get channel;
  // enum channelEnum {  PHONE,  WHATSAPP,  };

  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  @BuiltValueField(wireName: r'sourceScreen')
  V1ContactEventsPostRequestSourceScreenEnum? get sourceScreen;
  // enum sourceScreenEnum {  search,  profile,  boost,  ad,  seo_page,  };

  V1ContactEventsPostRequest._();

  factory V1ContactEventsPostRequest([
    void updates(V1ContactEventsPostRequestBuilder b),
  ]) = _$V1ContactEventsPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ContactEventsPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ContactEventsPostRequest> get serializer =>
      _$V1ContactEventsPostRequestSerializer();
}

class _$V1ContactEventsPostRequestSerializer
    implements PrimitiveSerializer<V1ContactEventsPostRequest> {
  @override
  final Iterable<Type> types = const [
    V1ContactEventsPostRequest,
    _$V1ContactEventsPostRequest,
  ];

  @override
  final String wireName = r'V1ContactEventsPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ContactEventsPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'providerId';
    yield serializers.serialize(
      object.providerId,
      specifiedType: const FullType(String),
    );
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(V1ContactEventsPostRequestChannelEnum),
    );
    if (object.categoryId != null) {
      yield r'categoryId';
      yield serializers.serialize(
        object.categoryId,
        specifiedType: const FullType(String),
      );
    }
    if (object.sourceScreen != null) {
      yield r'sourceScreen';
      yield serializers.serialize(
        object.sourceScreen,
        specifiedType: const FullType(
          V1ContactEventsPostRequestSourceScreenEnum,
        ),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ContactEventsPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required V1ContactEventsPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'providerId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.providerId = valueDes;
          break;
        case r'channel':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      V1ContactEventsPostRequestChannelEnum,
                    ),
                  )
                  as V1ContactEventsPostRequestChannelEnum;
          result.channel = valueDes;
          break;
        case r'categoryId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.categoryId = valueDes;
          break;
        case r'sourceScreen':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      V1ContactEventsPostRequestSourceScreenEnum,
                    ),
                  )
                  as V1ContactEventsPostRequestSourceScreenEnum;
          result.sourceScreen = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ContactEventsPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ContactEventsPostRequestBuilder();
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

class V1ContactEventsPostRequestChannelEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'PHONE')
  static const V1ContactEventsPostRequestChannelEnum PHONE =
      _$v1ContactEventsPostRequestChannelEnum_PHONE;
  @BuiltValueEnumConst(wireName: r'WHATSAPP')
  static const V1ContactEventsPostRequestChannelEnum WHATSAPP =
      _$v1ContactEventsPostRequestChannelEnum_WHATSAPP;

  static Serializer<V1ContactEventsPostRequestChannelEnum> get serializer =>
      _$v1ContactEventsPostRequestChannelEnumSerializer;

  const V1ContactEventsPostRequestChannelEnum._(String name) : super(name);

  static BuiltSet<V1ContactEventsPostRequestChannelEnum> get values =>
      _$v1ContactEventsPostRequestChannelEnumValues;
  static V1ContactEventsPostRequestChannelEnum valueOf(String name) =>
      _$v1ContactEventsPostRequestChannelEnumValueOf(name);
}

class V1ContactEventsPostRequestSourceScreenEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'search')
  static const V1ContactEventsPostRequestSourceScreenEnum search =
      _$v1ContactEventsPostRequestSourceScreenEnum_search;
  @BuiltValueEnumConst(wireName: r'profile')
  static const V1ContactEventsPostRequestSourceScreenEnum profile =
      _$v1ContactEventsPostRequestSourceScreenEnum_profile;
  @BuiltValueEnumConst(wireName: r'boost')
  static const V1ContactEventsPostRequestSourceScreenEnum boost =
      _$v1ContactEventsPostRequestSourceScreenEnum_boost;
  @BuiltValueEnumConst(wireName: r'ad')
  static const V1ContactEventsPostRequestSourceScreenEnum ad =
      _$v1ContactEventsPostRequestSourceScreenEnum_ad;
  @BuiltValueEnumConst(wireName: r'seo_page')
  static const V1ContactEventsPostRequestSourceScreenEnum seoPage =
      _$v1ContactEventsPostRequestSourceScreenEnum_seoPage;

  static Serializer<V1ContactEventsPostRequestSourceScreenEnum>
  get serializer => _$v1ContactEventsPostRequestSourceScreenEnumSerializer;

  const V1ContactEventsPostRequestSourceScreenEnum._(String name) : super(name);

  static BuiltSet<V1ContactEventsPostRequestSourceScreenEnum> get values =>
      _$v1ContactEventsPostRequestSourceScreenEnumValues;
  static V1ContactEventsPostRequestSourceScreenEnum valueOf(String name) =>
      _$v1ContactEventsPostRequestSourceScreenEnumValueOf(name);
}

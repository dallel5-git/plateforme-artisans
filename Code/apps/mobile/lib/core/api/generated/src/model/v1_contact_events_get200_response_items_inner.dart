//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_contact_events_get200_response_items_inner.g.dart';

/// V1ContactEventsGet200ResponseItemsInner
///
/// Properties:
/// * [id]
/// * [providerId]
/// * [slug]
/// * [businessName]
/// * [categoryName]
/// * [channel]
/// * [contactedAt]
/// * [hasReview]
@BuiltValue()
abstract class V1ContactEventsGet200ResponseItemsInner
    implements
        Built<V1ContactEventsGet200ResponseItemsInner,
            V1ContactEventsGet200ResponseItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'providerId')
  String get providerId;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'businessName')
  String get businessName;

  @BuiltValueField(wireName: r'categoryName')
  String get categoryName;

  @BuiltValueField(wireName: r'channel')
  V1ContactEventsGet200ResponseItemsInnerChannelEnum get channel;
  // enum channelEnum {  PHONE,  WHATSAPP,  };

  @BuiltValueField(wireName: r'contactedAt')
  DateTime get contactedAt;

  @BuiltValueField(wireName: r'hasReview')
  bool get hasReview;

  V1ContactEventsGet200ResponseItemsInner._();

  factory V1ContactEventsGet200ResponseItemsInner(
          [void updates(V1ContactEventsGet200ResponseItemsInnerBuilder b)]) =
      _$V1ContactEventsGet200ResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ContactEventsGet200ResponseItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ContactEventsGet200ResponseItemsInner> get serializer =>
      _$V1ContactEventsGet200ResponseItemsInnerSerializer();
}

class _$V1ContactEventsGet200ResponseItemsInnerSerializer
    implements PrimitiveSerializer<V1ContactEventsGet200ResponseItemsInner> {
  @override
  final Iterable<Type> types = const [
    V1ContactEventsGet200ResponseItemsInner,
    _$V1ContactEventsGet200ResponseItemsInner
  ];

  @override
  final String wireName = r'V1ContactEventsGet200ResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ContactEventsGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'providerId';
    yield serializers.serialize(
      object.providerId,
      specifiedType: const FullType(String),
    );
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
    yield r'businessName';
    yield serializers.serialize(
      object.businessName,
      specifiedType: const FullType(String),
    );
    yield r'categoryName';
    yield serializers.serialize(
      object.categoryName,
      specifiedType: const FullType(String),
    );
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType:
          const FullType(V1ContactEventsGet200ResponseItemsInnerChannelEnum),
    );
    yield r'contactedAt';
    yield serializers.serialize(
      object.contactedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'hasReview';
    yield serializers.serialize(
      object.hasReview,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ContactEventsGet200ResponseItemsInner object, {
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
    required V1ContactEventsGet200ResponseItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'providerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerId = valueDes;
          break;
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        case r'businessName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.businessName = valueDes;
          break;
        case r'categoryName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoryName = valueDes;
          break;
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1ContactEventsGet200ResponseItemsInnerChannelEnum),
          ) as V1ContactEventsGet200ResponseItemsInnerChannelEnum;
          result.channel = valueDes;
          break;
        case r'contactedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.contactedAt = valueDes;
          break;
        case r'hasReview':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasReview = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ContactEventsGet200ResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ContactEventsGet200ResponseItemsInnerBuilder();
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

class V1ContactEventsGet200ResponseItemsInnerChannelEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'PHONE')
  static const V1ContactEventsGet200ResponseItemsInnerChannelEnum PHONE =
      _$v1ContactEventsGet200ResponseItemsInnerChannelEnum_PHONE;
  @BuiltValueEnumConst(wireName: r'WHATSAPP')
  static const V1ContactEventsGet200ResponseItemsInnerChannelEnum WHATSAPP =
      _$v1ContactEventsGet200ResponseItemsInnerChannelEnum_WHATSAPP;

  static Serializer<V1ContactEventsGet200ResponseItemsInnerChannelEnum>
      get serializer =>
          _$v1ContactEventsGet200ResponseItemsInnerChannelEnumSerializer;

  const V1ContactEventsGet200ResponseItemsInnerChannelEnum._(String name)
      : super(name);

  static BuiltSet<V1ContactEventsGet200ResponseItemsInnerChannelEnum>
      get values => _$v1ContactEventsGet200ResponseItemsInnerChannelEnumValues;
  static V1ContactEventsGet200ResponseItemsInnerChannelEnum valueOf(
          String name) =>
      _$v1ContactEventsGet200ResponseItemsInnerChannelEnumValueOf(name);
}

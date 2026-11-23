//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_users_me_delete200_response.g.dart';

/// V1UsersMeDelete200Response
///
/// Properties:
/// * [success]
/// * [status]
/// * [message]
/// * [deletedAt]
@BuiltValue()
abstract class V1UsersMeDelete200Response
    implements
        Built<V1UsersMeDelete200Response, V1UsersMeDelete200ResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'status')
  V1UsersMeDelete200ResponseStatusEnum get status;
  // enum statusEnum {  DELETED,  };

  @BuiltValueField(wireName: r'message')
  String get message;

  @BuiltValueField(wireName: r'deletedAt')
  DateTime get deletedAt;

  V1UsersMeDelete200Response._();

  factory V1UsersMeDelete200Response(
          [void updates(V1UsersMeDelete200ResponseBuilder b)]) =
      _$V1UsersMeDelete200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1UsersMeDelete200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1UsersMeDelete200Response> get serializer =>
      _$V1UsersMeDelete200ResponseSerializer();
}

class _$V1UsersMeDelete200ResponseSerializer
    implements PrimitiveSerializer<V1UsersMeDelete200Response> {
  @override
  final Iterable<Type> types = const [
    V1UsersMeDelete200Response,
    _$V1UsersMeDelete200Response
  ];

  @override
  final String wireName = r'V1UsersMeDelete200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1UsersMeDelete200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'success';
    yield serializers.serialize(
      object.success,
      specifiedType: const FullType(bool),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(V1UsersMeDelete200ResponseStatusEnum),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'deletedAt';
    yield serializers.serialize(
      object.deletedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1UsersMeDelete200Response object, {
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
    required V1UsersMeDelete200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'success':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.success = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(V1UsersMeDelete200ResponseStatusEnum),
          ) as V1UsersMeDelete200ResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'deletedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.deletedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1UsersMeDelete200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1UsersMeDelete200ResponseBuilder();
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

class V1UsersMeDelete200ResponseStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'DELETED')
  static const V1UsersMeDelete200ResponseStatusEnum DELETED =
      _$v1UsersMeDelete200ResponseStatusEnum_DELETED;

  static Serializer<V1UsersMeDelete200ResponseStatusEnum> get serializer =>
      _$v1UsersMeDelete200ResponseStatusEnumSerializer;

  const V1UsersMeDelete200ResponseStatusEnum._(String name) : super(name);

  static BuiltSet<V1UsersMeDelete200ResponseStatusEnum> get values =>
      _$v1UsersMeDelete200ResponseStatusEnumValues;
  static V1UsersMeDelete200ResponseStatusEnum valueOf(String name) =>
      _$v1UsersMeDelete200ResponseStatusEnumValueOf(name);
}

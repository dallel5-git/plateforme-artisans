//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_health_get200_response.g.dart';

/// V1HealthGet200Response
///
/// Properties:
/// * [status]
/// * [db]
/// * [redis]
@BuiltValue()
abstract class V1HealthGet200Response
    implements Built<V1HealthGet200Response, V1HealthGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'status')
  V1HealthGet200ResponseStatusEnum get status;
  // enum statusEnum {  ok,  degraded,  };

  @BuiltValueField(wireName: r'db')
  V1HealthGet200ResponseDbEnum get db;
  // enum dbEnum {  up,  down,  };

  @BuiltValueField(wireName: r'redis')
  V1HealthGet200ResponseRedisEnum get redis;
  // enum redisEnum {  up,  down,  };

  V1HealthGet200Response._();

  factory V1HealthGet200Response(
          [void updates(V1HealthGet200ResponseBuilder b)]) =
      _$V1HealthGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1HealthGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1HealthGet200Response> get serializer =>
      _$V1HealthGet200ResponseSerializer();
}

class _$V1HealthGet200ResponseSerializer
    implements PrimitiveSerializer<V1HealthGet200Response> {
  @override
  final Iterable<Type> types = const [
    V1HealthGet200Response,
    _$V1HealthGet200Response
  ];

  @override
  final String wireName = r'V1HealthGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1HealthGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(V1HealthGet200ResponseStatusEnum),
    );
    yield r'db';
    yield serializers.serialize(
      object.db,
      specifiedType: const FullType(V1HealthGet200ResponseDbEnum),
    );
    yield r'redis';
    yield serializers.serialize(
      object.redis,
      specifiedType: const FullType(V1HealthGet200ResponseRedisEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1HealthGet200Response object, {
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
    required V1HealthGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(V1HealthGet200ResponseStatusEnum),
          ) as V1HealthGet200ResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'db':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(V1HealthGet200ResponseDbEnum),
          ) as V1HealthGet200ResponseDbEnum;
          result.db = valueDes;
          break;
        case r'redis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(V1HealthGet200ResponseRedisEnum),
          ) as V1HealthGet200ResponseRedisEnum;
          result.redis = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1HealthGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1HealthGet200ResponseBuilder();
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

class V1HealthGet200ResponseStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'ok')
  static const V1HealthGet200ResponseStatusEnum ok =
      _$v1HealthGet200ResponseStatusEnum_ok;
  @BuiltValueEnumConst(wireName: r'degraded')
  static const V1HealthGet200ResponseStatusEnum degraded =
      _$v1HealthGet200ResponseStatusEnum_degraded;

  static Serializer<V1HealthGet200ResponseStatusEnum> get serializer =>
      _$v1HealthGet200ResponseStatusEnumSerializer;

  const V1HealthGet200ResponseStatusEnum._(String name) : super(name);

  static BuiltSet<V1HealthGet200ResponseStatusEnum> get values =>
      _$v1HealthGet200ResponseStatusEnumValues;
  static V1HealthGet200ResponseStatusEnum valueOf(String name) =>
      _$v1HealthGet200ResponseStatusEnumValueOf(name);
}

class V1HealthGet200ResponseDbEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'up')
  static const V1HealthGet200ResponseDbEnum up =
      _$v1HealthGet200ResponseDbEnum_up;
  @BuiltValueEnumConst(wireName: r'down')
  static const V1HealthGet200ResponseDbEnum down =
      _$v1HealthGet200ResponseDbEnum_down;

  static Serializer<V1HealthGet200ResponseDbEnum> get serializer =>
      _$v1HealthGet200ResponseDbEnumSerializer;

  const V1HealthGet200ResponseDbEnum._(String name) : super(name);

  static BuiltSet<V1HealthGet200ResponseDbEnum> get values =>
      _$v1HealthGet200ResponseDbEnumValues;
  static V1HealthGet200ResponseDbEnum valueOf(String name) =>
      _$v1HealthGet200ResponseDbEnumValueOf(name);
}

class V1HealthGet200ResponseRedisEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'up')
  static const V1HealthGet200ResponseRedisEnum up =
      _$v1HealthGet200ResponseRedisEnum_up;
  @BuiltValueEnumConst(wireName: r'down')
  static const V1HealthGet200ResponseRedisEnum down =
      _$v1HealthGet200ResponseRedisEnum_down;

  static Serializer<V1HealthGet200ResponseRedisEnum> get serializer =>
      _$v1HealthGet200ResponseRedisEnumSerializer;

  const V1HealthGet200ResponseRedisEnum._(String name) : super(name);

  static BuiltSet<V1HealthGet200ResponseRedisEnum> get values =>
      _$v1HealthGet200ResponseRedisEnumValues;
  static V1HealthGet200ResponseRedisEnum valueOf(String name) =>
      _$v1HealthGet200ResponseRedisEnumValueOf(name);
}

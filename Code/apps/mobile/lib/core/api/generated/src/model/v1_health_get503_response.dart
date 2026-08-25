//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_health_get503_response.g.dart';

/// V1HealthGet503Response
///
/// Properties:
/// * [status]
/// * [db]
/// * [redis]
@BuiltValue()
abstract class V1HealthGet503Response
    implements Built<V1HealthGet503Response, V1HealthGet503ResponseBuilder> {
  @BuiltValueField(wireName: r'status')
  V1HealthGet503ResponseStatusEnum get status;
  // enum statusEnum {  ok,  degraded,  };

  @BuiltValueField(wireName: r'db')
  V1HealthGet503ResponseDbEnum get db;
  // enum dbEnum {  up,  down,  };

  @BuiltValueField(wireName: r'redis')
  V1HealthGet503ResponseRedisEnum get redis;
  // enum redisEnum {  up,  down,  };

  V1HealthGet503Response._();

  factory V1HealthGet503Response([
    void updates(V1HealthGet503ResponseBuilder b),
  ]) = _$V1HealthGet503Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1HealthGet503ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1HealthGet503Response> get serializer =>
      _$V1HealthGet503ResponseSerializer();
}

class _$V1HealthGet503ResponseSerializer
    implements PrimitiveSerializer<V1HealthGet503Response> {
  @override
  final Iterable<Type> types = const [
    V1HealthGet503Response,
    _$V1HealthGet503Response,
  ];

  @override
  final String wireName = r'V1HealthGet503Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1HealthGet503Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(V1HealthGet503ResponseStatusEnum),
    );
    yield r'db';
    yield serializers.serialize(
      object.db,
      specifiedType: const FullType(V1HealthGet503ResponseDbEnum),
    );
    yield r'redis';
    yield serializers.serialize(
      object.redis,
      specifiedType: const FullType(V1HealthGet503ResponseRedisEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1HealthGet503Response object, {
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
    required V1HealthGet503ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      V1HealthGet503ResponseStatusEnum,
                    ),
                  )
                  as V1HealthGet503ResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'db':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(V1HealthGet503ResponseDbEnum),
                  )
                  as V1HealthGet503ResponseDbEnum;
          result.db = valueDes;
          break;
        case r'redis':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      V1HealthGet503ResponseRedisEnum,
                    ),
                  )
                  as V1HealthGet503ResponseRedisEnum;
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
  V1HealthGet503Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1HealthGet503ResponseBuilder();
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

class V1HealthGet503ResponseStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'ok')
  static const V1HealthGet503ResponseStatusEnum ok =
      _$v1HealthGet503ResponseStatusEnum_ok;
  @BuiltValueEnumConst(wireName: r'degraded')
  static const V1HealthGet503ResponseStatusEnum degraded =
      _$v1HealthGet503ResponseStatusEnum_degraded;

  static Serializer<V1HealthGet503ResponseStatusEnum> get serializer =>
      _$v1HealthGet503ResponseStatusEnumSerializer;

  const V1HealthGet503ResponseStatusEnum._(String name) : super(name);

  static BuiltSet<V1HealthGet503ResponseStatusEnum> get values =>
      _$v1HealthGet503ResponseStatusEnumValues;
  static V1HealthGet503ResponseStatusEnum valueOf(String name) =>
      _$v1HealthGet503ResponseStatusEnumValueOf(name);
}

class V1HealthGet503ResponseDbEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'up')
  static const V1HealthGet503ResponseDbEnum up =
      _$v1HealthGet503ResponseDbEnum_up;
  @BuiltValueEnumConst(wireName: r'down')
  static const V1HealthGet503ResponseDbEnum down =
      _$v1HealthGet503ResponseDbEnum_down;

  static Serializer<V1HealthGet503ResponseDbEnum> get serializer =>
      _$v1HealthGet503ResponseDbEnumSerializer;

  const V1HealthGet503ResponseDbEnum._(String name) : super(name);

  static BuiltSet<V1HealthGet503ResponseDbEnum> get values =>
      _$v1HealthGet503ResponseDbEnumValues;
  static V1HealthGet503ResponseDbEnum valueOf(String name) =>
      _$v1HealthGet503ResponseDbEnumValueOf(name);
}

class V1HealthGet503ResponseRedisEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'up')
  static const V1HealthGet503ResponseRedisEnum up =
      _$v1HealthGet503ResponseRedisEnum_up;
  @BuiltValueEnumConst(wireName: r'down')
  static const V1HealthGet503ResponseRedisEnum down =
      _$v1HealthGet503ResponseRedisEnum_down;

  static Serializer<V1HealthGet503ResponseRedisEnum> get serializer =>
      _$v1HealthGet503ResponseRedisEnumSerializer;

  const V1HealthGet503ResponseRedisEnum._(String name) : super(name);

  static BuiltSet<V1HealthGet503ResponseRedisEnum> get values =>
      _$v1HealthGet503ResponseRedisEnumValues;
  static V1HealthGet503ResponseRedisEnum valueOf(String name) =>
      _$v1HealthGet503ResponseRedisEnumValueOf(name);
}

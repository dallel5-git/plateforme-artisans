//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_auth_logout_post200_response.g.dart';

/// V1AuthLogoutPost200Response
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class V1AuthLogoutPost200Response
    implements
        Built<V1AuthLogoutPost200Response, V1AuthLogoutPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'status')
  V1AuthLogoutPost200ResponseStatusEnum get status;
  // enum statusEnum {  ok,  };

  V1AuthLogoutPost200Response._();

  factory V1AuthLogoutPost200Response(
          [void updates(V1AuthLogoutPost200ResponseBuilder b)]) =
      _$V1AuthLogoutPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1AuthLogoutPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AuthLogoutPost200Response> get serializer =>
      _$V1AuthLogoutPost200ResponseSerializer();
}

class _$V1AuthLogoutPost200ResponseSerializer
    implements PrimitiveSerializer<V1AuthLogoutPost200Response> {
  @override
  final Iterable<Type> types = const [
    V1AuthLogoutPost200Response,
    _$V1AuthLogoutPost200Response
  ];

  @override
  final String wireName = r'V1AuthLogoutPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AuthLogoutPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(V1AuthLogoutPost200ResponseStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AuthLogoutPost200Response object, {
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
    required V1AuthLogoutPost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(V1AuthLogoutPost200ResponseStatusEnum),
          ) as V1AuthLogoutPost200ResponseStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1AuthLogoutPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1AuthLogoutPost200ResponseBuilder();
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

class V1AuthLogoutPost200ResponseStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'ok')
  static const V1AuthLogoutPost200ResponseStatusEnum ok =
      _$v1AuthLogoutPost200ResponseStatusEnum_ok;

  static Serializer<V1AuthLogoutPost200ResponseStatusEnum> get serializer =>
      _$v1AuthLogoutPost200ResponseStatusEnumSerializer;

  const V1AuthLogoutPost200ResponseStatusEnum._(String name) : super(name);

  static BuiltSet<V1AuthLogoutPost200ResponseStatusEnum> get values =>
      _$v1AuthLogoutPost200ResponseStatusEnumValues;
  static V1AuthLogoutPost200ResponseStatusEnum valueOf(String name) =>
      _$v1AuthLogoutPost200ResponseStatusEnumValueOf(name);
}

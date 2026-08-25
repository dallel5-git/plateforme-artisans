//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sanaya_api_client/src/model/v1_providers_me_post200_response_provider.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_post200_response.g.dart';

/// V1ProvidersMePost200Response
///
/// Properties:
/// * [accessToken]
/// * [refreshToken]
/// * [provider]
@BuiltValue()
abstract class V1ProvidersMePost200Response
    implements
        Built<V1ProvidersMePost200Response,
            V1ProvidersMePost200ResponseBuilder> {
  @BuiltValueField(wireName: r'accessToken')
  String get accessToken;

  @BuiltValueField(wireName: r'refreshToken')
  String get refreshToken;

  @BuiltValueField(wireName: r'provider')
  V1ProvidersMePost200ResponseProvider get provider;

  V1ProvidersMePost200Response._();

  factory V1ProvidersMePost200Response(
          [void updates(V1ProvidersMePost200ResponseBuilder b)]) =
      _$V1ProvidersMePost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMePost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMePost200Response> get serializer =>
      _$V1ProvidersMePost200ResponseSerializer();
}

class _$V1ProvidersMePost200ResponseSerializer
    implements PrimitiveSerializer<V1ProvidersMePost200Response> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMePost200Response,
    _$V1ProvidersMePost200Response
  ];

  @override
  final String wireName = r'V1ProvidersMePost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMePost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accessToken';
    yield serializers.serialize(
      object.accessToken,
      specifiedType: const FullType(String),
    );
    yield r'refreshToken';
    yield serializers.serialize(
      object.refreshToken,
      specifiedType: const FullType(String),
    );
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(V1ProvidersMePost200ResponseProvider),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMePost200Response object, {
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
    required V1ProvidersMePost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accessToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accessToken = valueDes;
          break;
        case r'refreshToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refreshToken = valueDes;
          break;
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(V1ProvidersMePost200ResponseProvider),
          ) as V1ProvidersMePost200ResponseProvider;
          result.provider = valueDes.toBuilder();
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMePost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMePost200ResponseBuilder();
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

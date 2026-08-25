//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_tokens_input.g.dart';

/// AuthTokensInput
///
/// Properties:
/// * [accessToken]
/// * [refreshToken]
@BuiltValue()
abstract class AuthTokensInput
    implements Built<AuthTokensInput, AuthTokensInputBuilder> {
  @BuiltValueField(wireName: r'accessToken')
  String get accessToken;

  @BuiltValueField(wireName: r'refreshToken')
  String get refreshToken;

  AuthTokensInput._();

  factory AuthTokensInput([void updates(AuthTokensInputBuilder b)]) =
      _$AuthTokensInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthTokensInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthTokensInput> get serializer =>
      _$AuthTokensInputSerializer();
}

class _$AuthTokensInputSerializer
    implements PrimitiveSerializer<AuthTokensInput> {
  @override
  final Iterable<Type> types = const [AuthTokensInput, _$AuthTokensInput];

  @override
  final String wireName = r'AuthTokensInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthTokensInput object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AuthTokensInput object, {
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
    required AuthTokensInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accessToken':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.accessToken = valueDes;
          break;
        case r'refreshToken':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.refreshToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuthTokensInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthTokensInputBuilder();
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

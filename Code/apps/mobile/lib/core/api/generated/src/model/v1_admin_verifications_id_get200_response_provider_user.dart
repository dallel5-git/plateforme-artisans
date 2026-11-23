//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_admin_verifications_id_get200_response_provider_user.g.dart';

/// V1AdminVerificationsIdGet200ResponseProviderUser
///
/// Properties:
/// * [id]
/// * [phone]
@BuiltValue()
abstract class V1AdminVerificationsIdGet200ResponseProviderUser
    implements
        Built<V1AdminVerificationsIdGet200ResponseProviderUser,
            V1AdminVerificationsIdGet200ResponseProviderUserBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'phone')
  String get phone;

  V1AdminVerificationsIdGet200ResponseProviderUser._();

  factory V1AdminVerificationsIdGet200ResponseProviderUser(
          [void updates(
              V1AdminVerificationsIdGet200ResponseProviderUserBuilder b)]) =
      _$V1AdminVerificationsIdGet200ResponseProviderUser;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1AdminVerificationsIdGet200ResponseProviderUserBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AdminVerificationsIdGet200ResponseProviderUser>
      get serializer =>
          _$V1AdminVerificationsIdGet200ResponseProviderUserSerializer();
}

class _$V1AdminVerificationsIdGet200ResponseProviderUserSerializer
    implements
        PrimitiveSerializer<V1AdminVerificationsIdGet200ResponseProviderUser> {
  @override
  final Iterable<Type> types = const [
    V1AdminVerificationsIdGet200ResponseProviderUser,
    _$V1AdminVerificationsIdGet200ResponseProviderUser
  ];

  @override
  final String wireName = r'V1AdminVerificationsIdGet200ResponseProviderUser';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AdminVerificationsIdGet200ResponseProviderUser object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AdminVerificationsIdGet200ResponseProviderUser object, {
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
    required V1AdminVerificationsIdGet200ResponseProviderUserBuilder result,
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
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1AdminVerificationsIdGet200ResponseProviderUser deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1AdminVerificationsIdGet200ResponseProviderUserBuilder();
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

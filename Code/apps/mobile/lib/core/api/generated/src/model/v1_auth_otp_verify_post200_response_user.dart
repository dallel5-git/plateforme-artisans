//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'shared_enums.dart';
import 'package:built_value/serializer.dart';

part 'v1_auth_otp_verify_post200_response_user.g.dart';

/// V1AuthOtpVerifyPost200ResponseUser
///
/// Properties:
/// * [id]
/// * [phone]
/// * [phoneVerifiedAt]
/// * [email]
/// * [emailVerifiedAt]
/// * [firstName]
/// * [lastName]
/// * [avatarMediaId]
/// * [roles]
/// * [status]
/// * [locale]
/// * [lastLoginAt]
/// * [marketingOptIn]
/// * [createdAt]
/// * [updatedAt]
@BuiltValue()
abstract class V1AuthOtpVerifyPost200ResponseUser
    implements
        Built<V1AuthOtpVerifyPost200ResponseUser,
            V1AuthOtpVerifyPost200ResponseUserBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'phoneVerifiedAt')
  DateTime get phoneVerifiedAt;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'emailVerifiedAt')
  DateTime get emailVerifiedAt;

  @BuiltValueField(wireName: r'firstName')
  String get firstName;

  @BuiltValueField(wireName: r'lastName')
  String get lastName;

  @BuiltValueField(wireName: r'avatarMediaId')
  String get avatarMediaId;

  @BuiltValueField(wireName: r'roles')
  BuiltList<V1AuthOtpVerifyPost200ResponseUserRolesEnum> get roles;
  // enum rolesEnum {  CLIENT,  PROVIDER,  MODERATOR,  SUPPORT,  SALES,  FINANCE,  ADMIN,  SUPER_ADMIN,  };

  @BuiltValueField(wireName: r'status')
  V1AuthOtpVerifyPost200ResponseUserStatusEnum get status;
  // enum statusEnum {  PENDING_VERIFICATION,  ACTIVE,  SUSPENDED,  DELETED,  };

  @BuiltValueField(wireName: r'locale')
  String get locale;

  @BuiltValueField(wireName: r'lastLoginAt')
  DateTime get lastLoginAt;

  @BuiltValueField(wireName: r'marketingOptIn')
  bool get marketingOptIn;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  V1AuthOtpVerifyPost200ResponseUser._();

  factory V1AuthOtpVerifyPost200ResponseUser(
          [void updates(V1AuthOtpVerifyPost200ResponseUserBuilder b)]) =
      _$V1AuthOtpVerifyPost200ResponseUser;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1AuthOtpVerifyPost200ResponseUserBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AuthOtpVerifyPost200ResponseUser> get serializer =>
      _$V1AuthOtpVerifyPost200ResponseUserSerializer();
}

class _$V1AuthOtpVerifyPost200ResponseUserSerializer
    implements PrimitiveSerializer<V1AuthOtpVerifyPost200ResponseUser> {
  @override
  final Iterable<Type> types = const [
    V1AuthOtpVerifyPost200ResponseUser,
    _$V1AuthOtpVerifyPost200ResponseUser
  ];

  @override
  final String wireName = r'V1AuthOtpVerifyPost200ResponseUser';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AuthOtpVerifyPost200ResponseUser object, {
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
    yield r'phoneVerifiedAt';
    yield serializers.serialize(
      object.phoneVerifiedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'emailVerifiedAt';
    yield serializers.serialize(
      object.emailVerifiedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'firstName';
    yield serializers.serialize(
      object.firstName,
      specifiedType: const FullType(String),
    );
    yield r'lastName';
    yield serializers.serialize(
      object.lastName,
      specifiedType: const FullType(String),
    );
    yield r'avatarMediaId';
    yield serializers.serialize(
      object.avatarMediaId,
      specifiedType: const FullType(String),
    );
    yield r'roles';
    yield serializers.serialize(
      object.roles,
      specifiedType: const FullType(
          BuiltList, [FullType(V1AuthOtpVerifyPost200ResponseUserRolesEnum)]),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType:
          const FullType(V1AuthOtpVerifyPost200ResponseUserStatusEnum),
    );
    yield r'locale';
    yield serializers.serialize(
      object.locale,
      specifiedType: const FullType(String),
    );
    yield r'lastLoginAt';
    yield serializers.serialize(
      object.lastLoginAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'marketingOptIn';
    yield serializers.serialize(
      object.marketingOptIn,
      specifiedType: const FullType(bool),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AuthOtpVerifyPost200ResponseUser object, {
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
    required V1AuthOtpVerifyPost200ResponseUserBuilder result,
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
        case r'phoneVerifiedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.phoneVerifiedAt = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'emailVerifiedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.emailVerifiedAt = valueDes;
          break;
        case r'firstName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstName = valueDes;
          break;
        case r'lastName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lastName = valueDes;
          break;
        case r'avatarMediaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.avatarMediaId = valueDes;
          break;
        case r'roles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(V1AuthOtpVerifyPost200ResponseUserRolesEnum)]),
          ) as BuiltList<V1AuthOtpVerifyPost200ResponseUserRolesEnum>;
          result.roles.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(V1AuthOtpVerifyPost200ResponseUserStatusEnum),
          ) as V1AuthOtpVerifyPost200ResponseUserStatusEnum;
          result.status = valueDes;
          break;
        case r'locale':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.locale = valueDes;
          break;
        case r'lastLoginAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.lastLoginAt = valueDes;
          break;
        case r'marketingOptIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.marketingOptIn = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1AuthOtpVerifyPost200ResponseUser deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1AuthOtpVerifyPost200ResponseUserBuilder();
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

class V1AuthOtpVerifyPost200ResponseUserStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'PENDING_VERIFICATION')
  static const V1AuthOtpVerifyPost200ResponseUserStatusEnum
      PENDING_VERIFICATION =
      _$v1AuthOtpVerifyPost200ResponseUserStatusEnum_PENDING_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const V1AuthOtpVerifyPost200ResponseUserStatusEnum ACTIVE =
      _$v1AuthOtpVerifyPost200ResponseUserStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const V1AuthOtpVerifyPost200ResponseUserStatusEnum SUSPENDED =
      _$v1AuthOtpVerifyPost200ResponseUserStatusEnum_SUSPENDED;
  @BuiltValueEnumConst(wireName: r'DELETED')
  static const V1AuthOtpVerifyPost200ResponseUserStatusEnum DELETED =
      _$v1AuthOtpVerifyPost200ResponseUserStatusEnum_DELETED;

  static Serializer<V1AuthOtpVerifyPost200ResponseUserStatusEnum>
      get serializer =>
          _$v1AuthOtpVerifyPost200ResponseUserStatusEnumSerializer;

  const V1AuthOtpVerifyPost200ResponseUserStatusEnum._(String name)
      : super(name);

  static BuiltSet<V1AuthOtpVerifyPost200ResponseUserStatusEnum> get values =>
      _$v1AuthOtpVerifyPost200ResponseUserStatusEnumValues;
  static V1AuthOtpVerifyPost200ResponseUserStatusEnum valueOf(String name) =>
      _$v1AuthOtpVerifyPost200ResponseUserStatusEnumValueOf(name);
}

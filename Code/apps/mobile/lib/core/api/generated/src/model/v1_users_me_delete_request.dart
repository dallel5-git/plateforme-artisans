//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_users_me_delete_request.g.dart';

/// V1UsersMeDeleteRequest
///
/// Properties:
/// * [confirmation]
/// * [reason]
@BuiltValue()
abstract class V1UsersMeDeleteRequest
    implements Built<V1UsersMeDeleteRequest, V1UsersMeDeleteRequestBuilder> {
  @BuiltValueField(wireName: r'confirmation')
  V1UsersMeDeleteRequestConfirmationEnum get confirmation;
  // enum confirmationEnum {  SUPPRIMER,  DELETE,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  V1UsersMeDeleteRequest._();

  factory V1UsersMeDeleteRequest(
          [void updates(V1UsersMeDeleteRequestBuilder b)]) =
      _$V1UsersMeDeleteRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1UsersMeDeleteRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1UsersMeDeleteRequest> get serializer =>
      _$V1UsersMeDeleteRequestSerializer();
}

class _$V1UsersMeDeleteRequestSerializer
    implements PrimitiveSerializer<V1UsersMeDeleteRequest> {
  @override
  final Iterable<Type> types = const [
    V1UsersMeDeleteRequest,
    _$V1UsersMeDeleteRequest
  ];

  @override
  final String wireName = r'V1UsersMeDeleteRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1UsersMeDeleteRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'confirmation';
    yield serializers.serialize(
      object.confirmation,
      specifiedType: const FullType(V1UsersMeDeleteRequestConfirmationEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    V1UsersMeDeleteRequest object, {
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
    required V1UsersMeDeleteRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'confirmation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(V1UsersMeDeleteRequestConfirmationEnum),
          ) as V1UsersMeDeleteRequestConfirmationEnum;
          result.confirmation = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1UsersMeDeleteRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1UsersMeDeleteRequestBuilder();
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

class V1UsersMeDeleteRequestConfirmationEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'SUPPRIMER')
  static const V1UsersMeDeleteRequestConfirmationEnum SUPPRIMER =
      _$v1UsersMeDeleteRequestConfirmationEnum_SUPPRIMER;
  @BuiltValueEnumConst(wireName: r'DELETE')
  static const V1UsersMeDeleteRequestConfirmationEnum DELETE =
      _$v1UsersMeDeleteRequestConfirmationEnum_DELETE;

  static Serializer<V1UsersMeDeleteRequestConfirmationEnum> get serializer =>
      _$v1UsersMeDeleteRequestConfirmationEnumSerializer;

  const V1UsersMeDeleteRequestConfirmationEnum._(String name) : super(name);

  static BuiltSet<V1UsersMeDeleteRequestConfirmationEnum> get values =>
      _$v1UsersMeDeleteRequestConfirmationEnumValues;
  static V1UsersMeDeleteRequestConfirmationEnum valueOf(String name) =>
      _$v1UsersMeDeleteRequestConfirmationEnumValueOf(name);
}

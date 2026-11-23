//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_admin_verifications_get200_response_items_inner_provider.g.dart';

/// V1AdminVerificationsGet200ResponseItemsInnerProvider
///
/// Properties:
/// * [id]
/// * [businessName]
/// * [slug]
/// * [baseGovernorateId]
/// * [isVerified]
@BuiltValue()
abstract class V1AdminVerificationsGet200ResponseItemsInnerProvider
    implements
        Built<V1AdminVerificationsGet200ResponseItemsInnerProvider,
            V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'businessName')
  String get businessName;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'baseGovernorateId')
  String get baseGovernorateId;

  @BuiltValueField(wireName: r'isVerified')
  bool get isVerified;

  V1AdminVerificationsGet200ResponseItemsInnerProvider._();

  factory V1AdminVerificationsGet200ResponseItemsInnerProvider(
          [void updates(
              V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder b)]) =
      _$V1AdminVerificationsGet200ResponseItemsInnerProvider;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AdminVerificationsGet200ResponseItemsInnerProvider>
      get serializer =>
          _$V1AdminVerificationsGet200ResponseItemsInnerProviderSerializer();
}

class _$V1AdminVerificationsGet200ResponseItemsInnerProviderSerializer
    implements
        PrimitiveSerializer<
            V1AdminVerificationsGet200ResponseItemsInnerProvider> {
  @override
  final Iterable<Type> types = const [
    V1AdminVerificationsGet200ResponseItemsInnerProvider,
    _$V1AdminVerificationsGet200ResponseItemsInnerProvider
  ];

  @override
  final String wireName =
      r'V1AdminVerificationsGet200ResponseItemsInnerProvider';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AdminVerificationsGet200ResponseItemsInnerProvider object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'businessName';
    yield serializers.serialize(
      object.businessName,
      specifiedType: const FullType(String),
    );
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
    yield r'baseGovernorateId';
    yield serializers.serialize(
      object.baseGovernorateId,
      specifiedType: const FullType(String),
    );
    yield r'isVerified';
    yield serializers.serialize(
      object.isVerified,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AdminVerificationsGet200ResponseItemsInnerProvider object, {
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
    required V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder result,
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
        case r'businessName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.businessName = valueDes;
          break;
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        case r'baseGovernorateId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.baseGovernorateId = valueDes;
          break;
        case r'isVerified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isVerified = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1AdminVerificationsGet200ResponseItemsInnerProvider deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder();
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

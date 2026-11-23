//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_verification_submit_post_request.g.dart';

/// V1ProvidersMeVerificationSubmitPostRequest
///
/// Properties:
/// * [cinNumber]
/// * [fullNameOnId]
/// * [cinFrontMediaId]
/// * [cinBackMediaId]
@BuiltValue()
abstract class V1ProvidersMeVerificationSubmitPostRequest
    implements
        Built<V1ProvidersMeVerificationSubmitPostRequest,
            V1ProvidersMeVerificationSubmitPostRequestBuilder> {
  @BuiltValueField(wireName: r'cinNumber')
  String get cinNumber;

  @BuiltValueField(wireName: r'fullNameOnId')
  String get fullNameOnId;

  @BuiltValueField(wireName: r'cinFrontMediaId')
  String get cinFrontMediaId;

  @BuiltValueField(wireName: r'cinBackMediaId')
  String get cinBackMediaId;

  V1ProvidersMeVerificationSubmitPostRequest._();

  factory V1ProvidersMeVerificationSubmitPostRequest(
          [void updates(V1ProvidersMeVerificationSubmitPostRequestBuilder b)]) =
      _$V1ProvidersMeVerificationSubmitPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMeVerificationSubmitPostRequestBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeVerificationSubmitPostRequest>
      get serializer =>
          _$V1ProvidersMeVerificationSubmitPostRequestSerializer();
}

class _$V1ProvidersMeVerificationSubmitPostRequestSerializer
    implements PrimitiveSerializer<V1ProvidersMeVerificationSubmitPostRequest> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeVerificationSubmitPostRequest,
    _$V1ProvidersMeVerificationSubmitPostRequest
  ];

  @override
  final String wireName = r'V1ProvidersMeVerificationSubmitPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeVerificationSubmitPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cinNumber';
    yield serializers.serialize(
      object.cinNumber,
      specifiedType: const FullType(String),
    );
    yield r'fullNameOnId';
    yield serializers.serialize(
      object.fullNameOnId,
      specifiedType: const FullType(String),
    );
    yield r'cinFrontMediaId';
    yield serializers.serialize(
      object.cinFrontMediaId,
      specifiedType: const FullType(String),
    );
    yield r'cinBackMediaId';
    yield serializers.serialize(
      object.cinBackMediaId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeVerificationSubmitPostRequest object, {
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
    required V1ProvidersMeVerificationSubmitPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cinNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cinNumber = valueDes;
          break;
        case r'fullNameOnId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullNameOnId = valueDes;
          break;
        case r'cinFrontMediaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cinFrontMediaId = valueDes;
          break;
        case r'cinBackMediaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cinBackMediaId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMeVerificationSubmitPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeVerificationSubmitPostRequestBuilder();
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

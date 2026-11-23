//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_admin_verifications_purge_expired_post200_response.g.dart';

/// V1AdminVerificationsPurgeExpiredPost200Response
///
/// Properties:
/// * [totalProcessed]
/// * [purgedCount]
/// * [skippedCount]
/// * [errorsCount]
@BuiltValue()
abstract class V1AdminVerificationsPurgeExpiredPost200Response
    implements
        Built<V1AdminVerificationsPurgeExpiredPost200Response,
            V1AdminVerificationsPurgeExpiredPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'totalProcessed')
  int get totalProcessed;

  @BuiltValueField(wireName: r'purgedCount')
  int get purgedCount;

  @BuiltValueField(wireName: r'skippedCount')
  int get skippedCount;

  @BuiltValueField(wireName: r'errorsCount')
  int get errorsCount;

  V1AdminVerificationsPurgeExpiredPost200Response._();

  factory V1AdminVerificationsPurgeExpiredPost200Response(
          [void updates(
              V1AdminVerificationsPurgeExpiredPost200ResponseBuilder b)]) =
      _$V1AdminVerificationsPurgeExpiredPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1AdminVerificationsPurgeExpiredPost200ResponseBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AdminVerificationsPurgeExpiredPost200Response>
      get serializer =>
          _$V1AdminVerificationsPurgeExpiredPost200ResponseSerializer();
}

class _$V1AdminVerificationsPurgeExpiredPost200ResponseSerializer
    implements
        PrimitiveSerializer<V1AdminVerificationsPurgeExpiredPost200Response> {
  @override
  final Iterable<Type> types = const [
    V1AdminVerificationsPurgeExpiredPost200Response,
    _$V1AdminVerificationsPurgeExpiredPost200Response
  ];

  @override
  final String wireName = r'V1AdminVerificationsPurgeExpiredPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AdminVerificationsPurgeExpiredPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'totalProcessed';
    yield serializers.serialize(
      object.totalProcessed,
      specifiedType: const FullType(int),
    );
    yield r'purgedCount';
    yield serializers.serialize(
      object.purgedCount,
      specifiedType: const FullType(int),
    );
    yield r'skippedCount';
    yield serializers.serialize(
      object.skippedCount,
      specifiedType: const FullType(int),
    );
    yield r'errorsCount';
    yield serializers.serialize(
      object.errorsCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AdminVerificationsPurgeExpiredPost200Response object, {
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
    required V1AdminVerificationsPurgeExpiredPost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'totalProcessed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalProcessed = valueDes;
          break;
        case r'purgedCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.purgedCount = valueDes;
          break;
        case r'skippedCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.skippedCount = valueDes;
          break;
        case r'errorsCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.errorsCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1AdminVerificationsPurgeExpiredPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1AdminVerificationsPurgeExpiredPost200ResponseBuilder();
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

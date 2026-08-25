//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_id_reviews_post_request.g.dart';

/// V1ProvidersIdReviewsPostRequest
///
/// Properties:
/// * [rating]
/// * [comment]
@BuiltValue()
abstract class V1ProvidersIdReviewsPostRequest
    implements
        Built<
          V1ProvidersIdReviewsPostRequest,
          V1ProvidersIdReviewsPostRequestBuilder
        > {
  @BuiltValueField(wireName: r'rating')
  int get rating;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  V1ProvidersIdReviewsPostRequest._();

  factory V1ProvidersIdReviewsPostRequest([
    void updates(V1ProvidersIdReviewsPostRequestBuilder b),
  ]) = _$V1ProvidersIdReviewsPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersIdReviewsPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersIdReviewsPostRequest> get serializer =>
      _$V1ProvidersIdReviewsPostRequestSerializer();
}

class _$V1ProvidersIdReviewsPostRequestSerializer
    implements PrimitiveSerializer<V1ProvidersIdReviewsPostRequest> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersIdReviewsPostRequest,
    _$V1ProvidersIdReviewsPostRequest,
  ];

  @override
  final String wireName = r'V1ProvidersIdReviewsPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersIdReviewsPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rating';
    yield serializers.serialize(
      object.rating,
      specifiedType: const FullType(int),
    );
    if (object.comment != null) {
      yield r'comment';
      yield serializers.serialize(
        object.comment,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersIdReviewsPostRequest object, {
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
    required V1ProvidersIdReviewsPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rating':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )
                  as int;
          result.rating = valueDes;
          break;
        case r'comment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.comment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersIdReviewsPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersIdReviewsPostRequestBuilder();
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

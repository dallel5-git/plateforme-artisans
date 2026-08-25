//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_id_reviews_post200_response.g.dart';

/// V1ProvidersIdReviewsPost200Response
///
/// Properties:
/// * [id]
/// * [rating]
/// * [comment]
/// * [isVerifiedContact]
/// * [createdAt]
@BuiltValue()
abstract class V1ProvidersIdReviewsPost200Response
    implements
        Built<V1ProvidersIdReviewsPost200Response,
            V1ProvidersIdReviewsPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'rating')
  int get rating;

  @BuiltValueField(wireName: r'comment')
  String get comment;

  @BuiltValueField(wireName: r'isVerifiedContact')
  bool get isVerifiedContact;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  V1ProvidersIdReviewsPost200Response._();

  factory V1ProvidersIdReviewsPost200Response(
          [void updates(V1ProvidersIdReviewsPost200ResponseBuilder b)]) =
      _$V1ProvidersIdReviewsPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersIdReviewsPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersIdReviewsPost200Response> get serializer =>
      _$V1ProvidersIdReviewsPost200ResponseSerializer();
}

class _$V1ProvidersIdReviewsPost200ResponseSerializer
    implements PrimitiveSerializer<V1ProvidersIdReviewsPost200Response> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersIdReviewsPost200Response,
    _$V1ProvidersIdReviewsPost200Response
  ];

  @override
  final String wireName = r'V1ProvidersIdReviewsPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersIdReviewsPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'rating';
    yield serializers.serialize(
      object.rating,
      specifiedType: const FullType(int),
    );
    yield r'comment';
    yield serializers.serialize(
      object.comment,
      specifiedType: const FullType(String),
    );
    yield r'isVerifiedContact';
    yield serializers.serialize(
      object.isVerifiedContact,
      specifiedType: const FullType(bool),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersIdReviewsPost200Response object, {
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
    required V1ProvidersIdReviewsPost200ResponseBuilder result,
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
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rating = valueDes;
          break;
        case r'comment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.comment = valueDes;
          break;
        case r'isVerifiedContact':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isVerifiedContact = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersIdReviewsPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersIdReviewsPost200ResponseBuilder();
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

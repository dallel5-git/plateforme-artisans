//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_slug_reviews_get200_response_items_inner.g.dart';

/// V1ProvidersSlugReviewsGet200ResponseItemsInner
///
/// Properties:
/// * [id]
/// * [rating]
/// * [comment]
/// * [isVerifiedContact]
/// * [createdAt]
/// * [authorDisplayName]
@BuiltValue()
abstract class V1ProvidersSlugReviewsGet200ResponseItemsInner
    implements
        Built<V1ProvidersSlugReviewsGet200ResponseItemsInner,
            V1ProvidersSlugReviewsGet200ResponseItemsInnerBuilder> {
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

  @BuiltValueField(wireName: r'authorDisplayName')
  String get authorDisplayName;

  V1ProvidersSlugReviewsGet200ResponseItemsInner._();

  factory V1ProvidersSlugReviewsGet200ResponseItemsInner(
          [void updates(
              V1ProvidersSlugReviewsGet200ResponseItemsInnerBuilder b)]) =
      _$V1ProvidersSlugReviewsGet200ResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1ProvidersSlugReviewsGet200ResponseItemsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersSlugReviewsGet200ResponseItemsInner>
      get serializer =>
          _$V1ProvidersSlugReviewsGet200ResponseItemsInnerSerializer();
}

class _$V1ProvidersSlugReviewsGet200ResponseItemsInnerSerializer
    implements
        PrimitiveSerializer<V1ProvidersSlugReviewsGet200ResponseItemsInner> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersSlugReviewsGet200ResponseItemsInner,
    _$V1ProvidersSlugReviewsGet200ResponseItemsInner
  ];

  @override
  final String wireName = r'V1ProvidersSlugReviewsGet200ResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersSlugReviewsGet200ResponseItemsInner object, {
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
    yield r'authorDisplayName';
    yield serializers.serialize(
      object.authorDisplayName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersSlugReviewsGet200ResponseItemsInner object, {
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
    required V1ProvidersSlugReviewsGet200ResponseItemsInnerBuilder result,
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
        case r'authorDisplayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.authorDisplayName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersSlugReviewsGet200ResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersSlugReviewsGet200ResponseItemsInnerBuilder();
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

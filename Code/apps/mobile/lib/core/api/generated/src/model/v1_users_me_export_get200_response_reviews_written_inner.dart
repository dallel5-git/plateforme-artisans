//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_users_me_export_get200_response_reviews_written_inner.g.dart';

/// V1UsersMeExportGet200ResponseReviewsWrittenInner
///
/// Properties:
/// * [id]
/// * [providerId]
/// * [providerBusinessName]
/// * [rating]
/// * [ratingPunctuality]
/// * [ratingQuality]
/// * [ratingValue]
/// * [comment]
/// * [status]
/// * [isVerifiedContact]
/// * [createdAt]
@BuiltValue()
abstract class V1UsersMeExportGet200ResponseReviewsWrittenInner
    implements
        Built<V1UsersMeExportGet200ResponseReviewsWrittenInner,
            V1UsersMeExportGet200ResponseReviewsWrittenInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'providerId')
  String get providerId;

  @BuiltValueField(wireName: r'providerBusinessName')
  String get providerBusinessName;

  @BuiltValueField(wireName: r'rating')
  int get rating;

  @BuiltValueField(wireName: r'ratingPunctuality')
  int get ratingPunctuality;

  @BuiltValueField(wireName: r'ratingQuality')
  int get ratingQuality;

  @BuiltValueField(wireName: r'ratingValue')
  int get ratingValue;

  @BuiltValueField(wireName: r'comment')
  String get comment;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'isVerifiedContact')
  bool get isVerifiedContact;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  V1UsersMeExportGet200ResponseReviewsWrittenInner._();

  factory V1UsersMeExportGet200ResponseReviewsWrittenInner(
          [void updates(
              V1UsersMeExportGet200ResponseReviewsWrittenInnerBuilder b)]) =
      _$V1UsersMeExportGet200ResponseReviewsWrittenInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1UsersMeExportGet200ResponseReviewsWrittenInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1UsersMeExportGet200ResponseReviewsWrittenInner>
      get serializer =>
          _$V1UsersMeExportGet200ResponseReviewsWrittenInnerSerializer();
}

class _$V1UsersMeExportGet200ResponseReviewsWrittenInnerSerializer
    implements
        PrimitiveSerializer<V1UsersMeExportGet200ResponseReviewsWrittenInner> {
  @override
  final Iterable<Type> types = const [
    V1UsersMeExportGet200ResponseReviewsWrittenInner,
    _$V1UsersMeExportGet200ResponseReviewsWrittenInner
  ];

  @override
  final String wireName = r'V1UsersMeExportGet200ResponseReviewsWrittenInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1UsersMeExportGet200ResponseReviewsWrittenInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'providerId';
    yield serializers.serialize(
      object.providerId,
      specifiedType: const FullType(String),
    );
    yield r'providerBusinessName';
    yield serializers.serialize(
      object.providerBusinessName,
      specifiedType: const FullType(String),
    );
    yield r'rating';
    yield serializers.serialize(
      object.rating,
      specifiedType: const FullType(int),
    );
    yield r'ratingPunctuality';
    yield serializers.serialize(
      object.ratingPunctuality,
      specifiedType: const FullType(int),
    );
    yield r'ratingQuality';
    yield serializers.serialize(
      object.ratingQuality,
      specifiedType: const FullType(int),
    );
    yield r'ratingValue';
    yield serializers.serialize(
      object.ratingValue,
      specifiedType: const FullType(int),
    );
    yield r'comment';
    yield serializers.serialize(
      object.comment,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
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
    V1UsersMeExportGet200ResponseReviewsWrittenInner object, {
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
    required V1UsersMeExportGet200ResponseReviewsWrittenInnerBuilder result,
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
        case r'providerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerId = valueDes;
          break;
        case r'providerBusinessName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerBusinessName = valueDes;
          break;
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rating = valueDes;
          break;
        case r'ratingPunctuality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ratingPunctuality = valueDes;
          break;
        case r'ratingQuality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ratingQuality = valueDes;
          break;
        case r'ratingValue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ratingValue = valueDes;
          break;
        case r'comment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.comment = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
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
  V1UsersMeExportGet200ResponseReviewsWrittenInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1UsersMeExportGet200ResponseReviewsWrittenInnerBuilder();
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

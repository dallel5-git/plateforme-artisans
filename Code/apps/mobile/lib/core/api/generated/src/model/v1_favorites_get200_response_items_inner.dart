//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_favorites_get200_response_items_inner.g.dart';

/// V1FavoritesGet200ResponseItemsInner
///
/// Properties:
/// * [providerId]
/// * [slug]
/// * [businessName]
/// * [headline]
/// * [isVerified]
/// * [ratingAvg]
/// * [ratingCount]
/// * [availabilityStatus]
/// * [favoritedAt]
@BuiltValue()
abstract class V1FavoritesGet200ResponseItemsInner
    implements
        Built<V1FavoritesGet200ResponseItemsInner,
            V1FavoritesGet200ResponseItemsInnerBuilder> {
  @BuiltValueField(wireName: r'providerId')
  String get providerId;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'businessName')
  String get businessName;

  @BuiltValueField(wireName: r'headline')
  String get headline;

  @BuiltValueField(wireName: r'isVerified')
  bool get isVerified;

  @BuiltValueField(wireName: r'ratingAvg')
  num get ratingAvg;

  @BuiltValueField(wireName: r'ratingCount')
  num get ratingCount;

  @BuiltValueField(wireName: r'availabilityStatus')
  V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum
      get availabilityStatus;
  // enum availabilityStatusEnum {  AVAILABLE,  BUSY,  ON_HOLIDAY,  };

  @BuiltValueField(wireName: r'favoritedAt')
  DateTime get favoritedAt;

  V1FavoritesGet200ResponseItemsInner._();

  factory V1FavoritesGet200ResponseItemsInner(
          [void updates(V1FavoritesGet200ResponseItemsInnerBuilder b)]) =
      _$V1FavoritesGet200ResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1FavoritesGet200ResponseItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1FavoritesGet200ResponseItemsInner> get serializer =>
      _$V1FavoritesGet200ResponseItemsInnerSerializer();
}

class _$V1FavoritesGet200ResponseItemsInnerSerializer
    implements PrimitiveSerializer<V1FavoritesGet200ResponseItemsInner> {
  @override
  final Iterable<Type> types = const [
    V1FavoritesGet200ResponseItemsInner,
    _$V1FavoritesGet200ResponseItemsInner
  ];

  @override
  final String wireName = r'V1FavoritesGet200ResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1FavoritesGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'providerId';
    yield serializers.serialize(
      object.providerId,
      specifiedType: const FullType(String),
    );
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
    yield r'businessName';
    yield serializers.serialize(
      object.businessName,
      specifiedType: const FullType(String),
    );
    yield r'headline';
    yield serializers.serialize(
      object.headline,
      specifiedType: const FullType(String),
    );
    yield r'isVerified';
    yield serializers.serialize(
      object.isVerified,
      specifiedType: const FullType(bool),
    );
    yield r'ratingAvg';
    yield serializers.serialize(
      object.ratingAvg,
      specifiedType: const FullType(num),
    );
    yield r'ratingCount';
    yield serializers.serialize(
      object.ratingCount,
      specifiedType: const FullType(num),
    );
    yield r'availabilityStatus';
    yield serializers.serialize(
      object.availabilityStatus,
      specifiedType: const FullType(
          V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum),
    );
    yield r'favoritedAt';
    yield serializers.serialize(
      object.favoritedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1FavoritesGet200ResponseItemsInner object, {
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
    required V1FavoritesGet200ResponseItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'providerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerId = valueDes;
          break;
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        case r'businessName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.businessName = valueDes;
          break;
        case r'headline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.headline = valueDes;
          break;
        case r'isVerified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isVerified = valueDes;
          break;
        case r'ratingAvg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.ratingAvg = valueDes;
          break;
        case r'ratingCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.ratingCount = valueDes;
          break;
        case r'availabilityStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum),
          ) as V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum;
          result.availabilityStatus = valueDes;
          break;
        case r'favoritedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.favoritedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1FavoritesGet200ResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1FavoritesGet200ResponseItemsInnerBuilder();
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

class V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'AVAILABLE')
  static const V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum
      AVAILABLE =
      _$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'BUSY')
  static const V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum BUSY =
      _$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum_BUSY;
  @BuiltValueEnumConst(wireName: r'ON_HOLIDAY')
  static const V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum
      ON_HOLIDAY =
      _$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum_ON_HOLIDAY;

  static Serializer<V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum>
      get serializer =>
          _$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnumSerializer;

  const V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum._(String name)
      : super(name);

  static BuiltSet<V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum>
      get values =>
          _$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnumValues;
  static V1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnum valueOf(
          String name) =>
      _$v1FavoritesGet200ResponseItemsInnerAvailabilityStatusEnumValueOf(name);
}

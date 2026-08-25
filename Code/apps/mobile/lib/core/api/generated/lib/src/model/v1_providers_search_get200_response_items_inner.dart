//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sanaya_api_client/src/model/v1_providers_search_get200_response_items_inner_categories_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:sanaya_api_client/src/model/v1_providers_search_get200_response_items_inner_match_reason.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_search_get200_response_items_inner.g.dart';

/// V1ProvidersSearchGet200ResponseItemsInner
///
/// Properties:
/// * [id]
/// * [slug]
/// * [businessName]
/// * [headline]
/// * [isVerified]
/// * [ratingAvg]
/// * [ratingCount]
/// * [completionScore]
/// * [availabilityStatus]
/// * [categories]
/// * [score]
/// * [matchReason]
@BuiltValue()
abstract class V1ProvidersSearchGet200ResponseItemsInner
    implements
        Built<V1ProvidersSearchGet200ResponseItemsInner,
            V1ProvidersSearchGet200ResponseItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

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
  int get ratingCount;

  @BuiltValueField(wireName: r'completionScore')
  int get completionScore;

  @BuiltValueField(wireName: r'availabilityStatus')
  V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum
      get availabilityStatus;
  // enum availabilityStatusEnum {  AVAILABLE,  BUSY,  ON_HOLIDAY,  };

  @BuiltValueField(wireName: r'categories')
  BuiltList<V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner>
      get categories;

  @BuiltValueField(wireName: r'score')
  num? get score;

  @BuiltValueField(wireName: r'matchReason')
  V1ProvidersSearchGet200ResponseItemsInnerMatchReason? get matchReason;

  V1ProvidersSearchGet200ResponseItemsInner._();

  factory V1ProvidersSearchGet200ResponseItemsInner(
          [void updates(V1ProvidersSearchGet200ResponseItemsInnerBuilder b)]) =
      _$V1ProvidersSearchGet200ResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersSearchGet200ResponseItemsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersSearchGet200ResponseItemsInner> get serializer =>
      _$V1ProvidersSearchGet200ResponseItemsInnerSerializer();
}

class _$V1ProvidersSearchGet200ResponseItemsInnerSerializer
    implements PrimitiveSerializer<V1ProvidersSearchGet200ResponseItemsInner> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersSearchGet200ResponseItemsInner,
    _$V1ProvidersSearchGet200ResponseItemsInner
  ];

  @override
  final String wireName = r'V1ProvidersSearchGet200ResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersSearchGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
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
      specifiedType: const FullType(int),
    );
    yield r'completionScore';
    yield serializers.serialize(
      object.completionScore,
      specifiedType: const FullType(int),
    );
    yield r'availabilityStatus';
    yield serializers.serialize(
      object.availabilityStatus,
      specifiedType: const FullType(
          V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum),
    );
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList,
          [FullType(V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner)]),
    );
    if (object.score != null) {
      yield r'score';
      yield serializers.serialize(
        object.score,
        specifiedType: const FullType(num),
      );
    }
    if (object.matchReason != null) {
      yield r'matchReason';
      yield serializers.serialize(
        object.matchReason,
        specifiedType: const FullType(
            V1ProvidersSearchGet200ResponseItemsInnerMatchReason),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersSearchGet200ResponseItemsInner object, {
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
    required V1ProvidersSearchGet200ResponseItemsInnerBuilder result,
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
            specifiedType: const FullType(int),
          ) as int;
          result.ratingCount = valueDes;
          break;
        case r'completionScore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.completionScore = valueDes;
          break;
        case r'availabilityStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum),
          ) as V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum;
          result.availabilityStatus = valueDes;
          break;
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType(V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner)
            ]),
          ) as BuiltList<
              V1ProvidersSearchGet200ResponseItemsInnerCategoriesInner>;
          result.categories.replace(valueDes);
          break;
        case r'score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.score = valueDes;
          break;
        case r'matchReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1ProvidersSearchGet200ResponseItemsInnerMatchReason),
          ) as V1ProvidersSearchGet200ResponseItemsInnerMatchReason;
          result.matchReason = valueDes.toBuilder();
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersSearchGet200ResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersSearchGet200ResponseItemsInnerBuilder();
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

class V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'AVAILABLE')
  static const V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum
      AVAILABLE =
      _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'BUSY')
  static const V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum
      BUSY =
      _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum_BUSY;
  @BuiltValueEnumConst(wireName: r'ON_HOLIDAY')
  static const V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum
      ON_HOLIDAY =
      _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum_ON_HOLIDAY;

  static Serializer<
          V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum>
      get serializer =>
          _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnumSerializer;

  const V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum._(
      String name)
      : super(name);

  static BuiltSet<
          V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum>
      get values =>
          _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnumValues;
  static V1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnum valueOf(
          String name) =>
      _$v1ProvidersSearchGet200ResponseItemsInnerAvailabilityStatusEnumValueOf(
          name);
}

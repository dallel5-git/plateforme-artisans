//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_get200_response_offerings_inner_category.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_slug_get200_response_offerings_inner.g.dart';

/// V1ProvidersSlugGet200ResponseOfferingsInner
///
/// Properties:
/// * [id]
/// * [category]
/// * [titleFr]
/// * [titleAr]
/// * [description]
/// * [priceMin]
/// * [priceMax]
/// * [priceUnit]
/// * [isNegotiable]
/// * [displayPrice]
@BuiltValue()
abstract class V1ProvidersSlugGet200ResponseOfferingsInner
    implements
        Built<V1ProvidersSlugGet200ResponseOfferingsInner,
            V1ProvidersSlugGet200ResponseOfferingsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'category')
  V1ProvidersSlugGet200ResponseOfferingsInnerCategory get category;

  @BuiltValueField(wireName: r'titleFr')
  String get titleFr;

  @BuiltValueField(wireName: r'titleAr')
  String get titleAr;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'priceMin')
  num get priceMin;

  @BuiltValueField(wireName: r'priceMax')
  num get priceMax;

  @BuiltValueField(wireName: r'priceUnit')
  V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum get priceUnit;
  // enum priceUnitEnum {  FIXED,  HOUR,  DAY,  SQUARE_METER,  LINEAR_METER,  ON_QUOTE,  };

  @BuiltValueField(wireName: r'isNegotiable')
  bool get isNegotiable;

  @BuiltValueField(wireName: r'displayPrice')
  String get displayPrice;

  V1ProvidersSlugGet200ResponseOfferingsInner._();

  factory V1ProvidersSlugGet200ResponseOfferingsInner(
          [void updates(
              V1ProvidersSlugGet200ResponseOfferingsInnerBuilder b)]) =
      _$V1ProvidersSlugGet200ResponseOfferingsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersSlugGet200ResponseOfferingsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersSlugGet200ResponseOfferingsInner>
      get serializer =>
          _$V1ProvidersSlugGet200ResponseOfferingsInnerSerializer();
}

class _$V1ProvidersSlugGet200ResponseOfferingsInnerSerializer
    implements
        PrimitiveSerializer<V1ProvidersSlugGet200ResponseOfferingsInner> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersSlugGet200ResponseOfferingsInner,
    _$V1ProvidersSlugGet200ResponseOfferingsInner
  ];

  @override
  final String wireName = r'V1ProvidersSlugGet200ResponseOfferingsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersSlugGet200ResponseOfferingsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType:
          const FullType(V1ProvidersSlugGet200ResponseOfferingsInnerCategory),
    );
    yield r'titleFr';
    yield serializers.serialize(
      object.titleFr,
      specifiedType: const FullType(String),
    );
    yield r'titleAr';
    yield serializers.serialize(
      object.titleAr,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'priceMin';
    yield serializers.serialize(
      object.priceMin,
      specifiedType: const FullType(num),
    );
    yield r'priceMax';
    yield serializers.serialize(
      object.priceMax,
      specifiedType: const FullType(num),
    );
    yield r'priceUnit';
    yield serializers.serialize(
      object.priceUnit,
      specifiedType: const FullType(
          V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum),
    );
    yield r'isNegotiable';
    yield serializers.serialize(
      object.isNegotiable,
      specifiedType: const FullType(bool),
    );
    yield r'displayPrice';
    yield serializers.serialize(
      object.displayPrice,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersSlugGet200ResponseOfferingsInner object, {
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
    required V1ProvidersSlugGet200ResponseOfferingsInnerBuilder result,
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
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1ProvidersSlugGet200ResponseOfferingsInnerCategory),
          ) as V1ProvidersSlugGet200ResponseOfferingsInnerCategory;
          result.category.replace(valueDes);
          break;
        case r'titleFr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.titleFr = valueDes;
          break;
        case r'titleAr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.titleAr = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'priceMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.priceMin = valueDes;
          break;
        case r'priceMax':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.priceMax = valueDes;
          break;
        case r'priceUnit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum),
          ) as V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum;
          result.priceUnit = valueDes;
          break;
        case r'isNegotiable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isNegotiable = valueDes;
          break;
        case r'displayPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayPrice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersSlugGet200ResponseOfferingsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersSlugGet200ResponseOfferingsInnerBuilder();
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

class V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'FIXED')
  static const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum FIXED =
      _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_FIXED;
  @BuiltValueEnumConst(wireName: r'HOUR')
  static const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum HOUR =
      _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_HOUR;
  @BuiltValueEnumConst(wireName: r'DAY')
  static const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum DAY =
      _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_DAY;
  @BuiltValueEnumConst(wireName: r'SQUARE_METER')
  static const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum
      SQUARE_METER =
      _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_SQUARE_METER;
  @BuiltValueEnumConst(wireName: r'LINEAR_METER')
  static const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum
      LINEAR_METER =
      _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_LINEAR_METER;
  @BuiltValueEnumConst(wireName: r'ON_QUOTE')
  static const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum
      ON_QUOTE =
      _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum_ON_QUOTE;

  static Serializer<V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum>
      get serializer =>
          _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnumSerializer;

  const V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum._(String name)
      : super(name);

  static BuiltSet<V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum>
      get values =>
          _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnumValues;
  static V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum valueOf(
          String name) =>
      _$v1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnumValueOf(name);
}

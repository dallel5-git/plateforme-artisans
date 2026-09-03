//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_slug_get200_response_offerings_inner_category.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_offerings_post200_response.g.dart';

/// V1ProvidersMeOfferingsPost200Response
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
abstract class V1ProvidersMeOfferingsPost200Response
    implements
        Built<V1ProvidersMeOfferingsPost200Response,
            V1ProvidersMeOfferingsPost200ResponseBuilder> {
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
  V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum get priceUnit;
  // enum priceUnitEnum {  FIXED,  HOUR,  DAY,  SQUARE_METER,  LINEAR_METER,  ON_QUOTE,  };

  @BuiltValueField(wireName: r'isNegotiable')
  bool get isNegotiable;

  @BuiltValueField(wireName: r'displayPrice')
  String get displayPrice;

  V1ProvidersMeOfferingsPost200Response._();

  factory V1ProvidersMeOfferingsPost200Response(
          [void updates(V1ProvidersMeOfferingsPost200ResponseBuilder b)]) =
      _$V1ProvidersMeOfferingsPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMeOfferingsPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeOfferingsPost200Response> get serializer =>
      _$V1ProvidersMeOfferingsPost200ResponseSerializer();
}

class _$V1ProvidersMeOfferingsPost200ResponseSerializer
    implements PrimitiveSerializer<V1ProvidersMeOfferingsPost200Response> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeOfferingsPost200Response,
    _$V1ProvidersMeOfferingsPost200Response
  ];

  @override
  final String wireName = r'V1ProvidersMeOfferingsPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeOfferingsPost200Response object, {
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
      specifiedType:
          const FullType(V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum),
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
    V1ProvidersMeOfferingsPost200Response object, {
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
    required V1ProvidersMeOfferingsPost200ResponseBuilder result,
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
                V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum),
          ) as V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum;
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
  V1ProvidersMeOfferingsPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeOfferingsPost200ResponseBuilder();
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

class V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'FIXED')
  static const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum FIXED =
      _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_FIXED;
  @BuiltValueEnumConst(wireName: r'HOUR')
  static const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum HOUR =
      _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_HOUR;
  @BuiltValueEnumConst(wireName: r'DAY')
  static const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum DAY =
      _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_DAY;
  @BuiltValueEnumConst(wireName: r'SQUARE_METER')
  static const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum SQUARE_METER =
      _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_SQUARE_METER;
  @BuiltValueEnumConst(wireName: r'LINEAR_METER')
  static const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum LINEAR_METER =
      _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_LINEAR_METER;
  @BuiltValueEnumConst(wireName: r'ON_QUOTE')
  static const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum ON_QUOTE =
      _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnum_ON_QUOTE;

  static Serializer<V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum>
      get serializer =>
          _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnumSerializer;

  const V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum._(String name)
      : super(name);

  static BuiltSet<V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum>
      get values => _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnumValues;
  static V1ProvidersMeOfferingsPost200ResponsePriceUnitEnum valueOf(
          String name) =>
      _$v1ProvidersMeOfferingsPost200ResponsePriceUnitEnumValueOf(name);
}

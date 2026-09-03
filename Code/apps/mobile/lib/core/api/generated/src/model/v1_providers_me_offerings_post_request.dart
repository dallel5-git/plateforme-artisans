//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_offerings_post_request.g.dart';

/// V1ProvidersMeOfferingsPostRequest
///
/// Properties:
/// * [categoryId]
/// * [titleFr]
/// * [titleAr]
/// * [description]
/// * [priceMin]
/// * [priceMax]
/// * [priceUnit]
/// * [isNegotiable]
@BuiltValue()
abstract class V1ProvidersMeOfferingsPostRequest
    implements
        Built<V1ProvidersMeOfferingsPostRequest,
            V1ProvidersMeOfferingsPostRequestBuilder> {
  @BuiltValueField(wireName: r'categoryId')
  String get categoryId;

  @BuiltValueField(wireName: r'titleFr')
  String get titleFr;

  @BuiltValueField(wireName: r'titleAr')
  String? get titleAr;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'priceMin')
  num? get priceMin;

  @BuiltValueField(wireName: r'priceMax')
  num? get priceMax;

  @BuiltValueField(wireName: r'priceUnit')
  V1ProvidersMeOfferingsPostRequestPriceUnitEnum? get priceUnit;
  // enum priceUnitEnum {  FIXED,  HOUR,  DAY,  SQUARE_METER,  LINEAR_METER,  ON_QUOTE,  };

  @BuiltValueField(wireName: r'isNegotiable')
  bool? get isNegotiable;

  V1ProvidersMeOfferingsPostRequest._();

  factory V1ProvidersMeOfferingsPostRequest(
          [void updates(V1ProvidersMeOfferingsPostRequestBuilder b)]) =
      _$V1ProvidersMeOfferingsPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMeOfferingsPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeOfferingsPostRequest> get serializer =>
      _$V1ProvidersMeOfferingsPostRequestSerializer();
}

class _$V1ProvidersMeOfferingsPostRequestSerializer
    implements PrimitiveSerializer<V1ProvidersMeOfferingsPostRequest> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeOfferingsPostRequest,
    _$V1ProvidersMeOfferingsPostRequest
  ];

  @override
  final String wireName = r'V1ProvidersMeOfferingsPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeOfferingsPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categoryId';
    yield serializers.serialize(
      object.categoryId,
      specifiedType: const FullType(String),
    );
    yield r'titleFr';
    yield serializers.serialize(
      object.titleFr,
      specifiedType: const FullType(String),
    );
    if (object.titleAr != null) {
      yield r'titleAr';
      yield serializers.serialize(
        object.titleAr,
        specifiedType: const FullType(String),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.priceMin != null) {
      yield r'priceMin';
      yield serializers.serialize(
        object.priceMin,
        specifiedType: const FullType(num),
      );
    }
    if (object.priceMax != null) {
      yield r'priceMax';
      yield serializers.serialize(
        object.priceMax,
        specifiedType: const FullType(num),
      );
    }
    if (object.priceUnit != null) {
      yield r'priceUnit';
      yield serializers.serialize(
        object.priceUnit,
        specifiedType:
            const FullType(V1ProvidersMeOfferingsPostRequestPriceUnitEnum),
      );
    }
    if (object.isNegotiable != null) {
      yield r'isNegotiable';
      yield serializers.serialize(
        object.isNegotiable,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeOfferingsPostRequest object, {
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
    required V1ProvidersMeOfferingsPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categoryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoryId = valueDes;
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
            specifiedType:
                const FullType(V1ProvidersMeOfferingsPostRequestPriceUnitEnum),
          ) as V1ProvidersMeOfferingsPostRequestPriceUnitEnum;
          result.priceUnit = valueDes;
          break;
        case r'isNegotiable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isNegotiable = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMeOfferingsPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeOfferingsPostRequestBuilder();
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

class V1ProvidersMeOfferingsPostRequestPriceUnitEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'FIXED')
  static const V1ProvidersMeOfferingsPostRequestPriceUnitEnum FIXED =
      _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_FIXED;
  @BuiltValueEnumConst(wireName: r'HOUR')
  static const V1ProvidersMeOfferingsPostRequestPriceUnitEnum HOUR =
      _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_HOUR;
  @BuiltValueEnumConst(wireName: r'DAY')
  static const V1ProvidersMeOfferingsPostRequestPriceUnitEnum DAY =
      _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_DAY;
  @BuiltValueEnumConst(wireName: r'SQUARE_METER')
  static const V1ProvidersMeOfferingsPostRequestPriceUnitEnum SQUARE_METER =
      _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_SQUARE_METER;
  @BuiltValueEnumConst(wireName: r'LINEAR_METER')
  static const V1ProvidersMeOfferingsPostRequestPriceUnitEnum LINEAR_METER =
      _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_LINEAR_METER;
  @BuiltValueEnumConst(wireName: r'ON_QUOTE')
  static const V1ProvidersMeOfferingsPostRequestPriceUnitEnum ON_QUOTE =
      _$v1ProvidersMeOfferingsPostRequestPriceUnitEnum_ON_QUOTE;

  static Serializer<V1ProvidersMeOfferingsPostRequestPriceUnitEnum>
      get serializer =>
          _$v1ProvidersMeOfferingsPostRequestPriceUnitEnumSerializer;

  const V1ProvidersMeOfferingsPostRequestPriceUnitEnum._(String name)
      : super(name);

  static BuiltSet<V1ProvidersMeOfferingsPostRequestPriceUnitEnum> get values =>
      _$v1ProvidersMeOfferingsPostRequestPriceUnitEnumValues;
  static V1ProvidersMeOfferingsPostRequestPriceUnitEnum valueOf(String name) =>
      _$v1ProvidersMeOfferingsPostRequestPriceUnitEnumValueOf(name);
}

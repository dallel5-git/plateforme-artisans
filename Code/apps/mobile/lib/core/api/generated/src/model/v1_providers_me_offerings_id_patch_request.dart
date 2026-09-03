//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_offerings_id_patch_request.g.dart';

/// V1ProvidersMeOfferingsIdPatchRequest
///
/// Properties:
/// * [titleFr]
/// * [titleAr]
/// * [description]
/// * [priceMin]
/// * [priceMax]
/// * [priceUnit]
/// * [isNegotiable]
@BuiltValue()
abstract class V1ProvidersMeOfferingsIdPatchRequest
    implements
        Built<V1ProvidersMeOfferingsIdPatchRequest,
            V1ProvidersMeOfferingsIdPatchRequestBuilder> {
  @BuiltValueField(wireName: r'titleFr')
  String? get titleFr;

  @BuiltValueField(wireName: r'titleAr')
  String? get titleAr;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'priceMin')
  num? get priceMin;

  @BuiltValueField(wireName: r'priceMax')
  num? get priceMax;

  @BuiltValueField(wireName: r'priceUnit')
  V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum? get priceUnit;
  // enum priceUnitEnum {  FIXED,  HOUR,  DAY,  SQUARE_METER,  LINEAR_METER,  ON_QUOTE,  };

  @BuiltValueField(wireName: r'isNegotiable')
  bool? get isNegotiable;

  V1ProvidersMeOfferingsIdPatchRequest._();

  factory V1ProvidersMeOfferingsIdPatchRequest(
          [void updates(V1ProvidersMeOfferingsIdPatchRequestBuilder b)]) =
      _$V1ProvidersMeOfferingsIdPatchRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMeOfferingsIdPatchRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeOfferingsIdPatchRequest> get serializer =>
      _$V1ProvidersMeOfferingsIdPatchRequestSerializer();
}

class _$V1ProvidersMeOfferingsIdPatchRequestSerializer
    implements PrimitiveSerializer<V1ProvidersMeOfferingsIdPatchRequest> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeOfferingsIdPatchRequest,
    _$V1ProvidersMeOfferingsIdPatchRequest
  ];

  @override
  final String wireName = r'V1ProvidersMeOfferingsIdPatchRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeOfferingsIdPatchRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.titleFr != null) {
      yield r'titleFr';
      yield serializers.serialize(
        object.titleFr,
        specifiedType: const FullType(String),
      );
    }
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
            const FullType(V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum),
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
    V1ProvidersMeOfferingsIdPatchRequest object, {
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
    required V1ProvidersMeOfferingsIdPatchRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
                V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum),
          ) as V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum;
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
  V1ProvidersMeOfferingsIdPatchRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeOfferingsIdPatchRequestBuilder();
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

class V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'FIXED')
  static const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum FIXED =
      _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_FIXED;
  @BuiltValueEnumConst(wireName: r'HOUR')
  static const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum HOUR =
      _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_HOUR;
  @BuiltValueEnumConst(wireName: r'DAY')
  static const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum DAY =
      _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_DAY;
  @BuiltValueEnumConst(wireName: r'SQUARE_METER')
  static const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum SQUARE_METER =
      _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_SQUARE_METER;
  @BuiltValueEnumConst(wireName: r'LINEAR_METER')
  static const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum LINEAR_METER =
      _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_LINEAR_METER;
  @BuiltValueEnumConst(wireName: r'ON_QUOTE')
  static const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum ON_QUOTE =
      _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum_ON_QUOTE;

  static Serializer<V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum>
      get serializer =>
          _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnumSerializer;

  const V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum._(String name)
      : super(name);

  static BuiltSet<V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum>
      get values => _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnumValues;
  static V1ProvidersMeOfferingsIdPatchRequestPriceUnitEnum valueOf(
          String name) =>
      _$v1ProvidersMeOfferingsIdPatchRequestPriceUnitEnumValueOf(name);
}

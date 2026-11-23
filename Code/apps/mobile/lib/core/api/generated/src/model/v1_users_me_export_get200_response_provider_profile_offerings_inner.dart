//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_users_me_export_get200_response_provider_profile_offerings_inner.g.dart';

/// V1UsersMeExportGet200ResponseProviderProfileOfferingsInner
///
/// Properties:
/// * [id]
/// * [titleFr]
/// * [titleAr]
/// * [priceMin]
/// * [priceMax]
/// * [priceUnit]
@BuiltValue()
abstract class V1UsersMeExportGet200ResponseProviderProfileOfferingsInner
    implements
        Built<V1UsersMeExportGet200ResponseProviderProfileOfferingsInner,
            V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'titleFr')
  String get titleFr;

  @BuiltValueField(wireName: r'titleAr')
  String get titleAr;

  @BuiltValueField(wireName: r'priceMin')
  num get priceMin;

  @BuiltValueField(wireName: r'priceMax')
  num get priceMax;

  @BuiltValueField(wireName: r'priceUnit')
  String get priceUnit;

  V1UsersMeExportGet200ResponseProviderProfileOfferingsInner._();

  factory V1UsersMeExportGet200ResponseProviderProfileOfferingsInner(
          [void updates(
              V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerBuilder
                  b)]) =
      _$V1UsersMeExportGet200ResponseProviderProfileOfferingsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerBuilder
              b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1UsersMeExportGet200ResponseProviderProfileOfferingsInner>
      get serializer =>
          _$V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerSerializer();
}

class _$V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerSerializer
    implements
        PrimitiveSerializer<
            V1UsersMeExportGet200ResponseProviderProfileOfferingsInner> {
  @override
  final Iterable<Type> types = const [
    V1UsersMeExportGet200ResponseProviderProfileOfferingsInner,
    _$V1UsersMeExportGet200ResponseProviderProfileOfferingsInner
  ];

  @override
  final String wireName =
      r'V1UsersMeExportGet200ResponseProviderProfileOfferingsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1UsersMeExportGet200ResponseProviderProfileOfferingsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
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
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1UsersMeExportGet200ResponseProviderProfileOfferingsInner object, {
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
    required V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerBuilder
        result,
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
            specifiedType: const FullType(String),
          ) as String;
          result.priceUnit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1UsersMeExportGet200ResponseProviderProfileOfferingsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1UsersMeExportGet200ResponseProviderProfileOfferingsInnerBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_governorates_id_delegations_get200_response_delegations_inner.g.dart';

/// V1GovernoratesIdDelegationsGet200ResponseDelegationsInner
///
/// Properties:
/// * [id]
/// * [governorateId]
/// * [code]
/// * [nameFr]
/// * [nameAr]
/// * [slug]
/// * [postalCode]
/// * [latitude]
/// * [longitude]
@BuiltValue()
abstract class V1GovernoratesIdDelegationsGet200ResponseDelegationsInner
    implements
        Built<V1GovernoratesIdDelegationsGet200ResponseDelegationsInner,
            V1GovernoratesIdDelegationsGet200ResponseDelegationsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'governorateId')
  String get governorateId;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'nameFr')
  String get nameFr;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'postalCode')
  String get postalCode;

  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  V1GovernoratesIdDelegationsGet200ResponseDelegationsInner._();

  factory V1GovernoratesIdDelegationsGet200ResponseDelegationsInner(
          [void updates(
              V1GovernoratesIdDelegationsGet200ResponseDelegationsInnerBuilder
                  b)]) =
      _$V1GovernoratesIdDelegationsGet200ResponseDelegationsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1GovernoratesIdDelegationsGet200ResponseDelegationsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1GovernoratesIdDelegationsGet200ResponseDelegationsInner>
      get serializer =>
          _$V1GovernoratesIdDelegationsGet200ResponseDelegationsInnerSerializer();
}

class _$V1GovernoratesIdDelegationsGet200ResponseDelegationsInnerSerializer
    implements
        PrimitiveSerializer<
            V1GovernoratesIdDelegationsGet200ResponseDelegationsInner> {
  @override
  final Iterable<Type> types = const [
    V1GovernoratesIdDelegationsGet200ResponseDelegationsInner,
    _$V1GovernoratesIdDelegationsGet200ResponseDelegationsInner
  ];

  @override
  final String wireName =
      r'V1GovernoratesIdDelegationsGet200ResponseDelegationsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1GovernoratesIdDelegationsGet200ResponseDelegationsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'governorateId';
    yield serializers.serialize(
      object.governorateId,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'nameFr';
    yield serializers.serialize(
      object.nameFr,
      specifiedType: const FullType(String),
    );
    yield r'nameAr';
    yield serializers.serialize(
      object.nameAr,
      specifiedType: const FullType(String),
    );
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
    yield r'postalCode';
    yield serializers.serialize(
      object.postalCode,
      specifiedType: const FullType(String),
    );
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1GovernoratesIdDelegationsGet200ResponseDelegationsInner object, {
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
    required V1GovernoratesIdDelegationsGet200ResponseDelegationsInnerBuilder
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
        case r'governorateId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.governorateId = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'nameFr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nameFr = valueDes;
          break;
        case r'nameAr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nameAr = valueDes;
          break;
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        case r'postalCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.postalCode = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.longitude = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1GovernoratesIdDelegationsGet200ResponseDelegationsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1GovernoratesIdDelegationsGet200ResponseDelegationsInnerBuilder();
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

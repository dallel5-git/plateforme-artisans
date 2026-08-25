//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_governorates_get200_response_governorates_inner.g.dart';

/// V1GovernoratesGet200ResponseGovernoratesInner
///
/// Properties:
/// * [id]
/// * [code]
/// * [nameFr]
/// * [nameAr]
/// * [slug]
/// * [latitude]
/// * [longitude]
/// * [sortOrder]
@BuiltValue()
abstract class V1GovernoratesGet200ResponseGovernoratesInner
    implements
        Built<V1GovernoratesGet200ResponseGovernoratesInner,
            V1GovernoratesGet200ResponseGovernoratesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'nameFr')
  String get nameFr;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'sortOrder')
  int get sortOrder;

  V1GovernoratesGet200ResponseGovernoratesInner._();

  factory V1GovernoratesGet200ResponseGovernoratesInner(
          [void updates(
              V1GovernoratesGet200ResponseGovernoratesInnerBuilder b)]) =
      _$V1GovernoratesGet200ResponseGovernoratesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1GovernoratesGet200ResponseGovernoratesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1GovernoratesGet200ResponseGovernoratesInner>
      get serializer =>
          _$V1GovernoratesGet200ResponseGovernoratesInnerSerializer();
}

class _$V1GovernoratesGet200ResponseGovernoratesInnerSerializer
    implements
        PrimitiveSerializer<V1GovernoratesGet200ResponseGovernoratesInner> {
  @override
  final Iterable<Type> types = const [
    V1GovernoratesGet200ResponseGovernoratesInner,
    _$V1GovernoratesGet200ResponseGovernoratesInner
  ];

  @override
  final String wireName = r'V1GovernoratesGet200ResponseGovernoratesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1GovernoratesGet200ResponseGovernoratesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
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
    yield r'sortOrder';
    yield serializers.serialize(
      object.sortOrder,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1GovernoratesGet200ResponseGovernoratesInner object, {
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
    required V1GovernoratesGet200ResponseGovernoratesInnerBuilder result,
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
        case r'sortOrder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sortOrder = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1GovernoratesGet200ResponseGovernoratesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1GovernoratesGet200ResponseGovernoratesInnerBuilder();
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

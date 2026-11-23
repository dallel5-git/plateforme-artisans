//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_users_me_export_get200_response_provider_profile_categories_inner.g.dart';

/// V1UsersMeExportGet200ResponseProviderProfileCategoriesInner
///
/// Properties:
/// * [id]
/// * [nameFr]
/// * [nameAr]
/// * [isPrimary]
@BuiltValue()
abstract class V1UsersMeExportGet200ResponseProviderProfileCategoriesInner
    implements
        Built<V1UsersMeExportGet200ResponseProviderProfileCategoriesInner,
            V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'nameFr')
  String get nameFr;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'isPrimary')
  bool get isPrimary;

  V1UsersMeExportGet200ResponseProviderProfileCategoriesInner._();

  factory V1UsersMeExportGet200ResponseProviderProfileCategoriesInner(
          [void updates(
              V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerBuilder
                  b)]) =
      _$V1UsersMeExportGet200ResponseProviderProfileCategoriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerBuilder
              b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1UsersMeExportGet200ResponseProviderProfileCategoriesInner>
      get serializer =>
          _$V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerSerializer();
}

class _$V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerSerializer
    implements
        PrimitiveSerializer<
            V1UsersMeExportGet200ResponseProviderProfileCategoriesInner> {
  @override
  final Iterable<Type> types = const [
    V1UsersMeExportGet200ResponseProviderProfileCategoriesInner,
    _$V1UsersMeExportGet200ResponseProviderProfileCategoriesInner
  ];

  @override
  final String wireName =
      r'V1UsersMeExportGet200ResponseProviderProfileCategoriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1UsersMeExportGet200ResponseProviderProfileCategoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
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
    yield r'isPrimary';
    yield serializers.serialize(
      object.isPrimary,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1UsersMeExportGet200ResponseProviderProfileCategoriesInner object, {
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
    required V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerBuilder
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
        case r'isPrimary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isPrimary = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1UsersMeExportGet200ResponseProviderProfileCategoriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerBuilder();
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

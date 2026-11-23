//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_users_me_export_get200_response_favorites_inner.g.dart';

/// V1UsersMeExportGet200ResponseFavoritesInner
///
/// Properties:
/// * [providerId]
/// * [providerBusinessName]
/// * [createdAt]
@BuiltValue()
abstract class V1UsersMeExportGet200ResponseFavoritesInner
    implements
        Built<V1UsersMeExportGet200ResponseFavoritesInner,
            V1UsersMeExportGet200ResponseFavoritesInnerBuilder> {
  @BuiltValueField(wireName: r'providerId')
  String get providerId;

  @BuiltValueField(wireName: r'providerBusinessName')
  String get providerBusinessName;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  V1UsersMeExportGet200ResponseFavoritesInner._();

  factory V1UsersMeExportGet200ResponseFavoritesInner(
          [void updates(
              V1UsersMeExportGet200ResponseFavoritesInnerBuilder b)]) =
      _$V1UsersMeExportGet200ResponseFavoritesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1UsersMeExportGet200ResponseFavoritesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1UsersMeExportGet200ResponseFavoritesInner>
      get serializer =>
          _$V1UsersMeExportGet200ResponseFavoritesInnerSerializer();
}

class _$V1UsersMeExportGet200ResponseFavoritesInnerSerializer
    implements
        PrimitiveSerializer<V1UsersMeExportGet200ResponseFavoritesInner> {
  @override
  final Iterable<Type> types = const [
    V1UsersMeExportGet200ResponseFavoritesInner,
    _$V1UsersMeExportGet200ResponseFavoritesInner
  ];

  @override
  final String wireName = r'V1UsersMeExportGet200ResponseFavoritesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1UsersMeExportGet200ResponseFavoritesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'providerId';
    yield serializers.serialize(
      object.providerId,
      specifiedType: const FullType(String),
    );
    yield r'providerBusinessName';
    yield serializers.serialize(
      object.providerBusinessName,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1UsersMeExportGet200ResponseFavoritesInner object, {
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
    required V1UsersMeExportGet200ResponseFavoritesInnerBuilder result,
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
        case r'providerBusinessName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerBusinessName = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1UsersMeExportGet200ResponseFavoritesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1UsersMeExportGet200ResponseFavoritesInnerBuilder();
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

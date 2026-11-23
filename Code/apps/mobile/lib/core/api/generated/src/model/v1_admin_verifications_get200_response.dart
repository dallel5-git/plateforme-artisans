//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_admin_verifications_get200_response_items_inner.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_admin_verifications_get200_response.g.dart';

/// V1AdminVerificationsGet200Response
///
/// Properties:
/// * [items]
/// * [nextCursor]
/// * [totalPending]
@BuiltValue()
abstract class V1AdminVerificationsGet200Response
    implements
        Built<V1AdminVerificationsGet200Response,
            V1AdminVerificationsGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<V1AdminVerificationsGet200ResponseItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String get nextCursor;

  @BuiltValueField(wireName: r'totalPending')
  int get totalPending;

  V1AdminVerificationsGet200Response._();

  factory V1AdminVerificationsGet200Response(
          [void updates(V1AdminVerificationsGet200ResponseBuilder b)]) =
      _$V1AdminVerificationsGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1AdminVerificationsGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1AdminVerificationsGet200Response> get serializer =>
      _$V1AdminVerificationsGet200ResponseSerializer();
}

class _$V1AdminVerificationsGet200ResponseSerializer
    implements PrimitiveSerializer<V1AdminVerificationsGet200Response> {
  @override
  final Iterable<Type> types = const [
    V1AdminVerificationsGet200Response,
    _$V1AdminVerificationsGet200Response
  ];

  @override
  final String wireName = r'V1AdminVerificationsGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1AdminVerificationsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(
          BuiltList, [FullType(V1AdminVerificationsGet200ResponseItemsInner)]),
    );
    yield r'nextCursor';
    yield serializers.serialize(
      object.nextCursor,
      specifiedType: const FullType(String),
    );
    yield r'totalPending';
    yield serializers.serialize(
      object.totalPending,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1AdminVerificationsGet200Response object, {
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
    required V1AdminVerificationsGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(V1AdminVerificationsGet200ResponseItemsInner)]),
          ) as BuiltList<V1AdminVerificationsGet200ResponseItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'nextCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nextCursor = valueDes;
          break;
        case r'totalPending':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalPending = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1AdminVerificationsGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1AdminVerificationsGet200ResponseBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_governorates_get200_response_governorates_inner.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_governorates_get200_response.g.dart';

/// V1GovernoratesGet200Response
///
/// Properties:
/// * [governorates]
@BuiltValue()
abstract class V1GovernoratesGet200Response
    implements
        Built<V1GovernoratesGet200Response,
            V1GovernoratesGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'governorates')
  BuiltList<V1GovernoratesGet200ResponseGovernoratesInner> get governorates;

  V1GovernoratesGet200Response._();

  factory V1GovernoratesGet200Response(
          [void updates(V1GovernoratesGet200ResponseBuilder b)]) =
      _$V1GovernoratesGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1GovernoratesGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1GovernoratesGet200Response> get serializer =>
      _$V1GovernoratesGet200ResponseSerializer();
}

class _$V1GovernoratesGet200ResponseSerializer
    implements PrimitiveSerializer<V1GovernoratesGet200Response> {
  @override
  final Iterable<Type> types = const [
    V1GovernoratesGet200Response,
    _$V1GovernoratesGet200Response
  ];

  @override
  final String wireName = r'V1GovernoratesGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1GovernoratesGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'governorates';
    yield serializers.serialize(
      object.governorates,
      specifiedType: const FullType(
          BuiltList, [FullType(V1GovernoratesGet200ResponseGovernoratesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1GovernoratesGet200Response object, {
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
    required V1GovernoratesGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'governorates':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(V1GovernoratesGet200ResponseGovernoratesInner)]),
          ) as BuiltList<V1GovernoratesGet200ResponseGovernoratesInner>;
          result.governorates.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1GovernoratesGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1GovernoratesGet200ResponseBuilder();
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

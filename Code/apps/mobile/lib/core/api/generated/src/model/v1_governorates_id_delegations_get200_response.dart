//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_governorates_id_delegations_get200_response_delegations_inner.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_governorates_id_delegations_get200_response.g.dart';

/// V1GovernoratesIdDelegationsGet200Response
///
/// Properties:
/// * [delegations]
@BuiltValue()
abstract class V1GovernoratesIdDelegationsGet200Response
    implements
        Built<
          V1GovernoratesIdDelegationsGet200Response,
          V1GovernoratesIdDelegationsGet200ResponseBuilder
        > {
  @BuiltValueField(wireName: r'delegations')
  BuiltList<V1GovernoratesIdDelegationsGet200ResponseDelegationsInner>
  get delegations;

  V1GovernoratesIdDelegationsGet200Response._();

  factory V1GovernoratesIdDelegationsGet200Response([
    void updates(V1GovernoratesIdDelegationsGet200ResponseBuilder b),
  ]) = _$V1GovernoratesIdDelegationsGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1GovernoratesIdDelegationsGet200ResponseBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1GovernoratesIdDelegationsGet200Response> get serializer =>
      _$V1GovernoratesIdDelegationsGet200ResponseSerializer();
}

class _$V1GovernoratesIdDelegationsGet200ResponseSerializer
    implements PrimitiveSerializer<V1GovernoratesIdDelegationsGet200Response> {
  @override
  final Iterable<Type> types = const [
    V1GovernoratesIdDelegationsGet200Response,
    _$V1GovernoratesIdDelegationsGet200Response,
  ];

  @override
  final String wireName = r'V1GovernoratesIdDelegationsGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1GovernoratesIdDelegationsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'delegations';
    yield serializers.serialize(
      object.delegations,
      specifiedType: const FullType(BuiltList, [
        FullType(V1GovernoratesIdDelegationsGet200ResponseDelegationsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1GovernoratesIdDelegationsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required V1GovernoratesIdDelegationsGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'delegations':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        V1GovernoratesIdDelegationsGet200ResponseDelegationsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    V1GovernoratesIdDelegationsGet200ResponseDelegationsInner
                  >;
          result.delegations.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1GovernoratesIdDelegationsGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1GovernoratesIdDelegationsGet200ResponseBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_users_me_export_get200_response_provider_profile_coverage_areas_inner.g.dart';

/// V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner
///
/// Properties:
/// * [id]
/// * [governorateNameFr]
/// * [governorateNameAr]
/// * [delegationNameFr]
/// * [delegationNameAr]
@BuiltValue()
abstract class V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner
    implements
        Built<V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner,
            V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'governorateNameFr')
  String get governorateNameFr;

  @BuiltValueField(wireName: r'governorateNameAr')
  String get governorateNameAr;

  @BuiltValueField(wireName: r'delegationNameFr')
  String get delegationNameFr;

  @BuiltValueField(wireName: r'delegationNameAr')
  String get delegationNameAr;

  V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner._();

  factory V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner(
          [void updates(
              V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInnerBuilder
                  b)]) =
      _$V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInnerBuilder
              b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<
          V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner>
      get serializer =>
          _$V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInnerSerializer();
}

class _$V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInnerSerializer
    implements
        PrimitiveSerializer<
            V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner> {
  @override
  final Iterable<Type> types = const [
    V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner,
    _$V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner
  ];

  @override
  final String wireName =
      r'V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'governorateNameFr';
    yield serializers.serialize(
      object.governorateNameFr,
      specifiedType: const FullType(String),
    );
    yield r'governorateNameAr';
    yield serializers.serialize(
      object.governorateNameAr,
      specifiedType: const FullType(String),
    );
    yield r'delegationNameFr';
    yield serializers.serialize(
      object.delegationNameFr,
      specifiedType: const FullType(String),
    );
    yield r'delegationNameAr';
    yield serializers.serialize(
      object.delegationNameAr,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner object, {
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
    required V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInnerBuilder
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
        case r'governorateNameFr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.governorateNameFr = valueDes;
          break;
        case r'governorateNameAr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.governorateNameAr = valueDes;
          break;
        case r'delegationNameFr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.delegationNameFr = valueDes;
          break;
        case r'delegationNameAr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.delegationNameAr = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        V1UsersMeExportGet200ResponseProviderProfileCoverageAreasInnerBuilder();
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

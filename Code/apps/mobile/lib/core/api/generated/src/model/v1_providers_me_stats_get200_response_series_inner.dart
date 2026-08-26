//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_stats_get200_response_series_inner.g.dart';

/// V1ProvidersMeStatsGet200ResponseSeriesInner
///
/// Properties:
/// * [date]
/// * [profileViews]
/// * [uniqueProfileViews]
/// * [contacts]
@BuiltValue()
abstract class V1ProvidersMeStatsGet200ResponseSeriesInner
    implements
        Built<V1ProvidersMeStatsGet200ResponseSeriesInner,
            V1ProvidersMeStatsGet200ResponseSeriesInnerBuilder> {
  @BuiltValueField(wireName: r'date')
  DateTime get date;

  @BuiltValueField(wireName: r'profileViews')
  int get profileViews;

  @BuiltValueField(wireName: r'uniqueProfileViews')
  int get uniqueProfileViews;

  @BuiltValueField(wireName: r'contacts')
  int get contacts;

  V1ProvidersMeStatsGet200ResponseSeriesInner._();

  factory V1ProvidersMeStatsGet200ResponseSeriesInner(
          [void updates(
              V1ProvidersMeStatsGet200ResponseSeriesInnerBuilder b)]) =
      _$V1ProvidersMeStatsGet200ResponseSeriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMeStatsGet200ResponseSeriesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeStatsGet200ResponseSeriesInner>
      get serializer =>
          _$V1ProvidersMeStatsGet200ResponseSeriesInnerSerializer();
}

class _$V1ProvidersMeStatsGet200ResponseSeriesInnerSerializer
    implements
        PrimitiveSerializer<V1ProvidersMeStatsGet200ResponseSeriesInner> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeStatsGet200ResponseSeriesInner,
    _$V1ProvidersMeStatsGet200ResponseSeriesInner
  ];

  @override
  final String wireName = r'V1ProvidersMeStatsGet200ResponseSeriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeStatsGet200ResponseSeriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(DateTime),
    );
    yield r'profileViews';
    yield serializers.serialize(
      object.profileViews,
      specifiedType: const FullType(int),
    );
    yield r'uniqueProfileViews';
    yield serializers.serialize(
      object.uniqueProfileViews,
      specifiedType: const FullType(int),
    );
    yield r'contacts';
    yield serializers.serialize(
      object.contacts,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeStatsGet200ResponseSeriesInner object, {
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
    required V1ProvidersMeStatsGet200ResponseSeriesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.date = valueDes;
          break;
        case r'profileViews':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.profileViews = valueDes;
          break;
        case r'uniqueProfileViews':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.uniqueProfileViews = valueDes;
          break;
        case r'contacts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.contacts = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMeStatsGet200ResponseSeriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeStatsGet200ResponseSeriesInnerBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_providers_me_stats_get200_response_totals_contacts_by_channel.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_stats_get200_response_totals.g.dart';

/// V1ProvidersMeStatsGet200ResponseTotals
///
/// Properties:
/// * [profileViews]
/// * [uniqueProfileViews]
/// * [contacts]
/// * [contactsByChannel]
/// * [viewToContactRatio]
@BuiltValue()
abstract class V1ProvidersMeStatsGet200ResponseTotals
    implements
        Built<V1ProvidersMeStatsGet200ResponseTotals,
            V1ProvidersMeStatsGet200ResponseTotalsBuilder> {
  @BuiltValueField(wireName: r'profileViews')
  int get profileViews;

  @BuiltValueField(wireName: r'uniqueProfileViews')
  int get uniqueProfileViews;

  @BuiltValueField(wireName: r'contacts')
  int get contacts;

  @BuiltValueField(wireName: r'contactsByChannel')
  V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel get contactsByChannel;

  @BuiltValueField(wireName: r'viewToContactRatio')
  num get viewToContactRatio;

  V1ProvidersMeStatsGet200ResponseTotals._();

  factory V1ProvidersMeStatsGet200ResponseTotals(
          [void updates(V1ProvidersMeStatsGet200ResponseTotalsBuilder b)]) =
      _$V1ProvidersMeStatsGet200ResponseTotals;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMeStatsGet200ResponseTotalsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMeStatsGet200ResponseTotals> get serializer =>
      _$V1ProvidersMeStatsGet200ResponseTotalsSerializer();
}

class _$V1ProvidersMeStatsGet200ResponseTotalsSerializer
    implements PrimitiveSerializer<V1ProvidersMeStatsGet200ResponseTotals> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMeStatsGet200ResponseTotals,
    _$V1ProvidersMeStatsGet200ResponseTotals
  ];

  @override
  final String wireName = r'V1ProvidersMeStatsGet200ResponseTotals';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMeStatsGet200ResponseTotals object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'contactsByChannel';
    yield serializers.serialize(
      object.contactsByChannel,
      specifiedType: const FullType(
          V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel),
    );
    yield r'viewToContactRatio';
    yield serializers.serialize(
      object.viewToContactRatio,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMeStatsGet200ResponseTotals object, {
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
    required V1ProvidersMeStatsGet200ResponseTotalsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'contactsByChannel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel),
          ) as V1ProvidersMeStatsGet200ResponseTotalsContactsByChannel;
          result.contactsByChannel = valueDes.toBuilder();
          break;
        case r'viewToContactRatio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.viewToContactRatio = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMeStatsGet200ResponseTotals deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMeStatsGet200ResponseTotalsBuilder();
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

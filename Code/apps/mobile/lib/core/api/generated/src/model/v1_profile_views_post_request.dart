//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_profile_views_post_request.g.dart';

/// V1ProfileViewsPostRequest
///
/// Properties:
/// * [providerId]
/// * [source_]
@BuiltValue()
abstract class V1ProfileViewsPostRequest
    implements
        Built<V1ProfileViewsPostRequest, V1ProfileViewsPostRequestBuilder> {
  @BuiltValueField(wireName: r'providerId')
  String get providerId;

  @BuiltValueField(wireName: r'source')
  V1ProfileViewsPostRequestSource_Enum? get source_;
  // enum source_Enum {  search,  profile,  boost,  ad,  seo_page,  };

  V1ProfileViewsPostRequest._();

  factory V1ProfileViewsPostRequest([
    void updates(V1ProfileViewsPostRequestBuilder b),
  ]) = _$V1ProfileViewsPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProfileViewsPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProfileViewsPostRequest> get serializer =>
      _$V1ProfileViewsPostRequestSerializer();
}

class _$V1ProfileViewsPostRequestSerializer
    implements PrimitiveSerializer<V1ProfileViewsPostRequest> {
  @override
  final Iterable<Type> types = const [
    V1ProfileViewsPostRequest,
    _$V1ProfileViewsPostRequest,
  ];

  @override
  final String wireName = r'V1ProfileViewsPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProfileViewsPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'providerId';
    yield serializers.serialize(
      object.providerId,
      specifiedType: const FullType(String),
    );
    if (object.source_ != null) {
      yield r'source';
      yield serializers.serialize(
        object.source_,
        specifiedType: const FullType(V1ProfileViewsPostRequestSource_Enum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProfileViewsPostRequest object, {
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
    required V1ProfileViewsPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'providerId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.providerId = valueDes;
          break;
        case r'source':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      V1ProfileViewsPostRequestSource_Enum,
                    ),
                  )
                  as V1ProfileViewsPostRequestSource_Enum;
          result.source_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProfileViewsPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProfileViewsPostRequestBuilder();
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

class V1ProfileViewsPostRequestSource_Enum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'search')
  static const V1ProfileViewsPostRequestSource_Enum search =
      _$v1ProfileViewsPostRequestSourceEnum_search;
  @BuiltValueEnumConst(wireName: r'profile')
  static const V1ProfileViewsPostRequestSource_Enum profile =
      _$v1ProfileViewsPostRequestSourceEnum_profile;
  @BuiltValueEnumConst(wireName: r'boost')
  static const V1ProfileViewsPostRequestSource_Enum boost =
      _$v1ProfileViewsPostRequestSourceEnum_boost;
  @BuiltValueEnumConst(wireName: r'ad')
  static const V1ProfileViewsPostRequestSource_Enum ad =
      _$v1ProfileViewsPostRequestSourceEnum_ad;
  @BuiltValueEnumConst(wireName: r'seo_page')
  static const V1ProfileViewsPostRequestSource_Enum seoPage =
      _$v1ProfileViewsPostRequestSourceEnum_seoPage;

  static Serializer<V1ProfileViewsPostRequestSource_Enum> get serializer =>
      _$v1ProfileViewsPostRequestSourceEnumSerializer;

  const V1ProfileViewsPostRequestSource_Enum._(String name) : super(name);

  static BuiltSet<V1ProfileViewsPostRequestSource_Enum> get values =>
      _$v1ProfileViewsPostRequestSourceEnumValues;
  static V1ProfileViewsPostRequestSource_Enum valueOf(String name) =>
      _$v1ProfileViewsPostRequestSourceEnumValueOf(name);
}

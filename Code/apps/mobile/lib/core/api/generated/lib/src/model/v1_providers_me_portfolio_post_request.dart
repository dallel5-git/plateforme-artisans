//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_portfolio_post_request.g.dart';

/// V1ProvidersMePortfolioPostRequest
///
/// Properties:
/// * [mediaId]
/// * [categoryId]
/// * [caption]
@BuiltValue()
abstract class V1ProvidersMePortfolioPostRequest
    implements
        Built<V1ProvidersMePortfolioPostRequest,
            V1ProvidersMePortfolioPostRequestBuilder> {
  @BuiltValueField(wireName: r'mediaId')
  String get mediaId;

  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  @BuiltValueField(wireName: r'caption')
  String? get caption;

  V1ProvidersMePortfolioPostRequest._();

  factory V1ProvidersMePortfolioPostRequest(
          [void updates(V1ProvidersMePortfolioPostRequestBuilder b)]) =
      _$V1ProvidersMePortfolioPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMePortfolioPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMePortfolioPostRequest> get serializer =>
      _$V1ProvidersMePortfolioPostRequestSerializer();
}

class _$V1ProvidersMePortfolioPostRequestSerializer
    implements PrimitiveSerializer<V1ProvidersMePortfolioPostRequest> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMePortfolioPostRequest,
    _$V1ProvidersMePortfolioPostRequest
  ];

  @override
  final String wireName = r'V1ProvidersMePortfolioPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMePortfolioPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'mediaId';
    yield serializers.serialize(
      object.mediaId,
      specifiedType: const FullType(String),
    );
    if (object.categoryId != null) {
      yield r'categoryId';
      yield serializers.serialize(
        object.categoryId,
        specifiedType: const FullType(String),
      );
    }
    if (object.caption != null) {
      yield r'caption';
      yield serializers.serialize(
        object.caption,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMePortfolioPostRequest object, {
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
    required V1ProvidersMePortfolioPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'mediaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mediaId = valueDes;
          break;
        case r'categoryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoryId = valueDes;
          break;
        case r'caption':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.caption = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMePortfolioPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMePortfolioPostRequestBuilder();
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

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_providers_me_post_request.g.dart';

/// V1ProvidersMePostRequest
///
/// Properties:
/// * [businessName]
/// * [baseGovernorateId]
/// * [baseDelegationId]
/// * [headline]
/// * [bio]
/// * [yearsExperience]
/// * [whatsappPhone]
/// * [publicPhone]
/// * [spokenLanguages]
@BuiltValue()
abstract class V1ProvidersMePostRequest
    implements
        Built<V1ProvidersMePostRequest, V1ProvidersMePostRequestBuilder> {
  @BuiltValueField(wireName: r'businessName')
  String get businessName;

  @BuiltValueField(wireName: r'baseGovernorateId')
  String get baseGovernorateId;

  @BuiltValueField(wireName: r'baseDelegationId')
  String? get baseDelegationId;

  @BuiltValueField(wireName: r'headline')
  String? get headline;

  @BuiltValueField(wireName: r'bio')
  String? get bio;

  @BuiltValueField(wireName: r'yearsExperience')
  int? get yearsExperience;

  @BuiltValueField(wireName: r'whatsappPhone')
  String? get whatsappPhone;

  @BuiltValueField(wireName: r'publicPhone')
  String? get publicPhone;

  @BuiltValueField(wireName: r'spokenLanguages')
  BuiltList<V1ProvidersMePostRequestSpokenLanguagesEnum>? get spokenLanguages;
  // enum spokenLanguagesEnum {  FR,  AR,  EN,  };

  V1ProvidersMePostRequest._();

  factory V1ProvidersMePostRequest([
    void updates(V1ProvidersMePostRequestBuilder b),
  ]) = _$V1ProvidersMePostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1ProvidersMePostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1ProvidersMePostRequest> get serializer =>
      _$V1ProvidersMePostRequestSerializer();
}

class _$V1ProvidersMePostRequestSerializer
    implements PrimitiveSerializer<V1ProvidersMePostRequest> {
  @override
  final Iterable<Type> types = const [
    V1ProvidersMePostRequest,
    _$V1ProvidersMePostRequest,
  ];

  @override
  final String wireName = r'V1ProvidersMePostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1ProvidersMePostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'businessName';
    yield serializers.serialize(
      object.businessName,
      specifiedType: const FullType(String),
    );
    yield r'baseGovernorateId';
    yield serializers.serialize(
      object.baseGovernorateId,
      specifiedType: const FullType(String),
    );
    if (object.baseDelegationId != null) {
      yield r'baseDelegationId';
      yield serializers.serialize(
        object.baseDelegationId,
        specifiedType: const FullType(String),
      );
    }
    if (object.headline != null) {
      yield r'headline';
      yield serializers.serialize(
        object.headline,
        specifiedType: const FullType(String),
      );
    }
    if (object.bio != null) {
      yield r'bio';
      yield serializers.serialize(
        object.bio,
        specifiedType: const FullType(String),
      );
    }
    if (object.yearsExperience != null) {
      yield r'yearsExperience';
      yield serializers.serialize(
        object.yearsExperience,
        specifiedType: const FullType(int),
      );
    }
    if (object.whatsappPhone != null) {
      yield r'whatsappPhone';
      yield serializers.serialize(
        object.whatsappPhone,
        specifiedType: const FullType(String),
      );
    }
    if (object.publicPhone != null) {
      yield r'publicPhone';
      yield serializers.serialize(
        object.publicPhone,
        specifiedType: const FullType(String),
      );
    }
    if (object.spokenLanguages != null) {
      yield r'spokenLanguages';
      yield serializers.serialize(
        object.spokenLanguages,
        specifiedType: const FullType(BuiltList, [
          FullType(V1ProvidersMePostRequestSpokenLanguagesEnum),
        ]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    V1ProvidersMePostRequest object, {
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
    required V1ProvidersMePostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'businessName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.businessName = valueDes;
          break;
        case r'baseGovernorateId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.baseGovernorateId = valueDes;
          break;
        case r'baseDelegationId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.baseDelegationId = valueDes;
          break;
        case r'headline':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.headline = valueDes;
          break;
        case r'bio':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.bio = valueDes;
          break;
        case r'yearsExperience':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )
                  as int;
          result.yearsExperience = valueDes;
          break;
        case r'whatsappPhone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.whatsappPhone = valueDes;
          break;
        case r'publicPhone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.publicPhone = valueDes;
          break;
        case r'spokenLanguages':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(V1ProvidersMePostRequestSpokenLanguagesEnum),
                    ]),
                  )
                  as BuiltList<V1ProvidersMePostRequestSpokenLanguagesEnum>;
          result.spokenLanguages.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1ProvidersMePostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1ProvidersMePostRequestBuilder();
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

class V1ProvidersMePostRequestSpokenLanguagesEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'FR')
  static const V1ProvidersMePostRequestSpokenLanguagesEnum FR =
      _$v1ProvidersMePostRequestSpokenLanguagesEnum_FR;
  @BuiltValueEnumConst(wireName: r'AR')
  static const V1ProvidersMePostRequestSpokenLanguagesEnum AR =
      _$v1ProvidersMePostRequestSpokenLanguagesEnum_AR;
  @BuiltValueEnumConst(wireName: r'EN')
  static const V1ProvidersMePostRequestSpokenLanguagesEnum EN =
      _$v1ProvidersMePostRequestSpokenLanguagesEnum_EN;

  static Serializer<V1ProvidersMePostRequestSpokenLanguagesEnum>
  get serializer => _$v1ProvidersMePostRequestSpokenLanguagesEnumSerializer;

  const V1ProvidersMePostRequestSpokenLanguagesEnum._(String name)
    : super(name);

  static BuiltSet<V1ProvidersMePostRequestSpokenLanguagesEnum> get values =>
      _$v1ProvidersMePostRequestSpokenLanguagesEnumValues;
  static V1ProvidersMePostRequestSpokenLanguagesEnum valueOf(String name) =>
      _$v1ProvidersMePostRequestSpokenLanguagesEnumValueOf(name);
}

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sanaya/core/api/generated/src/model/v1_users_me_export_get200_response_user.dart';
import 'package:sanaya/core/api/generated/src/model/v1_users_me_export_get200_response_verification_requests_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:sanaya/core/api/generated/src/model/v1_users_me_export_get200_response_favorites_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_users_me_export_get200_response_reviews_written_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_users_me_export_get200_response_contact_events_inner.dart';
import 'package:sanaya/core/api/generated/src/model/v1_users_me_export_get200_response_provider_profile.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'v1_users_me_export_get200_response.g.dart';

/// V1UsersMeExportGet200Response
///
/// Properties:
/// * [legalNotice]
/// * [exportedAt]
/// * [user]
/// * [providerProfile]
/// * [reviewsWritten]
/// * [favorites]
/// * [contactEvents]
/// * [verificationRequests]
@BuiltValue()
abstract class V1UsersMeExportGet200Response
    implements
        Built<V1UsersMeExportGet200Response,
            V1UsersMeExportGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'legalNotice')
  String get legalNotice;

  @BuiltValueField(wireName: r'exportedAt')
  DateTime get exportedAt;

  @BuiltValueField(wireName: r'user')
  V1UsersMeExportGet200ResponseUser get user;

  @BuiltValueField(wireName: r'providerProfile')
  V1UsersMeExportGet200ResponseProviderProfile get providerProfile;

  @BuiltValueField(wireName: r'reviewsWritten')
  BuiltList<V1UsersMeExportGet200ResponseReviewsWrittenInner>
      get reviewsWritten;

  @BuiltValueField(wireName: r'favorites')
  BuiltList<V1UsersMeExportGet200ResponseFavoritesInner> get favorites;

  @BuiltValueField(wireName: r'contactEvents')
  BuiltList<V1UsersMeExportGet200ResponseContactEventsInner> get contactEvents;

  @BuiltValueField(wireName: r'verificationRequests')
  BuiltList<V1UsersMeExportGet200ResponseVerificationRequestsInner>
      get verificationRequests;

  V1UsersMeExportGet200Response._();

  factory V1UsersMeExportGet200Response(
          [void updates(V1UsersMeExportGet200ResponseBuilder b)]) =
      _$V1UsersMeExportGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(V1UsersMeExportGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<V1UsersMeExportGet200Response> get serializer =>
      _$V1UsersMeExportGet200ResponseSerializer();
}

class _$V1UsersMeExportGet200ResponseSerializer
    implements PrimitiveSerializer<V1UsersMeExportGet200Response> {
  @override
  final Iterable<Type> types = const [
    V1UsersMeExportGet200Response,
    _$V1UsersMeExportGet200Response
  ];

  @override
  final String wireName = r'V1UsersMeExportGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    V1UsersMeExportGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'legalNotice';
    yield serializers.serialize(
      object.legalNotice,
      specifiedType: const FullType(String),
    );
    yield r'exportedAt';
    yield serializers.serialize(
      object.exportedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(V1UsersMeExportGet200ResponseUser),
    );
    yield r'providerProfile';
    yield serializers.serialize(
      object.providerProfile,
      specifiedType:
          const FullType(V1UsersMeExportGet200ResponseProviderProfile),
    );
    yield r'reviewsWritten';
    yield serializers.serialize(
      object.reviewsWritten,
      specifiedType: const FullType(BuiltList,
          [FullType(V1UsersMeExportGet200ResponseReviewsWrittenInner)]),
    );
    yield r'favorites';
    yield serializers.serialize(
      object.favorites,
      specifiedType: const FullType(
          BuiltList, [FullType(V1UsersMeExportGet200ResponseFavoritesInner)]),
    );
    yield r'contactEvents';
    yield serializers.serialize(
      object.contactEvents,
      specifiedType: const FullType(BuiltList,
          [FullType(V1UsersMeExportGet200ResponseContactEventsInner)]),
    );
    yield r'verificationRequests';
    yield serializers.serialize(
      object.verificationRequests,
      specifiedType: const FullType(BuiltList,
          [FullType(V1UsersMeExportGet200ResponseVerificationRequestsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    V1UsersMeExportGet200Response object, {
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
    required V1UsersMeExportGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'legalNotice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.legalNotice = valueDes;
          break;
        case r'exportedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.exportedAt = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(V1UsersMeExportGet200ResponseUser),
          ) as V1UsersMeExportGet200ResponseUser;
          result.user = valueDes.toBuilder();
          break;
        case r'providerProfile':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(V1UsersMeExportGet200ResponseProviderProfile),
          ) as V1UsersMeExportGet200ResponseProviderProfile;
          result.providerProfile = valueDes.toBuilder();
          break;
        case r'reviewsWritten':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(V1UsersMeExportGet200ResponseReviewsWrittenInner)]),
          ) as BuiltList<V1UsersMeExportGet200ResponseReviewsWrittenInner>;
          result.reviewsWritten.replace(valueDes);
          break;
        case r'favorites':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(V1UsersMeExportGet200ResponseFavoritesInner)]),
          ) as BuiltList<V1UsersMeExportGet200ResponseFavoritesInner>;
          result.favorites.replace(valueDes);
          break;
        case r'contactEvents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(V1UsersMeExportGet200ResponseContactEventsInner)]),
          ) as BuiltList<V1UsersMeExportGet200ResponseContactEventsInner>;
          result.contactEvents.replace(valueDes);
          break;
        case r'verificationRequests':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType(V1UsersMeExportGet200ResponseVerificationRequestsInner)
            ]),
          ) as BuiltList<
              V1UsersMeExportGet200ResponseVerificationRequestsInner>;
          result.verificationRequests.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  V1UsersMeExportGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = V1UsersMeExportGet200ResponseBuilder();
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

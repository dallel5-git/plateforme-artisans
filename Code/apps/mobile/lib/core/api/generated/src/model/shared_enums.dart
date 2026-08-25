//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// BE-26 : enums réutilisés par plusieurs réponses de l'API (ex. rôles, langues parlées).
// openapi-generator (dart-dio) émet une définition par point d'usage au lieu de réutiliser
// un schéma nommé (le contrat source n'a aucun composant partagé) — regroupées ici pour
// éviter un conflit de nom (built_value exige des noms de classe uniques dans tout le
// package). Regroupement fait par tooling/scripts/mobile-client.mjs, pas par le générateur.
//

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'shared_enums.g.dart';

class V1AuthOtpVerifyPost200ResponseUserRolesEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'CLIENT')
  static const V1AuthOtpVerifyPost200ResponseUserRolesEnum CLIENT =
      _$v1AuthOtpVerifyPost200ResponseUserRolesEnum_CLIENT;
  @BuiltValueEnumConst(wireName: r'PROVIDER')
  static const V1AuthOtpVerifyPost200ResponseUserRolesEnum PROVIDER =
      _$v1AuthOtpVerifyPost200ResponseUserRolesEnum_PROVIDER;
  @BuiltValueEnumConst(wireName: r'MODERATOR')
  static const V1AuthOtpVerifyPost200ResponseUserRolesEnum MODERATOR =
      _$v1AuthOtpVerifyPost200ResponseUserRolesEnum_MODERATOR;
  @BuiltValueEnumConst(wireName: r'SUPPORT')
  static const V1AuthOtpVerifyPost200ResponseUserRolesEnum SUPPORT =
      _$v1AuthOtpVerifyPost200ResponseUserRolesEnum_SUPPORT;
  @BuiltValueEnumConst(wireName: r'SALES')
  static const V1AuthOtpVerifyPost200ResponseUserRolesEnum SALES =
      _$v1AuthOtpVerifyPost200ResponseUserRolesEnum_SALES;
  @BuiltValueEnumConst(wireName: r'FINANCE')
  static const V1AuthOtpVerifyPost200ResponseUserRolesEnum FINANCE =
      _$v1AuthOtpVerifyPost200ResponseUserRolesEnum_FINANCE;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const V1AuthOtpVerifyPost200ResponseUserRolesEnum ADMIN =
      _$v1AuthOtpVerifyPost200ResponseUserRolesEnum_ADMIN;
  @BuiltValueEnumConst(wireName: r'SUPER_ADMIN')
  static const V1AuthOtpVerifyPost200ResponseUserRolesEnum SUPER_ADMIN =
      _$v1AuthOtpVerifyPost200ResponseUserRolesEnum_SUPER_ADMIN;

  static Serializer<V1AuthOtpVerifyPost200ResponseUserRolesEnum>
  get serializer => _$v1AuthOtpVerifyPost200ResponseUserRolesEnumSerializer;

  const V1AuthOtpVerifyPost200ResponseUserRolesEnum._(String name)
    : super(name);

  static BuiltSet<V1AuthOtpVerifyPost200ResponseUserRolesEnum> get values =>
      _$v1AuthOtpVerifyPost200ResponseUserRolesEnumValues;
  static V1AuthOtpVerifyPost200ResponseUserRolesEnum valueOf(String name) =>
      _$v1AuthOtpVerifyPost200ResponseUserRolesEnumValueOf(name);
}

class V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'FR')
  static const V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum FR =
      _$v1ProvidersMePost200ResponseProviderSpokenLanguagesEnum_FR;
  @BuiltValueEnumConst(wireName: r'AR')
  static const V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum AR =
      _$v1ProvidersMePost200ResponseProviderSpokenLanguagesEnum_AR;
  @BuiltValueEnumConst(wireName: r'EN')
  static const V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum EN =
      _$v1ProvidersMePost200ResponseProviderSpokenLanguagesEnum_EN;

  static Serializer<V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>
  get serializer =>
      _$v1ProvidersMePost200ResponseProviderSpokenLanguagesEnumSerializer;

  const V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum._(String name)
    : super(name);

  static BuiltSet<V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum>
  get values => _$v1ProvidersMePost200ResponseProviderSpokenLanguagesEnumValues;
  static V1ProvidersMePost200ResponseProviderSpokenLanguagesEnum valueOf(
    String name,
  ) => _$v1ProvidersMePost200ResponseProviderSpokenLanguagesEnumValueOf(name);
}

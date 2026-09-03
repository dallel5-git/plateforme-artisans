// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_patch_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ProvidersMePatchRequestAvailabilityStatusEnum
    _$v1ProvidersMePatchRequestAvailabilityStatusEnum_AVAILABLE =
    const V1ProvidersMePatchRequestAvailabilityStatusEnum._('AVAILABLE');
const V1ProvidersMePatchRequestAvailabilityStatusEnum
    _$v1ProvidersMePatchRequestAvailabilityStatusEnum_BUSY =
    const V1ProvidersMePatchRequestAvailabilityStatusEnum._('BUSY');
const V1ProvidersMePatchRequestAvailabilityStatusEnum
    _$v1ProvidersMePatchRequestAvailabilityStatusEnum_ON_HOLIDAY =
    const V1ProvidersMePatchRequestAvailabilityStatusEnum._('ON_HOLIDAY');

V1ProvidersMePatchRequestAvailabilityStatusEnum
    _$v1ProvidersMePatchRequestAvailabilityStatusEnumValueOf(String name) {
  switch (name) {
    case 'AVAILABLE':
      return _$v1ProvidersMePatchRequestAvailabilityStatusEnum_AVAILABLE;
    case 'BUSY':
      return _$v1ProvidersMePatchRequestAvailabilityStatusEnum_BUSY;
    case 'ON_HOLIDAY':
      return _$v1ProvidersMePatchRequestAvailabilityStatusEnum_ON_HOLIDAY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProvidersMePatchRequestAvailabilityStatusEnum>
    _$v1ProvidersMePatchRequestAvailabilityStatusEnumValues = BuiltSet<
        V1ProvidersMePatchRequestAvailabilityStatusEnum>(const <V1ProvidersMePatchRequestAvailabilityStatusEnum>[
  _$v1ProvidersMePatchRequestAvailabilityStatusEnum_AVAILABLE,
  _$v1ProvidersMePatchRequestAvailabilityStatusEnum_BUSY,
  _$v1ProvidersMePatchRequestAvailabilityStatusEnum_ON_HOLIDAY,
]);

const V1ProvidersMePatchRequestPublicationStatusEnum
    _$v1ProvidersMePatchRequestPublicationStatusEnum_DRAFT =
    const V1ProvidersMePatchRequestPublicationStatusEnum._('DRAFT');
const V1ProvidersMePatchRequestPublicationStatusEnum
    _$v1ProvidersMePatchRequestPublicationStatusEnum_PUBLISHED =
    const V1ProvidersMePatchRequestPublicationStatusEnum._('PUBLISHED');

V1ProvidersMePatchRequestPublicationStatusEnum
    _$v1ProvidersMePatchRequestPublicationStatusEnumValueOf(String name) {
  switch (name) {
    case 'DRAFT':
      return _$v1ProvidersMePatchRequestPublicationStatusEnum_DRAFT;
    case 'PUBLISHED':
      return _$v1ProvidersMePatchRequestPublicationStatusEnum_PUBLISHED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProvidersMePatchRequestPublicationStatusEnum>
    _$v1ProvidersMePatchRequestPublicationStatusEnumValues = BuiltSet<
        V1ProvidersMePatchRequestPublicationStatusEnum>(const <V1ProvidersMePatchRequestPublicationStatusEnum>[
  _$v1ProvidersMePatchRequestPublicationStatusEnum_DRAFT,
  _$v1ProvidersMePatchRequestPublicationStatusEnum_PUBLISHED,
]);

Serializer<V1ProvidersMePatchRequestAvailabilityStatusEnum>
    _$v1ProvidersMePatchRequestAvailabilityStatusEnumSerializer =
    _$V1ProvidersMePatchRequestAvailabilityStatusEnumSerializer();
Serializer<V1ProvidersMePatchRequestPublicationStatusEnum>
    _$v1ProvidersMePatchRequestPublicationStatusEnumSerializer =
    _$V1ProvidersMePatchRequestPublicationStatusEnumSerializer();

class _$V1ProvidersMePatchRequestAvailabilityStatusEnumSerializer
    implements
        PrimitiveSerializer<V1ProvidersMePatchRequestAvailabilityStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AVAILABLE': 'AVAILABLE',
    'BUSY': 'BUSY',
    'ON_HOLIDAY': 'ON_HOLIDAY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AVAILABLE': 'AVAILABLE',
    'BUSY': 'BUSY',
    'ON_HOLIDAY': 'ON_HOLIDAY',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1ProvidersMePatchRequestAvailabilityStatusEnum
  ];
  @override
  final String wireName = 'V1ProvidersMePatchRequestAvailabilityStatusEnum';

  @override
  Object serialize(Serializers serializers,
          V1ProvidersMePatchRequestAvailabilityStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ProvidersMePatchRequestAvailabilityStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ProvidersMePatchRequestAvailabilityStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ProvidersMePatchRequestPublicationStatusEnumSerializer
    implements
        PrimitiveSerializer<V1ProvidersMePatchRequestPublicationStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'PUBLISHED': 'PUBLISHED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'PUBLISHED': 'PUBLISHED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1ProvidersMePatchRequestPublicationStatusEnum
  ];
  @override
  final String wireName = 'V1ProvidersMePatchRequestPublicationStatusEnum';

  @override
  Object serialize(Serializers serializers,
          V1ProvidersMePatchRequestPublicationStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ProvidersMePatchRequestPublicationStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ProvidersMePatchRequestPublicationStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ProvidersMePatchRequest extends V1ProvidersMePatchRequest {
  @override
  final String? businessName;
  @override
  final String? headline;
  @override
  final String? bio;
  @override
  final int? yearsExperience;
  @override
  final String? whatsappPhone;
  @override
  final String? publicPhone;
  @override
  final V1ProvidersMePatchRequestAvailabilityStatusEnum? availabilityStatus;
  @override
  final JsonObject? availableAgainAt;
  @override
  final bool? acceptsEmergency;
  @override
  final BuiltMap<String, JsonObject?>? workingHours;
  @override
  final V1ProvidersMePatchRequestPublicationStatusEnum? publicationStatus;

  factory _$V1ProvidersMePatchRequest(
          [void Function(V1ProvidersMePatchRequestBuilder)? updates]) =>
      (V1ProvidersMePatchRequestBuilder()..update(updates))._build();

  _$V1ProvidersMePatchRequest._(
      {this.businessName,
      this.headline,
      this.bio,
      this.yearsExperience,
      this.whatsappPhone,
      this.publicPhone,
      this.availabilityStatus,
      this.availableAgainAt,
      this.acceptsEmergency,
      this.workingHours,
      this.publicationStatus})
      : super._();
  @override
  V1ProvidersMePatchRequest rebuild(
          void Function(V1ProvidersMePatchRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMePatchRequestBuilder toBuilder() =>
      V1ProvidersMePatchRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMePatchRequest &&
        businessName == other.businessName &&
        headline == other.headline &&
        bio == other.bio &&
        yearsExperience == other.yearsExperience &&
        whatsappPhone == other.whatsappPhone &&
        publicPhone == other.publicPhone &&
        availabilityStatus == other.availabilityStatus &&
        availableAgainAt == other.availableAgainAt &&
        acceptsEmergency == other.acceptsEmergency &&
        workingHours == other.workingHours &&
        publicationStatus == other.publicationStatus;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, businessName.hashCode);
    _$hash = $jc(_$hash, headline.hashCode);
    _$hash = $jc(_$hash, bio.hashCode);
    _$hash = $jc(_$hash, yearsExperience.hashCode);
    _$hash = $jc(_$hash, whatsappPhone.hashCode);
    _$hash = $jc(_$hash, publicPhone.hashCode);
    _$hash = $jc(_$hash, availabilityStatus.hashCode);
    _$hash = $jc(_$hash, availableAgainAt.hashCode);
    _$hash = $jc(_$hash, acceptsEmergency.hashCode);
    _$hash = $jc(_$hash, workingHours.hashCode);
    _$hash = $jc(_$hash, publicationStatus.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1ProvidersMePatchRequest')
          ..add('businessName', businessName)
          ..add('headline', headline)
          ..add('bio', bio)
          ..add('yearsExperience', yearsExperience)
          ..add('whatsappPhone', whatsappPhone)
          ..add('publicPhone', publicPhone)
          ..add('availabilityStatus', availabilityStatus)
          ..add('availableAgainAt', availableAgainAt)
          ..add('acceptsEmergency', acceptsEmergency)
          ..add('workingHours', workingHours)
          ..add('publicationStatus', publicationStatus))
        .toString();
  }
}

class V1ProvidersMePatchRequestBuilder
    implements
        Builder<V1ProvidersMePatchRequest, V1ProvidersMePatchRequestBuilder> {
  _$V1ProvidersMePatchRequest? _$v;

  String? _businessName;
  String? get businessName => _$this._businessName;
  set businessName(String? businessName) => _$this._businessName = businessName;

  String? _headline;
  String? get headline => _$this._headline;
  set headline(String? headline) => _$this._headline = headline;

  String? _bio;
  String? get bio => _$this._bio;
  set bio(String? bio) => _$this._bio = bio;

  int? _yearsExperience;
  int? get yearsExperience => _$this._yearsExperience;
  set yearsExperience(int? yearsExperience) =>
      _$this._yearsExperience = yearsExperience;

  String? _whatsappPhone;
  String? get whatsappPhone => _$this._whatsappPhone;
  set whatsappPhone(String? whatsappPhone) =>
      _$this._whatsappPhone = whatsappPhone;

  String? _publicPhone;
  String? get publicPhone => _$this._publicPhone;
  set publicPhone(String? publicPhone) => _$this._publicPhone = publicPhone;

  V1ProvidersMePatchRequestAvailabilityStatusEnum? _availabilityStatus;
  V1ProvidersMePatchRequestAvailabilityStatusEnum? get availabilityStatus =>
      _$this._availabilityStatus;
  set availabilityStatus(
          V1ProvidersMePatchRequestAvailabilityStatusEnum?
              availabilityStatus) =>
      _$this._availabilityStatus = availabilityStatus;

  JsonObject? _availableAgainAt;
  JsonObject? get availableAgainAt => _$this._availableAgainAt;
  set availableAgainAt(JsonObject? availableAgainAt) =>
      _$this._availableAgainAt = availableAgainAt;

  bool? _acceptsEmergency;
  bool? get acceptsEmergency => _$this._acceptsEmergency;
  set acceptsEmergency(bool? acceptsEmergency) =>
      _$this._acceptsEmergency = acceptsEmergency;

  MapBuilder<String, JsonObject?>? _workingHours;
  MapBuilder<String, JsonObject?> get workingHours =>
      _$this._workingHours ??= MapBuilder<String, JsonObject?>();
  set workingHours(MapBuilder<String, JsonObject?>? workingHours) =>
      _$this._workingHours = workingHours;

  V1ProvidersMePatchRequestPublicationStatusEnum? _publicationStatus;
  V1ProvidersMePatchRequestPublicationStatusEnum? get publicationStatus =>
      _$this._publicationStatus;
  set publicationStatus(
          V1ProvidersMePatchRequestPublicationStatusEnum? publicationStatus) =>
      _$this._publicationStatus = publicationStatus;

  V1ProvidersMePatchRequestBuilder() {
    V1ProvidersMePatchRequest._defaults(this);
  }

  V1ProvidersMePatchRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _businessName = $v.businessName;
      _headline = $v.headline;
      _bio = $v.bio;
      _yearsExperience = $v.yearsExperience;
      _whatsappPhone = $v.whatsappPhone;
      _publicPhone = $v.publicPhone;
      _availabilityStatus = $v.availabilityStatus;
      _availableAgainAt = $v.availableAgainAt;
      _acceptsEmergency = $v.acceptsEmergency;
      _workingHours = $v.workingHours?.toBuilder();
      _publicationStatus = $v.publicationStatus;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMePatchRequest other) {
    _$v = other as _$V1ProvidersMePatchRequest;
  }

  @override
  void update(void Function(V1ProvidersMePatchRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMePatchRequest build() => _build();

  _$V1ProvidersMePatchRequest _build() {
    _$V1ProvidersMePatchRequest _$result;
    try {
      _$result = _$v ??
          _$V1ProvidersMePatchRequest._(
            businessName: businessName,
            headline: headline,
            bio: bio,
            yearsExperience: yearsExperience,
            whatsappPhone: whatsappPhone,
            publicPhone: publicPhone,
            availabilityStatus: availabilityStatus,
            availableAgainAt: availableAgainAt,
            acceptsEmergency: acceptsEmergency,
            workingHours: _workingHours?.build(),
            publicationStatus: publicationStatus,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'workingHours';
        _workingHours?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1ProvidersMePatchRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

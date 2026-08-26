// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_contact_events_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ContactEventsPostRequestChannelEnum
    _$v1ContactEventsPostRequestChannelEnum_PHONE =
    const V1ContactEventsPostRequestChannelEnum._('PHONE');
const V1ContactEventsPostRequestChannelEnum
    _$v1ContactEventsPostRequestChannelEnum_WHATSAPP =
    const V1ContactEventsPostRequestChannelEnum._('WHATSAPP');

V1ContactEventsPostRequestChannelEnum
    _$v1ContactEventsPostRequestChannelEnumValueOf(String name) {
  switch (name) {
    case 'PHONE':
      return _$v1ContactEventsPostRequestChannelEnum_PHONE;
    case 'WHATSAPP':
      return _$v1ContactEventsPostRequestChannelEnum_WHATSAPP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ContactEventsPostRequestChannelEnum>
    _$v1ContactEventsPostRequestChannelEnumValues = BuiltSet<
        V1ContactEventsPostRequestChannelEnum>(const <V1ContactEventsPostRequestChannelEnum>[
  _$v1ContactEventsPostRequestChannelEnum_PHONE,
  _$v1ContactEventsPostRequestChannelEnum_WHATSAPP,
]);

const V1ContactEventsPostRequestSourceScreenEnum
    _$v1ContactEventsPostRequestSourceScreenEnum_search =
    const V1ContactEventsPostRequestSourceScreenEnum._('search');
const V1ContactEventsPostRequestSourceScreenEnum
    _$v1ContactEventsPostRequestSourceScreenEnum_profile =
    const V1ContactEventsPostRequestSourceScreenEnum._('profile');
const V1ContactEventsPostRequestSourceScreenEnum
    _$v1ContactEventsPostRequestSourceScreenEnum_boost =
    const V1ContactEventsPostRequestSourceScreenEnum._('boost');
const V1ContactEventsPostRequestSourceScreenEnum
    _$v1ContactEventsPostRequestSourceScreenEnum_ad =
    const V1ContactEventsPostRequestSourceScreenEnum._('ad');
const V1ContactEventsPostRequestSourceScreenEnum
    _$v1ContactEventsPostRequestSourceScreenEnum_seoPage =
    const V1ContactEventsPostRequestSourceScreenEnum._('seoPage');

V1ContactEventsPostRequestSourceScreenEnum
    _$v1ContactEventsPostRequestSourceScreenEnumValueOf(String name) {
  switch (name) {
    case 'search':
      return _$v1ContactEventsPostRequestSourceScreenEnum_search;
    case 'profile':
      return _$v1ContactEventsPostRequestSourceScreenEnum_profile;
    case 'boost':
      return _$v1ContactEventsPostRequestSourceScreenEnum_boost;
    case 'ad':
      return _$v1ContactEventsPostRequestSourceScreenEnum_ad;
    case 'seoPage':
      return _$v1ContactEventsPostRequestSourceScreenEnum_seoPage;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ContactEventsPostRequestSourceScreenEnum>
    _$v1ContactEventsPostRequestSourceScreenEnumValues = BuiltSet<
        V1ContactEventsPostRequestSourceScreenEnum>(const <V1ContactEventsPostRequestSourceScreenEnum>[
  _$v1ContactEventsPostRequestSourceScreenEnum_search,
  _$v1ContactEventsPostRequestSourceScreenEnum_profile,
  _$v1ContactEventsPostRequestSourceScreenEnum_boost,
  _$v1ContactEventsPostRequestSourceScreenEnum_ad,
  _$v1ContactEventsPostRequestSourceScreenEnum_seoPage,
]);

Serializer<V1ContactEventsPostRequestChannelEnum>
    _$v1ContactEventsPostRequestChannelEnumSerializer =
    _$V1ContactEventsPostRequestChannelEnumSerializer();
Serializer<V1ContactEventsPostRequestSourceScreenEnum>
    _$v1ContactEventsPostRequestSourceScreenEnumSerializer =
    _$V1ContactEventsPostRequestSourceScreenEnumSerializer();

class _$V1ContactEventsPostRequestChannelEnumSerializer
    implements PrimitiveSerializer<V1ContactEventsPostRequestChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PHONE': 'PHONE',
    'WHATSAPP': 'WHATSAPP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PHONE': 'PHONE',
    'WHATSAPP': 'WHATSAPP',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1ContactEventsPostRequestChannelEnum
  ];
  @override
  final String wireName = 'V1ContactEventsPostRequestChannelEnum';

  @override
  Object serialize(
          Serializers serializers, V1ContactEventsPostRequestChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ContactEventsPostRequestChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ContactEventsPostRequestChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ContactEventsPostRequestSourceScreenEnumSerializer
    implements PrimitiveSerializer<V1ContactEventsPostRequestSourceScreenEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'search': 'search',
    'profile': 'profile',
    'boost': 'boost',
    'ad': 'ad',
    'seoPage': 'seo_page',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'search': 'search',
    'profile': 'profile',
    'boost': 'boost',
    'ad': 'ad',
    'seo_page': 'seoPage',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1ContactEventsPostRequestSourceScreenEnum
  ];
  @override
  final String wireName = 'V1ContactEventsPostRequestSourceScreenEnum';

  @override
  Object serialize(Serializers serializers,
          V1ContactEventsPostRequestSourceScreenEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ContactEventsPostRequestSourceScreenEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ContactEventsPostRequestSourceScreenEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ContactEventsPostRequest extends V1ContactEventsPostRequest {
  @override
  final String providerId;
  @override
  final V1ContactEventsPostRequestChannelEnum channel;
  @override
  final String? categoryId;
  @override
  final V1ContactEventsPostRequestSourceScreenEnum? sourceScreen;

  factory _$V1ContactEventsPostRequest(
          [void Function(V1ContactEventsPostRequestBuilder)? updates]) =>
      (V1ContactEventsPostRequestBuilder()..update(updates))._build();

  _$V1ContactEventsPostRequest._(
      {required this.providerId,
      required this.channel,
      this.categoryId,
      this.sourceScreen})
      : super._();
  @override
  V1ContactEventsPostRequest rebuild(
          void Function(V1ContactEventsPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ContactEventsPostRequestBuilder toBuilder() =>
      V1ContactEventsPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ContactEventsPostRequest &&
        providerId == other.providerId &&
        channel == other.channel &&
        categoryId == other.categoryId &&
        sourceScreen == other.sourceScreen;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, providerId.hashCode);
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, sourceScreen.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1ContactEventsPostRequest')
          ..add('providerId', providerId)
          ..add('channel', channel)
          ..add('categoryId', categoryId)
          ..add('sourceScreen', sourceScreen))
        .toString();
  }
}

class V1ContactEventsPostRequestBuilder
    implements
        Builder<V1ContactEventsPostRequest, V1ContactEventsPostRequestBuilder> {
  _$V1ContactEventsPostRequest? _$v;

  String? _providerId;
  String? get providerId => _$this._providerId;
  set providerId(String? providerId) => _$this._providerId = providerId;

  V1ContactEventsPostRequestChannelEnum? _channel;
  V1ContactEventsPostRequestChannelEnum? get channel => _$this._channel;
  set channel(V1ContactEventsPostRequestChannelEnum? channel) =>
      _$this._channel = channel;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  V1ContactEventsPostRequestSourceScreenEnum? _sourceScreen;
  V1ContactEventsPostRequestSourceScreenEnum? get sourceScreen =>
      _$this._sourceScreen;
  set sourceScreen(V1ContactEventsPostRequestSourceScreenEnum? sourceScreen) =>
      _$this._sourceScreen = sourceScreen;

  V1ContactEventsPostRequestBuilder() {
    V1ContactEventsPostRequest._defaults(this);
  }

  V1ContactEventsPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _providerId = $v.providerId;
      _channel = $v.channel;
      _categoryId = $v.categoryId;
      _sourceScreen = $v.sourceScreen;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ContactEventsPostRequest other) {
    _$v = other as _$V1ContactEventsPostRequest;
  }

  @override
  void update(void Function(V1ContactEventsPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ContactEventsPostRequest build() => _build();

  _$V1ContactEventsPostRequest _build() {
    final _$result = _$v ??
        _$V1ContactEventsPostRequest._(
          providerId: BuiltValueNullFieldError.checkNotNull(
              providerId, r'V1ContactEventsPostRequest', 'providerId'),
          channel: BuiltValueNullFieldError.checkNotNull(
              channel, r'V1ContactEventsPostRequest', 'channel'),
          categoryId: categoryId,
          sourceScreen: sourceScreen,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

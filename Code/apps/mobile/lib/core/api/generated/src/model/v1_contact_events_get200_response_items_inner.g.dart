// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_contact_events_get200_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ContactEventsGet200ResponseItemsInnerChannelEnum
    _$v1ContactEventsGet200ResponseItemsInnerChannelEnum_PHONE =
    const V1ContactEventsGet200ResponseItemsInnerChannelEnum._('PHONE');
const V1ContactEventsGet200ResponseItemsInnerChannelEnum
    _$v1ContactEventsGet200ResponseItemsInnerChannelEnum_WHATSAPP =
    const V1ContactEventsGet200ResponseItemsInnerChannelEnum._('WHATSAPP');

V1ContactEventsGet200ResponseItemsInnerChannelEnum
    _$v1ContactEventsGet200ResponseItemsInnerChannelEnumValueOf(String name) {
  switch (name) {
    case 'PHONE':
      return _$v1ContactEventsGet200ResponseItemsInnerChannelEnum_PHONE;
    case 'WHATSAPP':
      return _$v1ContactEventsGet200ResponseItemsInnerChannelEnum_WHATSAPP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ContactEventsGet200ResponseItemsInnerChannelEnum>
    _$v1ContactEventsGet200ResponseItemsInnerChannelEnumValues = BuiltSet<
        V1ContactEventsGet200ResponseItemsInnerChannelEnum>(const <V1ContactEventsGet200ResponseItemsInnerChannelEnum>[
  _$v1ContactEventsGet200ResponseItemsInnerChannelEnum_PHONE,
  _$v1ContactEventsGet200ResponseItemsInnerChannelEnum_WHATSAPP,
]);

Serializer<V1ContactEventsGet200ResponseItemsInnerChannelEnum>
    _$v1ContactEventsGet200ResponseItemsInnerChannelEnumSerializer =
    _$V1ContactEventsGet200ResponseItemsInnerChannelEnumSerializer();

class _$V1ContactEventsGet200ResponseItemsInnerChannelEnumSerializer
    implements
        PrimitiveSerializer<
            V1ContactEventsGet200ResponseItemsInnerChannelEnum> {
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
    V1ContactEventsGet200ResponseItemsInnerChannelEnum
  ];
  @override
  final String wireName = 'V1ContactEventsGet200ResponseItemsInnerChannelEnum';

  @override
  Object serialize(Serializers serializers,
          V1ContactEventsGet200ResponseItemsInnerChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ContactEventsGet200ResponseItemsInnerChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ContactEventsGet200ResponseItemsInnerChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ContactEventsGet200ResponseItemsInner
    extends V1ContactEventsGet200ResponseItemsInner {
  @override
  final String id;
  @override
  final String providerId;
  @override
  final String slug;
  @override
  final String businessName;
  @override
  final String categoryName;
  @override
  final V1ContactEventsGet200ResponseItemsInnerChannelEnum channel;
  @override
  final DateTime contactedAt;
  @override
  final bool hasReview;

  factory _$V1ContactEventsGet200ResponseItemsInner(
          [void Function(V1ContactEventsGet200ResponseItemsInnerBuilder)?
              updates]) =>
      (V1ContactEventsGet200ResponseItemsInnerBuilder()..update(updates))
          ._build();

  _$V1ContactEventsGet200ResponseItemsInner._(
      {required this.id,
      required this.providerId,
      required this.slug,
      required this.businessName,
      required this.categoryName,
      required this.channel,
      required this.contactedAt,
      required this.hasReview})
      : super._();
  @override
  V1ContactEventsGet200ResponseItemsInner rebuild(
          void Function(V1ContactEventsGet200ResponseItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ContactEventsGet200ResponseItemsInnerBuilder toBuilder() =>
      V1ContactEventsGet200ResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ContactEventsGet200ResponseItemsInner &&
        id == other.id &&
        providerId == other.providerId &&
        slug == other.slug &&
        businessName == other.businessName &&
        categoryName == other.categoryName &&
        channel == other.channel &&
        contactedAt == other.contactedAt &&
        hasReview == other.hasReview;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, providerId.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, businessName.hashCode);
    _$hash = $jc(_$hash, categoryName.hashCode);
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, contactedAt.hashCode);
    _$hash = $jc(_$hash, hasReview.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ContactEventsGet200ResponseItemsInner')
          ..add('id', id)
          ..add('providerId', providerId)
          ..add('slug', slug)
          ..add('businessName', businessName)
          ..add('categoryName', categoryName)
          ..add('channel', channel)
          ..add('contactedAt', contactedAt)
          ..add('hasReview', hasReview))
        .toString();
  }
}

class V1ContactEventsGet200ResponseItemsInnerBuilder
    implements
        Builder<V1ContactEventsGet200ResponseItemsInner,
            V1ContactEventsGet200ResponseItemsInnerBuilder> {
  _$V1ContactEventsGet200ResponseItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _providerId;
  String? get providerId => _$this._providerId;
  set providerId(String? providerId) => _$this._providerId = providerId;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _businessName;
  String? get businessName => _$this._businessName;
  set businessName(String? businessName) => _$this._businessName = businessName;

  String? _categoryName;
  String? get categoryName => _$this._categoryName;
  set categoryName(String? categoryName) => _$this._categoryName = categoryName;

  V1ContactEventsGet200ResponseItemsInnerChannelEnum? _channel;
  V1ContactEventsGet200ResponseItemsInnerChannelEnum? get channel =>
      _$this._channel;
  set channel(V1ContactEventsGet200ResponseItemsInnerChannelEnum? channel) =>
      _$this._channel = channel;

  DateTime? _contactedAt;
  DateTime? get contactedAt => _$this._contactedAt;
  set contactedAt(DateTime? contactedAt) => _$this._contactedAt = contactedAt;

  bool? _hasReview;
  bool? get hasReview => _$this._hasReview;
  set hasReview(bool? hasReview) => _$this._hasReview = hasReview;

  V1ContactEventsGet200ResponseItemsInnerBuilder() {
    V1ContactEventsGet200ResponseItemsInner._defaults(this);
  }

  V1ContactEventsGet200ResponseItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _providerId = $v.providerId;
      _slug = $v.slug;
      _businessName = $v.businessName;
      _categoryName = $v.categoryName;
      _channel = $v.channel;
      _contactedAt = $v.contactedAt;
      _hasReview = $v.hasReview;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ContactEventsGet200ResponseItemsInner other) {
    _$v = other as _$V1ContactEventsGet200ResponseItemsInner;
  }

  @override
  void update(
      void Function(V1ContactEventsGet200ResponseItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ContactEventsGet200ResponseItemsInner build() => _build();

  _$V1ContactEventsGet200ResponseItemsInner _build() {
    final _$result = _$v ??
        _$V1ContactEventsGet200ResponseItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'V1ContactEventsGet200ResponseItemsInner', 'id'),
          providerId: BuiltValueNullFieldError.checkNotNull(providerId,
              r'V1ContactEventsGet200ResponseItemsInner', 'providerId'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'V1ContactEventsGet200ResponseItemsInner', 'slug'),
          businessName: BuiltValueNullFieldError.checkNotNull(businessName,
              r'V1ContactEventsGet200ResponseItemsInner', 'businessName'),
          categoryName: BuiltValueNullFieldError.checkNotNull(categoryName,
              r'V1ContactEventsGet200ResponseItemsInner', 'categoryName'),
          channel: BuiltValueNullFieldError.checkNotNull(
              channel, r'V1ContactEventsGet200ResponseItemsInner', 'channel'),
          contactedAt: BuiltValueNullFieldError.checkNotNull(contactedAt,
              r'V1ContactEventsGet200ResponseItemsInner', 'contactedAt'),
          hasReview: BuiltValueNullFieldError.checkNotNull(hasReview,
              r'V1ContactEventsGet200ResponseItemsInner', 'hasReview'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

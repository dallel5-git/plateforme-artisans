// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_profile_views_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ProfileViewsPostRequestSource_Enum
    _$v1ProfileViewsPostRequestSourceEnum_search =
    const V1ProfileViewsPostRequestSource_Enum._('search');
const V1ProfileViewsPostRequestSource_Enum
    _$v1ProfileViewsPostRequestSourceEnum_profile =
    const V1ProfileViewsPostRequestSource_Enum._('profile');
const V1ProfileViewsPostRequestSource_Enum
    _$v1ProfileViewsPostRequestSourceEnum_boost =
    const V1ProfileViewsPostRequestSource_Enum._('boost');
const V1ProfileViewsPostRequestSource_Enum
    _$v1ProfileViewsPostRequestSourceEnum_ad =
    const V1ProfileViewsPostRequestSource_Enum._('ad');
const V1ProfileViewsPostRequestSource_Enum
    _$v1ProfileViewsPostRequestSourceEnum_seoPage =
    const V1ProfileViewsPostRequestSource_Enum._('seoPage');

V1ProfileViewsPostRequestSource_Enum
    _$v1ProfileViewsPostRequestSourceEnumValueOf(String name) {
  switch (name) {
    case 'search':
      return _$v1ProfileViewsPostRequestSourceEnum_search;
    case 'profile':
      return _$v1ProfileViewsPostRequestSourceEnum_profile;
    case 'boost':
      return _$v1ProfileViewsPostRequestSourceEnum_boost;
    case 'ad':
      return _$v1ProfileViewsPostRequestSourceEnum_ad;
    case 'seoPage':
      return _$v1ProfileViewsPostRequestSourceEnum_seoPage;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProfileViewsPostRequestSource_Enum>
    _$v1ProfileViewsPostRequestSourceEnumValues = BuiltSet<
        V1ProfileViewsPostRequestSource_Enum>(const <V1ProfileViewsPostRequestSource_Enum>[
  _$v1ProfileViewsPostRequestSourceEnum_search,
  _$v1ProfileViewsPostRequestSourceEnum_profile,
  _$v1ProfileViewsPostRequestSourceEnum_boost,
  _$v1ProfileViewsPostRequestSourceEnum_ad,
  _$v1ProfileViewsPostRequestSourceEnum_seoPage,
]);

Serializer<V1ProfileViewsPostRequestSource_Enum>
    _$v1ProfileViewsPostRequestSourceEnumSerializer =
    _$V1ProfileViewsPostRequestSource_EnumSerializer();

class _$V1ProfileViewsPostRequestSource_EnumSerializer
    implements PrimitiveSerializer<V1ProfileViewsPostRequestSource_Enum> {
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
    V1ProfileViewsPostRequestSource_Enum
  ];
  @override
  final String wireName = 'V1ProfileViewsPostRequestSource_Enum';

  @override
  Object serialize(
          Serializers serializers, V1ProfileViewsPostRequestSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ProfileViewsPostRequestSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ProfileViewsPostRequestSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ProfileViewsPostRequest extends V1ProfileViewsPostRequest {
  @override
  final String providerId;
  @override
  final V1ProfileViewsPostRequestSource_Enum? source_;

  factory _$V1ProfileViewsPostRequest(
          [void Function(V1ProfileViewsPostRequestBuilder)? updates]) =>
      (V1ProfileViewsPostRequestBuilder()..update(updates))._build();

  _$V1ProfileViewsPostRequest._({required this.providerId, this.source_})
      : super._();
  @override
  V1ProfileViewsPostRequest rebuild(
          void Function(V1ProfileViewsPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProfileViewsPostRequestBuilder toBuilder() =>
      V1ProfileViewsPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProfileViewsPostRequest &&
        providerId == other.providerId &&
        source_ == other.source_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, providerId.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1ProfileViewsPostRequest')
          ..add('providerId', providerId)
          ..add('source_', source_))
        .toString();
  }
}

class V1ProfileViewsPostRequestBuilder
    implements
        Builder<V1ProfileViewsPostRequest, V1ProfileViewsPostRequestBuilder> {
  _$V1ProfileViewsPostRequest? _$v;

  String? _providerId;
  String? get providerId => _$this._providerId;
  set providerId(String? providerId) => _$this._providerId = providerId;

  V1ProfileViewsPostRequestSource_Enum? _source_;
  V1ProfileViewsPostRequestSource_Enum? get source_ => _$this._source_;
  set source_(V1ProfileViewsPostRequestSource_Enum? source_) =>
      _$this._source_ = source_;

  V1ProfileViewsPostRequestBuilder() {
    V1ProfileViewsPostRequest._defaults(this);
  }

  V1ProfileViewsPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _providerId = $v.providerId;
      _source_ = $v.source_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProfileViewsPostRequest other) {
    _$v = other as _$V1ProfileViewsPostRequest;
  }

  @override
  void update(void Function(V1ProfileViewsPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProfileViewsPostRequest build() => _build();

  _$V1ProfileViewsPostRequest _build() {
    final _$result = _$v ??
        _$V1ProfileViewsPostRequest._(
          providerId: BuiltValueNullFieldError.checkNotNull(
              providerId, r'V1ProfileViewsPostRequest', 'providerId'),
          source_: source_,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

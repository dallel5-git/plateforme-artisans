// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_media_id_process_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1MediaIdProcessPost200Response
    extends V1MediaIdProcessPost200Response {
  @override
  final String id;
  @override
  final String publicUrl;
  @override
  final String thumbUrl;
  @override
  final String cardUrl;
  @override
  final String fullUrl;
  @override
  final int width;
  @override
  final int height;

  factory _$V1MediaIdProcessPost200Response(
          [void Function(V1MediaIdProcessPost200ResponseBuilder)? updates]) =>
      (V1MediaIdProcessPost200ResponseBuilder()..update(updates))._build();

  _$V1MediaIdProcessPost200Response._(
      {required this.id,
      required this.publicUrl,
      required this.thumbUrl,
      required this.cardUrl,
      required this.fullUrl,
      required this.width,
      required this.height})
      : super._();
  @override
  V1MediaIdProcessPost200Response rebuild(
          void Function(V1MediaIdProcessPost200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1MediaIdProcessPost200ResponseBuilder toBuilder() =>
      V1MediaIdProcessPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1MediaIdProcessPost200Response &&
        id == other.id &&
        publicUrl == other.publicUrl &&
        thumbUrl == other.thumbUrl &&
        cardUrl == other.cardUrl &&
        fullUrl == other.fullUrl &&
        width == other.width &&
        height == other.height;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, publicUrl.hashCode);
    _$hash = $jc(_$hash, thumbUrl.hashCode);
    _$hash = $jc(_$hash, cardUrl.hashCode);
    _$hash = $jc(_$hash, fullUrl.hashCode);
    _$hash = $jc(_$hash, width.hashCode);
    _$hash = $jc(_$hash, height.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1MediaIdProcessPost200Response')
          ..add('id', id)
          ..add('publicUrl', publicUrl)
          ..add('thumbUrl', thumbUrl)
          ..add('cardUrl', cardUrl)
          ..add('fullUrl', fullUrl)
          ..add('width', width)
          ..add('height', height))
        .toString();
  }
}

class V1MediaIdProcessPost200ResponseBuilder
    implements
        Builder<V1MediaIdProcessPost200Response,
            V1MediaIdProcessPost200ResponseBuilder> {
  _$V1MediaIdProcessPost200Response? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _publicUrl;
  String? get publicUrl => _$this._publicUrl;
  set publicUrl(String? publicUrl) => _$this._publicUrl = publicUrl;

  String? _thumbUrl;
  String? get thumbUrl => _$this._thumbUrl;
  set thumbUrl(String? thumbUrl) => _$this._thumbUrl = thumbUrl;

  String? _cardUrl;
  String? get cardUrl => _$this._cardUrl;
  set cardUrl(String? cardUrl) => _$this._cardUrl = cardUrl;

  String? _fullUrl;
  String? get fullUrl => _$this._fullUrl;
  set fullUrl(String? fullUrl) => _$this._fullUrl = fullUrl;

  int? _width;
  int? get width => _$this._width;
  set width(int? width) => _$this._width = width;

  int? _height;
  int? get height => _$this._height;
  set height(int? height) => _$this._height = height;

  V1MediaIdProcessPost200ResponseBuilder() {
    V1MediaIdProcessPost200Response._defaults(this);
  }

  V1MediaIdProcessPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _publicUrl = $v.publicUrl;
      _thumbUrl = $v.thumbUrl;
      _cardUrl = $v.cardUrl;
      _fullUrl = $v.fullUrl;
      _width = $v.width;
      _height = $v.height;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1MediaIdProcessPost200Response other) {
    _$v = other as _$V1MediaIdProcessPost200Response;
  }

  @override
  void update(void Function(V1MediaIdProcessPost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1MediaIdProcessPost200Response build() => _build();

  _$V1MediaIdProcessPost200Response _build() {
    final _$result = _$v ??
        _$V1MediaIdProcessPost200Response._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'V1MediaIdProcessPost200Response', 'id'),
          publicUrl: BuiltValueNullFieldError.checkNotNull(
              publicUrl, r'V1MediaIdProcessPost200Response', 'publicUrl'),
          thumbUrl: BuiltValueNullFieldError.checkNotNull(
              thumbUrl, r'V1MediaIdProcessPost200Response', 'thumbUrl'),
          cardUrl: BuiltValueNullFieldError.checkNotNull(
              cardUrl, r'V1MediaIdProcessPost200Response', 'cardUrl'),
          fullUrl: BuiltValueNullFieldError.checkNotNull(
              fullUrl, r'V1MediaIdProcessPost200Response', 'fullUrl'),
          width: BuiltValueNullFieldError.checkNotNull(
              width, r'V1MediaIdProcessPost200Response', 'width'),
          height: BuiltValueNullFieldError.checkNotNull(
              height, r'V1MediaIdProcessPost200Response', 'height'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

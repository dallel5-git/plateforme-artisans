// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_slug_get200_response_gallery_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersSlugGet200ResponseGalleryInner
    extends V1ProvidersSlugGet200ResponseGalleryInner {
  @override
  final String id;
  @override
  final String url;
  @override
  final int width;
  @override
  final int height;
  @override
  final String blurhash;
  @override
  final String caption;
  @override
  final V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation category;

  factory _$V1ProvidersSlugGet200ResponseGalleryInner([
    void Function(V1ProvidersSlugGet200ResponseGalleryInnerBuilder)? updates,
  ]) => (V1ProvidersSlugGet200ResponseGalleryInnerBuilder()..update(updates))
      ._build();

  _$V1ProvidersSlugGet200ResponseGalleryInner._({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
    required this.blurhash,
    required this.caption,
    required this.category,
  }) : super._();
  @override
  V1ProvidersSlugGet200ResponseGalleryInner rebuild(
    void Function(V1ProvidersSlugGet200ResponseGalleryInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1ProvidersSlugGet200ResponseGalleryInnerBuilder toBuilder() =>
      V1ProvidersSlugGet200ResponseGalleryInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersSlugGet200ResponseGalleryInner &&
        id == other.id &&
        url == other.url &&
        width == other.width &&
        height == other.height &&
        blurhash == other.blurhash &&
        caption == other.caption &&
        category == other.category;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, width.hashCode);
    _$hash = $jc(_$hash, height.hashCode);
    _$hash = $jc(_$hash, blurhash.hashCode);
    _$hash = $jc(_$hash, caption.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersSlugGet200ResponseGalleryInner',
          )
          ..add('id', id)
          ..add('url', url)
          ..add('width', width)
          ..add('height', height)
          ..add('blurhash', blurhash)
          ..add('caption', caption)
          ..add('category', category))
        .toString();
  }
}

class V1ProvidersSlugGet200ResponseGalleryInnerBuilder
    implements
        Builder<
          V1ProvidersSlugGet200ResponseGalleryInner,
          V1ProvidersSlugGet200ResponseGalleryInnerBuilder
        > {
  _$V1ProvidersSlugGet200ResponseGalleryInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  int? _width;
  int? get width => _$this._width;
  set width(int? width) => _$this._width = width;

  int? _height;
  int? get height => _$this._height;
  set height(int? height) => _$this._height = height;

  String? _blurhash;
  String? get blurhash => _$this._blurhash;
  set blurhash(String? blurhash) => _$this._blurhash = blurhash;

  String? _caption;
  String? get caption => _$this._caption;
  set caption(String? caption) => _$this._caption = caption;

  V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegationBuilder? _category;
  V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegationBuilder
  get category => _$this._category ??=
      V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegationBuilder();
  set category(
    V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegationBuilder? category,
  ) => _$this._category = category;

  V1ProvidersSlugGet200ResponseGalleryInnerBuilder() {
    V1ProvidersSlugGet200ResponseGalleryInner._defaults(this);
  }

  V1ProvidersSlugGet200ResponseGalleryInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _url = $v.url;
      _width = $v.width;
      _height = $v.height;
      _blurhash = $v.blurhash;
      _caption = $v.caption;
      _category = $v.category.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersSlugGet200ResponseGalleryInner other) {
    _$v = other as _$V1ProvidersSlugGet200ResponseGalleryInner;
  }

  @override
  void update(
    void Function(V1ProvidersSlugGet200ResponseGalleryInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersSlugGet200ResponseGalleryInner build() => _build();

  _$V1ProvidersSlugGet200ResponseGalleryInner _build() {
    _$V1ProvidersSlugGet200ResponseGalleryInner _$result;
    try {
      _$result =
          _$v ??
          _$V1ProvidersSlugGet200ResponseGalleryInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'V1ProvidersSlugGet200ResponseGalleryInner',
              'id',
            ),
            url: BuiltValueNullFieldError.checkNotNull(
              url,
              r'V1ProvidersSlugGet200ResponseGalleryInner',
              'url',
            ),
            width: BuiltValueNullFieldError.checkNotNull(
              width,
              r'V1ProvidersSlugGet200ResponseGalleryInner',
              'width',
            ),
            height: BuiltValueNullFieldError.checkNotNull(
              height,
              r'V1ProvidersSlugGet200ResponseGalleryInner',
              'height',
            ),
            blurhash: BuiltValueNullFieldError.checkNotNull(
              blurhash,
              r'V1ProvidersSlugGet200ResponseGalleryInner',
              'blurhash',
            ),
            caption: BuiltValueNullFieldError.checkNotNull(
              caption,
              r'V1ProvidersSlugGet200ResponseGalleryInner',
              'caption',
            ),
            category: category.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'category';
        category.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'V1ProvidersSlugGet200ResponseGalleryInner',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

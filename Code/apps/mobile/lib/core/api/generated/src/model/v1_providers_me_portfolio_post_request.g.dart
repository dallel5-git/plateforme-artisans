// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_portfolio_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMePortfolioPostRequest
    extends V1ProvidersMePortfolioPostRequest {
  @override
  final String mediaId;
  @override
  final String? categoryId;
  @override
  final String? caption;

  factory _$V1ProvidersMePortfolioPostRequest(
          [void Function(V1ProvidersMePortfolioPostRequestBuilder)? updates]) =>
      (V1ProvidersMePortfolioPostRequestBuilder()..update(updates))._build();

  _$V1ProvidersMePortfolioPostRequest._(
      {required this.mediaId, this.categoryId, this.caption})
      : super._();
  @override
  V1ProvidersMePortfolioPostRequest rebuild(
          void Function(V1ProvidersMePortfolioPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMePortfolioPostRequestBuilder toBuilder() =>
      V1ProvidersMePortfolioPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMePortfolioPostRequest &&
        mediaId == other.mediaId &&
        categoryId == other.categoryId &&
        caption == other.caption;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mediaId.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, caption.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1ProvidersMePortfolioPostRequest')
          ..add('mediaId', mediaId)
          ..add('categoryId', categoryId)
          ..add('caption', caption))
        .toString();
  }
}

class V1ProvidersMePortfolioPostRequestBuilder
    implements
        Builder<V1ProvidersMePortfolioPostRequest,
            V1ProvidersMePortfolioPostRequestBuilder> {
  _$V1ProvidersMePortfolioPostRequest? _$v;

  String? _mediaId;
  String? get mediaId => _$this._mediaId;
  set mediaId(String? mediaId) => _$this._mediaId = mediaId;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _caption;
  String? get caption => _$this._caption;
  set caption(String? caption) => _$this._caption = caption;

  V1ProvidersMePortfolioPostRequestBuilder() {
    V1ProvidersMePortfolioPostRequest._defaults(this);
  }

  V1ProvidersMePortfolioPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mediaId = $v.mediaId;
      _categoryId = $v.categoryId;
      _caption = $v.caption;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMePortfolioPostRequest other) {
    _$v = other as _$V1ProvidersMePortfolioPostRequest;
  }

  @override
  void update(
      void Function(V1ProvidersMePortfolioPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMePortfolioPostRequest build() => _build();

  _$V1ProvidersMePortfolioPostRequest _build() {
    final _$result = _$v ??
        _$V1ProvidersMePortfolioPostRequest._(
          mediaId: BuiltValueNullFieldError.checkNotNull(
              mediaId, r'V1ProvidersMePortfolioPostRequest', 'mediaId'),
          categoryId: categoryId,
          caption: caption,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_portfolio_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMePortfolioPost200Response
    extends V1ProvidersMePortfolioPost200Response {
  @override
  final String id;
  @override
  final String mediaId;
  @override
  final String categoryId;
  @override
  final String caption;
  @override
  final int sortOrder;

  factory _$V1ProvidersMePortfolioPost200Response([
    void Function(V1ProvidersMePortfolioPost200ResponseBuilder)? updates,
  ]) => (V1ProvidersMePortfolioPost200ResponseBuilder()..update(updates))
      ._build();

  _$V1ProvidersMePortfolioPost200Response._({
    required this.id,
    required this.mediaId,
    required this.categoryId,
    required this.caption,
    required this.sortOrder,
  }) : super._();
  @override
  V1ProvidersMePortfolioPost200Response rebuild(
    void Function(V1ProvidersMePortfolioPost200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMePortfolioPost200ResponseBuilder toBuilder() =>
      V1ProvidersMePortfolioPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMePortfolioPost200Response &&
        id == other.id &&
        mediaId == other.mediaId &&
        categoryId == other.categoryId &&
        caption == other.caption &&
        sortOrder == other.sortOrder;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, mediaId.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, caption.hashCode);
    _$hash = $jc(_$hash, sortOrder.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersMePortfolioPost200Response',
          )
          ..add('id', id)
          ..add('mediaId', mediaId)
          ..add('categoryId', categoryId)
          ..add('caption', caption)
          ..add('sortOrder', sortOrder))
        .toString();
  }
}

class V1ProvidersMePortfolioPost200ResponseBuilder
    implements
        Builder<
          V1ProvidersMePortfolioPost200Response,
          V1ProvidersMePortfolioPost200ResponseBuilder
        > {
  _$V1ProvidersMePortfolioPost200Response? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _mediaId;
  String? get mediaId => _$this._mediaId;
  set mediaId(String? mediaId) => _$this._mediaId = mediaId;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _caption;
  String? get caption => _$this._caption;
  set caption(String? caption) => _$this._caption = caption;

  int? _sortOrder;
  int? get sortOrder => _$this._sortOrder;
  set sortOrder(int? sortOrder) => _$this._sortOrder = sortOrder;

  V1ProvidersMePortfolioPost200ResponseBuilder() {
    V1ProvidersMePortfolioPost200Response._defaults(this);
  }

  V1ProvidersMePortfolioPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _mediaId = $v.mediaId;
      _categoryId = $v.categoryId;
      _caption = $v.caption;
      _sortOrder = $v.sortOrder;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMePortfolioPost200Response other) {
    _$v = other as _$V1ProvidersMePortfolioPost200Response;
  }

  @override
  void update(
    void Function(V1ProvidersMePortfolioPost200ResponseBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMePortfolioPost200Response build() => _build();

  _$V1ProvidersMePortfolioPost200Response _build() {
    final _$result =
        _$v ??
        _$V1ProvidersMePortfolioPost200Response._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'V1ProvidersMePortfolioPost200Response',
            'id',
          ),
          mediaId: BuiltValueNullFieldError.checkNotNull(
            mediaId,
            r'V1ProvidersMePortfolioPost200Response',
            'mediaId',
          ),
          categoryId: BuiltValueNullFieldError.checkNotNull(
            categoryId,
            r'V1ProvidersMePortfolioPost200Response',
            'categoryId',
          ),
          caption: BuiltValueNullFieldError.checkNotNull(
            caption,
            r'V1ProvidersMePortfolioPost200Response',
            'caption',
          ),
          sortOrder: BuiltValueNullFieldError.checkNotNull(
            sortOrder,
            r'V1ProvidersMePortfolioPost200Response',
            'sortOrder',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

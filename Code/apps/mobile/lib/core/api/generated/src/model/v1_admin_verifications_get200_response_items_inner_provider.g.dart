// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_admin_verifications_get200_response_items_inner_provider.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1AdminVerificationsGet200ResponseItemsInnerProvider
    extends V1AdminVerificationsGet200ResponseItemsInnerProvider {
  @override
  final String id;
  @override
  final String businessName;
  @override
  final String slug;
  @override
  final String baseGovernorateId;
  @override
  final bool isVerified;

  factory _$V1AdminVerificationsGet200ResponseItemsInnerProvider(
          [void Function(
                  V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder)?
              updates]) =>
      (V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder()
            ..update(updates))
          ._build();

  _$V1AdminVerificationsGet200ResponseItemsInnerProvider._(
      {required this.id,
      required this.businessName,
      required this.slug,
      required this.baseGovernorateId,
      required this.isVerified})
      : super._();
  @override
  V1AdminVerificationsGet200ResponseItemsInnerProvider rebuild(
          void Function(
                  V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder toBuilder() =>
      V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AdminVerificationsGet200ResponseItemsInnerProvider &&
        id == other.id &&
        businessName == other.businessName &&
        slug == other.slug &&
        baseGovernorateId == other.baseGovernorateId &&
        isVerified == other.isVerified;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, businessName.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, baseGovernorateId.hashCode);
    _$hash = $jc(_$hash, isVerified.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1AdminVerificationsGet200ResponseItemsInnerProvider')
          ..add('id', id)
          ..add('businessName', businessName)
          ..add('slug', slug)
          ..add('baseGovernorateId', baseGovernorateId)
          ..add('isVerified', isVerified))
        .toString();
  }
}

class V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder
    implements
        Builder<V1AdminVerificationsGet200ResponseItemsInnerProvider,
            V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder> {
  _$V1AdminVerificationsGet200ResponseItemsInnerProvider? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _businessName;
  String? get businessName => _$this._businessName;
  set businessName(String? businessName) => _$this._businessName = businessName;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _baseGovernorateId;
  String? get baseGovernorateId => _$this._baseGovernorateId;
  set baseGovernorateId(String? baseGovernorateId) =>
      _$this._baseGovernorateId = baseGovernorateId;

  bool? _isVerified;
  bool? get isVerified => _$this._isVerified;
  set isVerified(bool? isVerified) => _$this._isVerified = isVerified;

  V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder() {
    V1AdminVerificationsGet200ResponseItemsInnerProvider._defaults(this);
  }

  V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _businessName = $v.businessName;
      _slug = $v.slug;
      _baseGovernorateId = $v.baseGovernorateId;
      _isVerified = $v.isVerified;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AdminVerificationsGet200ResponseItemsInnerProvider other) {
    _$v = other as _$V1AdminVerificationsGet200ResponseItemsInnerProvider;
  }

  @override
  void update(
      void Function(
              V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AdminVerificationsGet200ResponseItemsInnerProvider build() => _build();

  _$V1AdminVerificationsGet200ResponseItemsInnerProvider _build() {
    final _$result = _$v ??
        _$V1AdminVerificationsGet200ResponseItemsInnerProvider._(
          id: BuiltValueNullFieldError.checkNotNull(id,
              r'V1AdminVerificationsGet200ResponseItemsInnerProvider', 'id'),
          businessName: BuiltValueNullFieldError.checkNotNull(
              businessName,
              r'V1AdminVerificationsGet200ResponseItemsInnerProvider',
              'businessName'),
          slug: BuiltValueNullFieldError.checkNotNull(slug,
              r'V1AdminVerificationsGet200ResponseItemsInnerProvider', 'slug'),
          baseGovernorateId: BuiltValueNullFieldError.checkNotNull(
              baseGovernorateId,
              r'V1AdminVerificationsGet200ResponseItemsInnerProvider',
              'baseGovernorateId'),
          isVerified: BuiltValueNullFieldError.checkNotNull(
              isVerified,
              r'V1AdminVerificationsGet200ResponseItemsInnerProvider',
              'isVerified'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

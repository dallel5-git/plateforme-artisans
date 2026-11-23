// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_users_me_export_get200_response_provider_profile_categories_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1UsersMeExportGet200ResponseProviderProfileCategoriesInner
    extends V1UsersMeExportGet200ResponseProviderProfileCategoriesInner {
  @override
  final String id;
  @override
  final String nameFr;
  @override
  final String nameAr;
  @override
  final bool isPrimary;

  factory _$V1UsersMeExportGet200ResponseProviderProfileCategoriesInner(
          [void Function(
                  V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerBuilder)?
              updates]) =>
      (V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerBuilder()
            ..update(updates))
          ._build();

  _$V1UsersMeExportGet200ResponseProviderProfileCategoriesInner._(
      {required this.id,
      required this.nameFr,
      required this.nameAr,
      required this.isPrimary})
      : super._();
  @override
  V1UsersMeExportGet200ResponseProviderProfileCategoriesInner rebuild(
          void Function(
                  V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerBuilder
      toBuilder() =>
          V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerBuilder()
            ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is V1UsersMeExportGet200ResponseProviderProfileCategoriesInner &&
        id == other.id &&
        nameFr == other.nameFr &&
        nameAr == other.nameAr &&
        isPrimary == other.isPrimary;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nameFr.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, isPrimary.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1UsersMeExportGet200ResponseProviderProfileCategoriesInner')
          ..add('id', id)
          ..add('nameFr', nameFr)
          ..add('nameAr', nameAr)
          ..add('isPrimary', isPrimary))
        .toString();
  }
}

class V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerBuilder
    implements
        Builder<V1UsersMeExportGet200ResponseProviderProfileCategoriesInner,
            V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerBuilder> {
  _$V1UsersMeExportGet200ResponseProviderProfileCategoriesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _nameFr;
  String? get nameFr => _$this._nameFr;
  set nameFr(String? nameFr) => _$this._nameFr = nameFr;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  bool? _isPrimary;
  bool? get isPrimary => _$this._isPrimary;
  set isPrimary(bool? isPrimary) => _$this._isPrimary = isPrimary;

  V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerBuilder() {
    V1UsersMeExportGet200ResponseProviderProfileCategoriesInner._defaults(this);
  }

  V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerBuilder
      get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nameFr = $v.nameFr;
      _nameAr = $v.nameAr;
      _isPrimary = $v.isPrimary;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
      V1UsersMeExportGet200ResponseProviderProfileCategoriesInner other) {
    _$v =
        other as _$V1UsersMeExportGet200ResponseProviderProfileCategoriesInner;
  }

  @override
  void update(
      void Function(
              V1UsersMeExportGet200ResponseProviderProfileCategoriesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1UsersMeExportGet200ResponseProviderProfileCategoriesInner build() =>
      _build();

  _$V1UsersMeExportGet200ResponseProviderProfileCategoriesInner _build() {
    final _$result = _$v ??
        _$V1UsersMeExportGet200ResponseProviderProfileCategoriesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'V1UsersMeExportGet200ResponseProviderProfileCategoriesInner',
              'id'),
          nameFr: BuiltValueNullFieldError.checkNotNull(
              nameFr,
              r'V1UsersMeExportGet200ResponseProviderProfileCategoriesInner',
              'nameFr'),
          nameAr: BuiltValueNullFieldError.checkNotNull(
              nameAr,
              r'V1UsersMeExportGet200ResponseProviderProfileCategoriesInner',
              'nameAr'),
          isPrimary: BuiltValueNullFieldError.checkNotNull(
              isPrimary,
              r'V1UsersMeExportGet200ResponseProviderProfileCategoriesInner',
              'isPrimary'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

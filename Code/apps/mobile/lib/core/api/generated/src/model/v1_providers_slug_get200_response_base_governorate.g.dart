// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_slug_get200_response_base_governorate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersSlugGet200ResponseBaseGovernorate
    extends V1ProvidersSlugGet200ResponseBaseGovernorate {
  @override
  final String slug;
  @override
  final String nameFr;
  @override
  final String nameAr;

  factory _$V1ProvidersSlugGet200ResponseBaseGovernorate([
    void Function(V1ProvidersSlugGet200ResponseBaseGovernorateBuilder)? updates,
  ]) => (V1ProvidersSlugGet200ResponseBaseGovernorateBuilder()..update(updates))
      ._build();

  _$V1ProvidersSlugGet200ResponseBaseGovernorate._({
    required this.slug,
    required this.nameFr,
    required this.nameAr,
  }) : super._();
  @override
  V1ProvidersSlugGet200ResponseBaseGovernorate rebuild(
    void Function(V1ProvidersSlugGet200ResponseBaseGovernorateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1ProvidersSlugGet200ResponseBaseGovernorateBuilder toBuilder() =>
      V1ProvidersSlugGet200ResponseBaseGovernorateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersSlugGet200ResponseBaseGovernorate &&
        slug == other.slug &&
        nameFr == other.nameFr &&
        nameAr == other.nameAr;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, nameFr.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersSlugGet200ResponseBaseGovernorate',
          )
          ..add('slug', slug)
          ..add('nameFr', nameFr)
          ..add('nameAr', nameAr))
        .toString();
  }
}

class V1ProvidersSlugGet200ResponseBaseGovernorateBuilder
    implements
        Builder<
          V1ProvidersSlugGet200ResponseBaseGovernorate,
          V1ProvidersSlugGet200ResponseBaseGovernorateBuilder
        > {
  _$V1ProvidersSlugGet200ResponseBaseGovernorate? _$v;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _nameFr;
  String? get nameFr => _$this._nameFr;
  set nameFr(String? nameFr) => _$this._nameFr = nameFr;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  V1ProvidersSlugGet200ResponseBaseGovernorateBuilder() {
    V1ProvidersSlugGet200ResponseBaseGovernorate._defaults(this);
  }

  V1ProvidersSlugGet200ResponseBaseGovernorateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _slug = $v.slug;
      _nameFr = $v.nameFr;
      _nameAr = $v.nameAr;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersSlugGet200ResponseBaseGovernorate other) {
    _$v = other as _$V1ProvidersSlugGet200ResponseBaseGovernorate;
  }

  @override
  void update(
    void Function(V1ProvidersSlugGet200ResponseBaseGovernorateBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersSlugGet200ResponseBaseGovernorate build() => _build();

  _$V1ProvidersSlugGet200ResponseBaseGovernorate _build() {
    final _$result =
        _$v ??
        _$V1ProvidersSlugGet200ResponseBaseGovernorate._(
          slug: BuiltValueNullFieldError.checkNotNull(
            slug,
            r'V1ProvidersSlugGet200ResponseBaseGovernorate',
            'slug',
          ),
          nameFr: BuiltValueNullFieldError.checkNotNull(
            nameFr,
            r'V1ProvidersSlugGet200ResponseBaseGovernorate',
            'nameFr',
          ),
          nameAr: BuiltValueNullFieldError.checkNotNull(
            nameAr,
            r'V1ProvidersSlugGet200ResponseBaseGovernorate',
            'nameAr',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

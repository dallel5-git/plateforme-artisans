// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_tree_node_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CategoryTreeNodeInput extends CategoryTreeNodeInput {
  @override
  final String id;
  @override
  final String slug;
  @override
  final String nameFr;
  @override
  final String nameAr;
  @override
  final String descriptionFr;
  @override
  final String descriptionAr;
  @override
  final String iconKey;
  @override
  final String colorHex;
  @override
  final int sortOrder;
  @override
  final BuiltList<CategoryTreeNodeInput> children;

  factory _$CategoryTreeNodeInput([
    void Function(CategoryTreeNodeInputBuilder)? updates,
  ]) => (CategoryTreeNodeInputBuilder()..update(updates))._build();

  _$CategoryTreeNodeInput._({
    required this.id,
    required this.slug,
    required this.nameFr,
    required this.nameAr,
    required this.descriptionFr,
    required this.descriptionAr,
    required this.iconKey,
    required this.colorHex,
    required this.sortOrder,
    required this.children,
  }) : super._();
  @override
  CategoryTreeNodeInput rebuild(
    void Function(CategoryTreeNodeInputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CategoryTreeNodeInputBuilder toBuilder() =>
      CategoryTreeNodeInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CategoryTreeNodeInput &&
        id == other.id &&
        slug == other.slug &&
        nameFr == other.nameFr &&
        nameAr == other.nameAr &&
        descriptionFr == other.descriptionFr &&
        descriptionAr == other.descriptionAr &&
        iconKey == other.iconKey &&
        colorHex == other.colorHex &&
        sortOrder == other.sortOrder &&
        children == other.children;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, nameFr.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, descriptionFr.hashCode);
    _$hash = $jc(_$hash, descriptionAr.hashCode);
    _$hash = $jc(_$hash, iconKey.hashCode);
    _$hash = $jc(_$hash, colorHex.hashCode);
    _$hash = $jc(_$hash, sortOrder.hashCode);
    _$hash = $jc(_$hash, children.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CategoryTreeNodeInput')
          ..add('id', id)
          ..add('slug', slug)
          ..add('nameFr', nameFr)
          ..add('nameAr', nameAr)
          ..add('descriptionFr', descriptionFr)
          ..add('descriptionAr', descriptionAr)
          ..add('iconKey', iconKey)
          ..add('colorHex', colorHex)
          ..add('sortOrder', sortOrder)
          ..add('children', children))
        .toString();
  }
}

class CategoryTreeNodeInputBuilder
    implements Builder<CategoryTreeNodeInput, CategoryTreeNodeInputBuilder> {
  _$CategoryTreeNodeInput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _nameFr;
  String? get nameFr => _$this._nameFr;
  set nameFr(String? nameFr) => _$this._nameFr = nameFr;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  String? _descriptionFr;
  String? get descriptionFr => _$this._descriptionFr;
  set descriptionFr(String? descriptionFr) =>
      _$this._descriptionFr = descriptionFr;

  String? _descriptionAr;
  String? get descriptionAr => _$this._descriptionAr;
  set descriptionAr(String? descriptionAr) =>
      _$this._descriptionAr = descriptionAr;

  String? _iconKey;
  String? get iconKey => _$this._iconKey;
  set iconKey(String? iconKey) => _$this._iconKey = iconKey;

  String? _colorHex;
  String? get colorHex => _$this._colorHex;
  set colorHex(String? colorHex) => _$this._colorHex = colorHex;

  int? _sortOrder;
  int? get sortOrder => _$this._sortOrder;
  set sortOrder(int? sortOrder) => _$this._sortOrder = sortOrder;

  ListBuilder<CategoryTreeNodeInput>? _children;
  ListBuilder<CategoryTreeNodeInput> get children =>
      _$this._children ??= ListBuilder<CategoryTreeNodeInput>();
  set children(ListBuilder<CategoryTreeNodeInput>? children) =>
      _$this._children = children;

  CategoryTreeNodeInputBuilder() {
    CategoryTreeNodeInput._defaults(this);
  }

  CategoryTreeNodeInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _slug = $v.slug;
      _nameFr = $v.nameFr;
      _nameAr = $v.nameAr;
      _descriptionFr = $v.descriptionFr;
      _descriptionAr = $v.descriptionAr;
      _iconKey = $v.iconKey;
      _colorHex = $v.colorHex;
      _sortOrder = $v.sortOrder;
      _children = $v.children.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CategoryTreeNodeInput other) {
    _$v = other as _$CategoryTreeNodeInput;
  }

  @override
  void update(void Function(CategoryTreeNodeInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CategoryTreeNodeInput build() => _build();

  _$CategoryTreeNodeInput _build() {
    _$CategoryTreeNodeInput _$result;
    try {
      _$result =
          _$v ??
          _$CategoryTreeNodeInput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CategoryTreeNodeInput',
              'id',
            ),
            slug: BuiltValueNullFieldError.checkNotNull(
              slug,
              r'CategoryTreeNodeInput',
              'slug',
            ),
            nameFr: BuiltValueNullFieldError.checkNotNull(
              nameFr,
              r'CategoryTreeNodeInput',
              'nameFr',
            ),
            nameAr: BuiltValueNullFieldError.checkNotNull(
              nameAr,
              r'CategoryTreeNodeInput',
              'nameAr',
            ),
            descriptionFr: BuiltValueNullFieldError.checkNotNull(
              descriptionFr,
              r'CategoryTreeNodeInput',
              'descriptionFr',
            ),
            descriptionAr: BuiltValueNullFieldError.checkNotNull(
              descriptionAr,
              r'CategoryTreeNodeInput',
              'descriptionAr',
            ),
            iconKey: BuiltValueNullFieldError.checkNotNull(
              iconKey,
              r'CategoryTreeNodeInput',
              'iconKey',
            ),
            colorHex: BuiltValueNullFieldError.checkNotNull(
              colorHex,
              r'CategoryTreeNodeInput',
              'colorHex',
            ),
            sortOrder: BuiltValueNullFieldError.checkNotNull(
              sortOrder,
              r'CategoryTreeNodeInput',
              'sortOrder',
            ),
            children: children.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'children';
        children.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CategoryTreeNodeInput',
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

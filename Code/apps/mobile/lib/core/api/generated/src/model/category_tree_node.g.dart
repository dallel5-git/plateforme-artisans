// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_tree_node.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CategoryTreeNode extends CategoryTreeNode {
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
  final BuiltList<CategoryTreeNode> children;

  factory _$CategoryTreeNode(
          [void Function(CategoryTreeNodeBuilder)? updates]) =>
      (CategoryTreeNodeBuilder()..update(updates))._build();

  _$CategoryTreeNode._(
      {required this.id,
      required this.slug,
      required this.nameFr,
      required this.nameAr,
      required this.descriptionFr,
      required this.descriptionAr,
      required this.iconKey,
      required this.colorHex,
      required this.sortOrder,
      required this.children})
      : super._();
  @override
  CategoryTreeNode rebuild(void Function(CategoryTreeNodeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CategoryTreeNodeBuilder toBuilder() =>
      CategoryTreeNodeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CategoryTreeNode &&
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
    return (newBuiltValueToStringHelper(r'CategoryTreeNode')
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

class CategoryTreeNodeBuilder
    implements Builder<CategoryTreeNode, CategoryTreeNodeBuilder> {
  _$CategoryTreeNode? _$v;

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

  ListBuilder<CategoryTreeNode>? _children;
  ListBuilder<CategoryTreeNode> get children =>
      _$this._children ??= ListBuilder<CategoryTreeNode>();
  set children(ListBuilder<CategoryTreeNode>? children) =>
      _$this._children = children;

  CategoryTreeNodeBuilder() {
    CategoryTreeNode._defaults(this);
  }

  CategoryTreeNodeBuilder get _$this {
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
  void replace(CategoryTreeNode other) {
    _$v = other as _$CategoryTreeNode;
  }

  @override
  void update(void Function(CategoryTreeNodeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CategoryTreeNode build() => _build();

  _$CategoryTreeNode _build() {
    _$CategoryTreeNode _$result;
    try {
      _$result = _$v ??
          _$CategoryTreeNode._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CategoryTreeNode', 'id'),
            slug: BuiltValueNullFieldError.checkNotNull(
                slug, r'CategoryTreeNode', 'slug'),
            nameFr: BuiltValueNullFieldError.checkNotNull(
                nameFr, r'CategoryTreeNode', 'nameFr'),
            nameAr: BuiltValueNullFieldError.checkNotNull(
                nameAr, r'CategoryTreeNode', 'nameAr'),
            descriptionFr: BuiltValueNullFieldError.checkNotNull(
                descriptionFr, r'CategoryTreeNode', 'descriptionFr'),
            descriptionAr: BuiltValueNullFieldError.checkNotNull(
                descriptionAr, r'CategoryTreeNode', 'descriptionAr'),
            iconKey: BuiltValueNullFieldError.checkNotNull(
                iconKey, r'CategoryTreeNode', 'iconKey'),
            colorHex: BuiltValueNullFieldError.checkNotNull(
                colorHex, r'CategoryTreeNode', 'colorHex'),
            sortOrder: BuiltValueNullFieldError.checkNotNull(
                sortOrder, r'CategoryTreeNode', 'sortOrder'),
            children: children.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'children';
        children.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CategoryTreeNode', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

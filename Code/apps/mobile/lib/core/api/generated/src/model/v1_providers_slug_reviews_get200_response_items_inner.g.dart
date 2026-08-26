// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_slug_reviews_get200_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersSlugReviewsGet200ResponseItemsInner
    extends V1ProvidersSlugReviewsGet200ResponseItemsInner {
  @override
  final String id;
  @override
  final int rating;
  @override
  final String comment;
  @override
  final bool isVerifiedContact;
  @override
  final DateTime createdAt;
  @override
  final String authorDisplayName;

  factory _$V1ProvidersSlugReviewsGet200ResponseItemsInner(
          [void Function(V1ProvidersSlugReviewsGet200ResponseItemsInnerBuilder)?
              updates]) =>
      (V1ProvidersSlugReviewsGet200ResponseItemsInnerBuilder()..update(updates))
          ._build();

  _$V1ProvidersSlugReviewsGet200ResponseItemsInner._(
      {required this.id,
      required this.rating,
      required this.comment,
      required this.isVerifiedContact,
      required this.createdAt,
      required this.authorDisplayName})
      : super._();
  @override
  V1ProvidersSlugReviewsGet200ResponseItemsInner rebuild(
          void Function(V1ProvidersSlugReviewsGet200ResponseItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersSlugReviewsGet200ResponseItemsInnerBuilder toBuilder() =>
      V1ProvidersSlugReviewsGet200ResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersSlugReviewsGet200ResponseItemsInner &&
        id == other.id &&
        rating == other.rating &&
        comment == other.comment &&
        isVerifiedContact == other.isVerifiedContact &&
        createdAt == other.createdAt &&
        authorDisplayName == other.authorDisplayName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, isVerifiedContact.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, authorDisplayName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersSlugReviewsGet200ResponseItemsInner')
          ..add('id', id)
          ..add('rating', rating)
          ..add('comment', comment)
          ..add('isVerifiedContact', isVerifiedContact)
          ..add('createdAt', createdAt)
          ..add('authorDisplayName', authorDisplayName))
        .toString();
  }
}

class V1ProvidersSlugReviewsGet200ResponseItemsInnerBuilder
    implements
        Builder<V1ProvidersSlugReviewsGet200ResponseItemsInner,
            V1ProvidersSlugReviewsGet200ResponseItemsInnerBuilder> {
  _$V1ProvidersSlugReviewsGet200ResponseItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _rating;
  int? get rating => _$this._rating;
  set rating(int? rating) => _$this._rating = rating;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  bool? _isVerifiedContact;
  bool? get isVerifiedContact => _$this._isVerifiedContact;
  set isVerifiedContact(bool? isVerifiedContact) =>
      _$this._isVerifiedContact = isVerifiedContact;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _authorDisplayName;
  String? get authorDisplayName => _$this._authorDisplayName;
  set authorDisplayName(String? authorDisplayName) =>
      _$this._authorDisplayName = authorDisplayName;

  V1ProvidersSlugReviewsGet200ResponseItemsInnerBuilder() {
    V1ProvidersSlugReviewsGet200ResponseItemsInner._defaults(this);
  }

  V1ProvidersSlugReviewsGet200ResponseItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _rating = $v.rating;
      _comment = $v.comment;
      _isVerifiedContact = $v.isVerifiedContact;
      _createdAt = $v.createdAt;
      _authorDisplayName = $v.authorDisplayName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersSlugReviewsGet200ResponseItemsInner other) {
    _$v = other as _$V1ProvidersSlugReviewsGet200ResponseItemsInner;
  }

  @override
  void update(
      void Function(V1ProvidersSlugReviewsGet200ResponseItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersSlugReviewsGet200ResponseItemsInner build() => _build();

  _$V1ProvidersSlugReviewsGet200ResponseItemsInner _build() {
    final _$result = _$v ??
        _$V1ProvidersSlugReviewsGet200ResponseItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'V1ProvidersSlugReviewsGet200ResponseItemsInner', 'id'),
          rating: BuiltValueNullFieldError.checkNotNull(rating,
              r'V1ProvidersSlugReviewsGet200ResponseItemsInner', 'rating'),
          comment: BuiltValueNullFieldError.checkNotNull(comment,
              r'V1ProvidersSlugReviewsGet200ResponseItemsInner', 'comment'),
          isVerifiedContact: BuiltValueNullFieldError.checkNotNull(
              isVerifiedContact,
              r'V1ProvidersSlugReviewsGet200ResponseItemsInner',
              'isVerifiedContact'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'V1ProvidersSlugReviewsGet200ResponseItemsInner', 'createdAt'),
          authorDisplayName: BuiltValueNullFieldError.checkNotNull(
              authorDisplayName,
              r'V1ProvidersSlugReviewsGet200ResponseItemsInner',
              'authorDisplayName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

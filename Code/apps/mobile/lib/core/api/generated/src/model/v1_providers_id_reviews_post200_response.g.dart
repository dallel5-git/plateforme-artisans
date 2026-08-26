// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_id_reviews_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersIdReviewsPost200Response
    extends V1ProvidersIdReviewsPost200Response {
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

  factory _$V1ProvidersIdReviewsPost200Response(
          [void Function(V1ProvidersIdReviewsPost200ResponseBuilder)?
              updates]) =>
      (V1ProvidersIdReviewsPost200ResponseBuilder()..update(updates))._build();

  _$V1ProvidersIdReviewsPost200Response._(
      {required this.id,
      required this.rating,
      required this.comment,
      required this.isVerifiedContact,
      required this.createdAt})
      : super._();
  @override
  V1ProvidersIdReviewsPost200Response rebuild(
          void Function(V1ProvidersIdReviewsPost200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersIdReviewsPost200ResponseBuilder toBuilder() =>
      V1ProvidersIdReviewsPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersIdReviewsPost200Response &&
        id == other.id &&
        rating == other.rating &&
        comment == other.comment &&
        isVerifiedContact == other.isVerifiedContact &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, isVerifiedContact.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1ProvidersIdReviewsPost200Response')
          ..add('id', id)
          ..add('rating', rating)
          ..add('comment', comment)
          ..add('isVerifiedContact', isVerifiedContact)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class V1ProvidersIdReviewsPost200ResponseBuilder
    implements
        Builder<V1ProvidersIdReviewsPost200Response,
            V1ProvidersIdReviewsPost200ResponseBuilder> {
  _$V1ProvidersIdReviewsPost200Response? _$v;

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

  V1ProvidersIdReviewsPost200ResponseBuilder() {
    V1ProvidersIdReviewsPost200Response._defaults(this);
  }

  V1ProvidersIdReviewsPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _rating = $v.rating;
      _comment = $v.comment;
      _isVerifiedContact = $v.isVerifiedContact;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersIdReviewsPost200Response other) {
    _$v = other as _$V1ProvidersIdReviewsPost200Response;
  }

  @override
  void update(
      void Function(V1ProvidersIdReviewsPost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersIdReviewsPost200Response build() => _build();

  _$V1ProvidersIdReviewsPost200Response _build() {
    final _$result = _$v ??
        _$V1ProvidersIdReviewsPost200Response._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'V1ProvidersIdReviewsPost200Response', 'id'),
          rating: BuiltValueNullFieldError.checkNotNull(
              rating, r'V1ProvidersIdReviewsPost200Response', 'rating'),
          comment: BuiltValueNullFieldError.checkNotNull(
              comment, r'V1ProvidersIdReviewsPost200Response', 'comment'),
          isVerifiedContact: BuiltValueNullFieldError.checkNotNull(
              isVerifiedContact,
              r'V1ProvidersIdReviewsPost200Response',
              'isVerifiedContact'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'V1ProvidersIdReviewsPost200Response', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

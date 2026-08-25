// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_id_reviews_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersIdReviewsPostRequest
    extends V1ProvidersIdReviewsPostRequest {
  @override
  final int rating;
  @override
  final String? comment;

  factory _$V1ProvidersIdReviewsPostRequest(
          [void Function(V1ProvidersIdReviewsPostRequestBuilder)? updates]) =>
      (V1ProvidersIdReviewsPostRequestBuilder()..update(updates))._build();

  _$V1ProvidersIdReviewsPostRequest._({required this.rating, this.comment})
      : super._();
  @override
  V1ProvidersIdReviewsPostRequest rebuild(
          void Function(V1ProvidersIdReviewsPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersIdReviewsPostRequestBuilder toBuilder() =>
      V1ProvidersIdReviewsPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersIdReviewsPostRequest &&
        rating == other.rating &&
        comment == other.comment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1ProvidersIdReviewsPostRequest')
          ..add('rating', rating)
          ..add('comment', comment))
        .toString();
  }
}

class V1ProvidersIdReviewsPostRequestBuilder
    implements
        Builder<V1ProvidersIdReviewsPostRequest,
            V1ProvidersIdReviewsPostRequestBuilder> {
  _$V1ProvidersIdReviewsPostRequest? _$v;

  int? _rating;
  int? get rating => _$this._rating;
  set rating(int? rating) => _$this._rating = rating;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  V1ProvidersIdReviewsPostRequestBuilder() {
    V1ProvidersIdReviewsPostRequest._defaults(this);
  }

  V1ProvidersIdReviewsPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rating = $v.rating;
      _comment = $v.comment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersIdReviewsPostRequest other) {
    _$v = other as _$V1ProvidersIdReviewsPostRequest;
  }

  @override
  void update(void Function(V1ProvidersIdReviewsPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersIdReviewsPostRequest build() => _build();

  _$V1ProvidersIdReviewsPostRequest _build() {
    final _$result = _$v ??
        _$V1ProvidersIdReviewsPostRequest._(
          rating: BuiltValueNullFieldError.checkNotNull(
              rating, r'V1ProvidersIdReviewsPostRequest', 'rating'),
          comment: comment,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

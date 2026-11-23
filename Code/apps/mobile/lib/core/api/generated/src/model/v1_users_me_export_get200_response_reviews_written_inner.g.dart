// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_users_me_export_get200_response_reviews_written_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1UsersMeExportGet200ResponseReviewsWrittenInner
    extends V1UsersMeExportGet200ResponseReviewsWrittenInner {
  @override
  final String id;
  @override
  final String providerId;
  @override
  final String providerBusinessName;
  @override
  final int rating;
  @override
  final int ratingPunctuality;
  @override
  final int ratingQuality;
  @override
  final int ratingValue;
  @override
  final String comment;
  @override
  final String status;
  @override
  final bool isVerifiedContact;
  @override
  final DateTime createdAt;

  factory _$V1UsersMeExportGet200ResponseReviewsWrittenInner(
          [void Function(
                  V1UsersMeExportGet200ResponseReviewsWrittenInnerBuilder)?
              updates]) =>
      (V1UsersMeExportGet200ResponseReviewsWrittenInnerBuilder()
            ..update(updates))
          ._build();

  _$V1UsersMeExportGet200ResponseReviewsWrittenInner._(
      {required this.id,
      required this.providerId,
      required this.providerBusinessName,
      required this.rating,
      required this.ratingPunctuality,
      required this.ratingQuality,
      required this.ratingValue,
      required this.comment,
      required this.status,
      required this.isVerifiedContact,
      required this.createdAt})
      : super._();
  @override
  V1UsersMeExportGet200ResponseReviewsWrittenInner rebuild(
          void Function(V1UsersMeExportGet200ResponseReviewsWrittenInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1UsersMeExportGet200ResponseReviewsWrittenInnerBuilder toBuilder() =>
      V1UsersMeExportGet200ResponseReviewsWrittenInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1UsersMeExportGet200ResponseReviewsWrittenInner &&
        id == other.id &&
        providerId == other.providerId &&
        providerBusinessName == other.providerBusinessName &&
        rating == other.rating &&
        ratingPunctuality == other.ratingPunctuality &&
        ratingQuality == other.ratingQuality &&
        ratingValue == other.ratingValue &&
        comment == other.comment &&
        status == other.status &&
        isVerifiedContact == other.isVerifiedContact &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, providerId.hashCode);
    _$hash = $jc(_$hash, providerBusinessName.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, ratingPunctuality.hashCode);
    _$hash = $jc(_$hash, ratingQuality.hashCode);
    _$hash = $jc(_$hash, ratingValue.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, isVerifiedContact.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1UsersMeExportGet200ResponseReviewsWrittenInner')
          ..add('id', id)
          ..add('providerId', providerId)
          ..add('providerBusinessName', providerBusinessName)
          ..add('rating', rating)
          ..add('ratingPunctuality', ratingPunctuality)
          ..add('ratingQuality', ratingQuality)
          ..add('ratingValue', ratingValue)
          ..add('comment', comment)
          ..add('status', status)
          ..add('isVerifiedContact', isVerifiedContact)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class V1UsersMeExportGet200ResponseReviewsWrittenInnerBuilder
    implements
        Builder<V1UsersMeExportGet200ResponseReviewsWrittenInner,
            V1UsersMeExportGet200ResponseReviewsWrittenInnerBuilder> {
  _$V1UsersMeExportGet200ResponseReviewsWrittenInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _providerId;
  String? get providerId => _$this._providerId;
  set providerId(String? providerId) => _$this._providerId = providerId;

  String? _providerBusinessName;
  String? get providerBusinessName => _$this._providerBusinessName;
  set providerBusinessName(String? providerBusinessName) =>
      _$this._providerBusinessName = providerBusinessName;

  int? _rating;
  int? get rating => _$this._rating;
  set rating(int? rating) => _$this._rating = rating;

  int? _ratingPunctuality;
  int? get ratingPunctuality => _$this._ratingPunctuality;
  set ratingPunctuality(int? ratingPunctuality) =>
      _$this._ratingPunctuality = ratingPunctuality;

  int? _ratingQuality;
  int? get ratingQuality => _$this._ratingQuality;
  set ratingQuality(int? ratingQuality) =>
      _$this._ratingQuality = ratingQuality;

  int? _ratingValue;
  int? get ratingValue => _$this._ratingValue;
  set ratingValue(int? ratingValue) => _$this._ratingValue = ratingValue;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  bool? _isVerifiedContact;
  bool? get isVerifiedContact => _$this._isVerifiedContact;
  set isVerifiedContact(bool? isVerifiedContact) =>
      _$this._isVerifiedContact = isVerifiedContact;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  V1UsersMeExportGet200ResponseReviewsWrittenInnerBuilder() {
    V1UsersMeExportGet200ResponseReviewsWrittenInner._defaults(this);
  }

  V1UsersMeExportGet200ResponseReviewsWrittenInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _providerId = $v.providerId;
      _providerBusinessName = $v.providerBusinessName;
      _rating = $v.rating;
      _ratingPunctuality = $v.ratingPunctuality;
      _ratingQuality = $v.ratingQuality;
      _ratingValue = $v.ratingValue;
      _comment = $v.comment;
      _status = $v.status;
      _isVerifiedContact = $v.isVerifiedContact;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1UsersMeExportGet200ResponseReviewsWrittenInner other) {
    _$v = other as _$V1UsersMeExportGet200ResponseReviewsWrittenInner;
  }

  @override
  void update(
      void Function(V1UsersMeExportGet200ResponseReviewsWrittenInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1UsersMeExportGet200ResponseReviewsWrittenInner build() => _build();

  _$V1UsersMeExportGet200ResponseReviewsWrittenInner _build() {
    final _$result = _$v ??
        _$V1UsersMeExportGet200ResponseReviewsWrittenInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'V1UsersMeExportGet200ResponseReviewsWrittenInner', 'id'),
          providerId: BuiltValueNullFieldError.checkNotNull(
              providerId,
              r'V1UsersMeExportGet200ResponseReviewsWrittenInner',
              'providerId'),
          providerBusinessName: BuiltValueNullFieldError.checkNotNull(
              providerBusinessName,
              r'V1UsersMeExportGet200ResponseReviewsWrittenInner',
              'providerBusinessName'),
          rating: BuiltValueNullFieldError.checkNotNull(rating,
              r'V1UsersMeExportGet200ResponseReviewsWrittenInner', 'rating'),
          ratingPunctuality: BuiltValueNullFieldError.checkNotNull(
              ratingPunctuality,
              r'V1UsersMeExportGet200ResponseReviewsWrittenInner',
              'ratingPunctuality'),
          ratingQuality: BuiltValueNullFieldError.checkNotNull(
              ratingQuality,
              r'V1UsersMeExportGet200ResponseReviewsWrittenInner',
              'ratingQuality'),
          ratingValue: BuiltValueNullFieldError.checkNotNull(
              ratingValue,
              r'V1UsersMeExportGet200ResponseReviewsWrittenInner',
              'ratingValue'),
          comment: BuiltValueNullFieldError.checkNotNull(comment,
              r'V1UsersMeExportGet200ResponseReviewsWrittenInner', 'comment'),
          status: BuiltValueNullFieldError.checkNotNull(status,
              r'V1UsersMeExportGet200ResponseReviewsWrittenInner', 'status'),
          isVerifiedContact: BuiltValueNullFieldError.checkNotNull(
              isVerifiedContact,
              r'V1UsersMeExportGet200ResponseReviewsWrittenInner',
              'isVerifiedContact'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'V1UsersMeExportGet200ResponseReviewsWrittenInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

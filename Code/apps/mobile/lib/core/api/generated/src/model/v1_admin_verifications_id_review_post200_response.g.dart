// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_admin_verifications_id_review_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1AdminVerificationsIdReviewPost200ResponseStatusEnum
    _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_NOT_SUBMITTED =
    const V1AdminVerificationsIdReviewPost200ResponseStatusEnum._(
        'NOT_SUBMITTED');
const V1AdminVerificationsIdReviewPost200ResponseStatusEnum
    _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_PENDING =
    const V1AdminVerificationsIdReviewPost200ResponseStatusEnum._('PENDING');
const V1AdminVerificationsIdReviewPost200ResponseStatusEnum
    _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_MORE_INFO_REQUIRED =
    const V1AdminVerificationsIdReviewPost200ResponseStatusEnum._(
        'MORE_INFO_REQUIRED');
const V1AdminVerificationsIdReviewPost200ResponseStatusEnum
    _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_APPROVED =
    const V1AdminVerificationsIdReviewPost200ResponseStatusEnum._('APPROVED');
const V1AdminVerificationsIdReviewPost200ResponseStatusEnum
    _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_REJECTED =
    const V1AdminVerificationsIdReviewPost200ResponseStatusEnum._('REJECTED');

V1AdminVerificationsIdReviewPost200ResponseStatusEnum
    _$v1AdminVerificationsIdReviewPost200ResponseStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'NOT_SUBMITTED':
      return _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_NOT_SUBMITTED;
    case 'PENDING':
      return _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_PENDING;
    case 'MORE_INFO_REQUIRED':
      return _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_MORE_INFO_REQUIRED;
    case 'APPROVED':
      return _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_APPROVED;
    case 'REJECTED':
      return _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1AdminVerificationsIdReviewPost200ResponseStatusEnum>
    _$v1AdminVerificationsIdReviewPost200ResponseStatusEnumValues = BuiltSet<
        V1AdminVerificationsIdReviewPost200ResponseStatusEnum>(const <V1AdminVerificationsIdReviewPost200ResponseStatusEnum>[
  _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_NOT_SUBMITTED,
  _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_PENDING,
  _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_MORE_INFO_REQUIRED,
  _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_APPROVED,
  _$v1AdminVerificationsIdReviewPost200ResponseStatusEnum_REJECTED,
]);

Serializer<V1AdminVerificationsIdReviewPost200ResponseStatusEnum>
    _$v1AdminVerificationsIdReviewPost200ResponseStatusEnumSerializer =
    _$V1AdminVerificationsIdReviewPost200ResponseStatusEnumSerializer();

class _$V1AdminVerificationsIdReviewPost200ResponseStatusEnumSerializer
    implements
        PrimitiveSerializer<
            V1AdminVerificationsIdReviewPost200ResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_SUBMITTED': 'NOT_SUBMITTED',
    'PENDING': 'PENDING',
    'MORE_INFO_REQUIRED': 'MORE_INFO_REQUIRED',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_SUBMITTED': 'NOT_SUBMITTED',
    'PENDING': 'PENDING',
    'MORE_INFO_REQUIRED': 'MORE_INFO_REQUIRED',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1AdminVerificationsIdReviewPost200ResponseStatusEnum
  ];
  @override
  final String wireName =
      'V1AdminVerificationsIdReviewPost200ResponseStatusEnum';

  @override
  Object serialize(Serializers serializers,
          V1AdminVerificationsIdReviewPost200ResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1AdminVerificationsIdReviewPost200ResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1AdminVerificationsIdReviewPost200ResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1AdminVerificationsIdReviewPost200Response
    extends V1AdminVerificationsIdReviewPost200Response {
  @override
  final String id;
  @override
  final V1AdminVerificationsIdReviewPost200ResponseStatusEnum status;
  @override
  final DateTime reviewedAt;
  @override
  final String reviewedById;
  @override
  final bool isVerified;
  @override
  final String rejectionReason;
  @override
  final String internalNote;

  factory _$V1AdminVerificationsIdReviewPost200Response(
          [void Function(V1AdminVerificationsIdReviewPost200ResponseBuilder)?
              updates]) =>
      (V1AdminVerificationsIdReviewPost200ResponseBuilder()..update(updates))
          ._build();

  _$V1AdminVerificationsIdReviewPost200Response._(
      {required this.id,
      required this.status,
      required this.reviewedAt,
      required this.reviewedById,
      required this.isVerified,
      required this.rejectionReason,
      required this.internalNote})
      : super._();
  @override
  V1AdminVerificationsIdReviewPost200Response rebuild(
          void Function(V1AdminVerificationsIdReviewPost200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1AdminVerificationsIdReviewPost200ResponseBuilder toBuilder() =>
      V1AdminVerificationsIdReviewPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AdminVerificationsIdReviewPost200Response &&
        id == other.id &&
        status == other.status &&
        reviewedAt == other.reviewedAt &&
        reviewedById == other.reviewedById &&
        isVerified == other.isVerified &&
        rejectionReason == other.rejectionReason &&
        internalNote == other.internalNote;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, reviewedAt.hashCode);
    _$hash = $jc(_$hash, reviewedById.hashCode);
    _$hash = $jc(_$hash, isVerified.hashCode);
    _$hash = $jc(_$hash, rejectionReason.hashCode);
    _$hash = $jc(_$hash, internalNote.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1AdminVerificationsIdReviewPost200Response')
          ..add('id', id)
          ..add('status', status)
          ..add('reviewedAt', reviewedAt)
          ..add('reviewedById', reviewedById)
          ..add('isVerified', isVerified)
          ..add('rejectionReason', rejectionReason)
          ..add('internalNote', internalNote))
        .toString();
  }
}

class V1AdminVerificationsIdReviewPost200ResponseBuilder
    implements
        Builder<V1AdminVerificationsIdReviewPost200Response,
            V1AdminVerificationsIdReviewPost200ResponseBuilder> {
  _$V1AdminVerificationsIdReviewPost200Response? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  V1AdminVerificationsIdReviewPost200ResponseStatusEnum? _status;
  V1AdminVerificationsIdReviewPost200ResponseStatusEnum? get status =>
      _$this._status;
  set status(V1AdminVerificationsIdReviewPost200ResponseStatusEnum? status) =>
      _$this._status = status;

  DateTime? _reviewedAt;
  DateTime? get reviewedAt => _$this._reviewedAt;
  set reviewedAt(DateTime? reviewedAt) => _$this._reviewedAt = reviewedAt;

  String? _reviewedById;
  String? get reviewedById => _$this._reviewedById;
  set reviewedById(String? reviewedById) => _$this._reviewedById = reviewedById;

  bool? _isVerified;
  bool? get isVerified => _$this._isVerified;
  set isVerified(bool? isVerified) => _$this._isVerified = isVerified;

  String? _rejectionReason;
  String? get rejectionReason => _$this._rejectionReason;
  set rejectionReason(String? rejectionReason) =>
      _$this._rejectionReason = rejectionReason;

  String? _internalNote;
  String? get internalNote => _$this._internalNote;
  set internalNote(String? internalNote) => _$this._internalNote = internalNote;

  V1AdminVerificationsIdReviewPost200ResponseBuilder() {
    V1AdminVerificationsIdReviewPost200Response._defaults(this);
  }

  V1AdminVerificationsIdReviewPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _reviewedAt = $v.reviewedAt;
      _reviewedById = $v.reviewedById;
      _isVerified = $v.isVerified;
      _rejectionReason = $v.rejectionReason;
      _internalNote = $v.internalNote;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AdminVerificationsIdReviewPost200Response other) {
    _$v = other as _$V1AdminVerificationsIdReviewPost200Response;
  }

  @override
  void update(
      void Function(V1AdminVerificationsIdReviewPost200ResponseBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AdminVerificationsIdReviewPost200Response build() => _build();

  _$V1AdminVerificationsIdReviewPost200Response _build() {
    final _$result = _$v ??
        _$V1AdminVerificationsIdReviewPost200Response._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'V1AdminVerificationsIdReviewPost200Response', 'id'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'V1AdminVerificationsIdReviewPost200Response', 'status'),
          reviewedAt: BuiltValueNullFieldError.checkNotNull(reviewedAt,
              r'V1AdminVerificationsIdReviewPost200Response', 'reviewedAt'),
          reviewedById: BuiltValueNullFieldError.checkNotNull(reviewedById,
              r'V1AdminVerificationsIdReviewPost200Response', 'reviewedById'),
          isVerified: BuiltValueNullFieldError.checkNotNull(isVerified,
              r'V1AdminVerificationsIdReviewPost200Response', 'isVerified'),
          rejectionReason: BuiltValueNullFieldError.checkNotNull(
              rejectionReason,
              r'V1AdminVerificationsIdReviewPost200Response',
              'rejectionReason'),
          internalNote: BuiltValueNullFieldError.checkNotNull(internalNote,
              r'V1AdminVerificationsIdReviewPost200Response', 'internalNote'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

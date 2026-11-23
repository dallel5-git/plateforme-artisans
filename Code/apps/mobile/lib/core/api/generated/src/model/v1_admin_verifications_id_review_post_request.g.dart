// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_admin_verifications_id_review_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1AdminVerificationsIdReviewPostRequestStatusEnum
    _$v1AdminVerificationsIdReviewPostRequestStatusEnum_APPROVED =
    const V1AdminVerificationsIdReviewPostRequestStatusEnum._('APPROVED');
const V1AdminVerificationsIdReviewPostRequestStatusEnum
    _$v1AdminVerificationsIdReviewPostRequestStatusEnum_REJECTED =
    const V1AdminVerificationsIdReviewPostRequestStatusEnum._('REJECTED');
const V1AdminVerificationsIdReviewPostRequestStatusEnum
    _$v1AdminVerificationsIdReviewPostRequestStatusEnum_MORE_INFO_REQUIRED =
    const V1AdminVerificationsIdReviewPostRequestStatusEnum._(
        'MORE_INFO_REQUIRED');

V1AdminVerificationsIdReviewPostRequestStatusEnum
    _$v1AdminVerificationsIdReviewPostRequestStatusEnumValueOf(String name) {
  switch (name) {
    case 'APPROVED':
      return _$v1AdminVerificationsIdReviewPostRequestStatusEnum_APPROVED;
    case 'REJECTED':
      return _$v1AdminVerificationsIdReviewPostRequestStatusEnum_REJECTED;
    case 'MORE_INFO_REQUIRED':
      return _$v1AdminVerificationsIdReviewPostRequestStatusEnum_MORE_INFO_REQUIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1AdminVerificationsIdReviewPostRequestStatusEnum>
    _$v1AdminVerificationsIdReviewPostRequestStatusEnumValues = BuiltSet<
        V1AdminVerificationsIdReviewPostRequestStatusEnum>(const <V1AdminVerificationsIdReviewPostRequestStatusEnum>[
  _$v1AdminVerificationsIdReviewPostRequestStatusEnum_APPROVED,
  _$v1AdminVerificationsIdReviewPostRequestStatusEnum_REJECTED,
  _$v1AdminVerificationsIdReviewPostRequestStatusEnum_MORE_INFO_REQUIRED,
]);

Serializer<V1AdminVerificationsIdReviewPostRequestStatusEnum>
    _$v1AdminVerificationsIdReviewPostRequestStatusEnumSerializer =
    _$V1AdminVerificationsIdReviewPostRequestStatusEnumSerializer();

class _$V1AdminVerificationsIdReviewPostRequestStatusEnumSerializer
    implements
        PrimitiveSerializer<V1AdminVerificationsIdReviewPostRequestStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'MORE_INFO_REQUIRED': 'MORE_INFO_REQUIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'MORE_INFO_REQUIRED': 'MORE_INFO_REQUIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    V1AdminVerificationsIdReviewPostRequestStatusEnum
  ];
  @override
  final String wireName = 'V1AdminVerificationsIdReviewPostRequestStatusEnum';

  @override
  Object serialize(Serializers serializers,
          V1AdminVerificationsIdReviewPostRequestStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1AdminVerificationsIdReviewPostRequestStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1AdminVerificationsIdReviewPostRequestStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1AdminVerificationsIdReviewPostRequest
    extends V1AdminVerificationsIdReviewPostRequest {
  @override
  final V1AdminVerificationsIdReviewPostRequestStatusEnum status;
  @override
  final String? rejectionReason;
  @override
  final String? internalNote;

  factory _$V1AdminVerificationsIdReviewPostRequest(
          [void Function(V1AdminVerificationsIdReviewPostRequestBuilder)?
              updates]) =>
      (V1AdminVerificationsIdReviewPostRequestBuilder()..update(updates))
          ._build();

  _$V1AdminVerificationsIdReviewPostRequest._(
      {required this.status, this.rejectionReason, this.internalNote})
      : super._();
  @override
  V1AdminVerificationsIdReviewPostRequest rebuild(
          void Function(V1AdminVerificationsIdReviewPostRequestBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1AdminVerificationsIdReviewPostRequestBuilder toBuilder() =>
      V1AdminVerificationsIdReviewPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AdminVerificationsIdReviewPostRequest &&
        status == other.status &&
        rejectionReason == other.rejectionReason &&
        internalNote == other.internalNote;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, rejectionReason.hashCode);
    _$hash = $jc(_$hash, internalNote.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1AdminVerificationsIdReviewPostRequest')
          ..add('status', status)
          ..add('rejectionReason', rejectionReason)
          ..add('internalNote', internalNote))
        .toString();
  }
}

class V1AdminVerificationsIdReviewPostRequestBuilder
    implements
        Builder<V1AdminVerificationsIdReviewPostRequest,
            V1AdminVerificationsIdReviewPostRequestBuilder> {
  _$V1AdminVerificationsIdReviewPostRequest? _$v;

  V1AdminVerificationsIdReviewPostRequestStatusEnum? _status;
  V1AdminVerificationsIdReviewPostRequestStatusEnum? get status =>
      _$this._status;
  set status(V1AdminVerificationsIdReviewPostRequestStatusEnum? status) =>
      _$this._status = status;

  String? _rejectionReason;
  String? get rejectionReason => _$this._rejectionReason;
  set rejectionReason(String? rejectionReason) =>
      _$this._rejectionReason = rejectionReason;

  String? _internalNote;
  String? get internalNote => _$this._internalNote;
  set internalNote(String? internalNote) => _$this._internalNote = internalNote;

  V1AdminVerificationsIdReviewPostRequestBuilder() {
    V1AdminVerificationsIdReviewPostRequest._defaults(this);
  }

  V1AdminVerificationsIdReviewPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _rejectionReason = $v.rejectionReason;
      _internalNote = $v.internalNote;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AdminVerificationsIdReviewPostRequest other) {
    _$v = other as _$V1AdminVerificationsIdReviewPostRequest;
  }

  @override
  void update(
      void Function(V1AdminVerificationsIdReviewPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AdminVerificationsIdReviewPostRequest build() => _build();

  _$V1AdminVerificationsIdReviewPostRequest _build() {
    final _$result = _$v ??
        _$V1AdminVerificationsIdReviewPostRequest._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'V1AdminVerificationsIdReviewPostRequest', 'status'),
          rejectionReason: rejectionReason,
          internalNote: internalNote,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

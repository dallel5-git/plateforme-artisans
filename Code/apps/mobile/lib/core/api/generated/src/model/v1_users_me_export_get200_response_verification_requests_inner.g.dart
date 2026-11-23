// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_users_me_export_get200_response_verification_requests_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1UsersMeExportGet200ResponseVerificationRequestsInner
    extends V1UsersMeExportGet200ResponseVerificationRequestsInner {
  @override
  final String id;
  @override
  final String status;
  @override
  final DateTime submittedAt;
  @override
  final DateTime reviewedAt;
  @override
  final String rejectionReason;
  @override
  final BuiltList<String> documentTypes;

  factory _$V1UsersMeExportGet200ResponseVerificationRequestsInner(
          [void Function(
                  V1UsersMeExportGet200ResponseVerificationRequestsInnerBuilder)?
              updates]) =>
      (V1UsersMeExportGet200ResponseVerificationRequestsInnerBuilder()
            ..update(updates))
          ._build();

  _$V1UsersMeExportGet200ResponseVerificationRequestsInner._(
      {required this.id,
      required this.status,
      required this.submittedAt,
      required this.reviewedAt,
      required this.rejectionReason,
      required this.documentTypes})
      : super._();
  @override
  V1UsersMeExportGet200ResponseVerificationRequestsInner rebuild(
          void Function(
                  V1UsersMeExportGet200ResponseVerificationRequestsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1UsersMeExportGet200ResponseVerificationRequestsInnerBuilder toBuilder() =>
      V1UsersMeExportGet200ResponseVerificationRequestsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1UsersMeExportGet200ResponseVerificationRequestsInner &&
        id == other.id &&
        status == other.status &&
        submittedAt == other.submittedAt &&
        reviewedAt == other.reviewedAt &&
        rejectionReason == other.rejectionReason &&
        documentTypes == other.documentTypes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, reviewedAt.hashCode);
    _$hash = $jc(_$hash, rejectionReason.hashCode);
    _$hash = $jc(_$hash, documentTypes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1UsersMeExportGet200ResponseVerificationRequestsInner')
          ..add('id', id)
          ..add('status', status)
          ..add('submittedAt', submittedAt)
          ..add('reviewedAt', reviewedAt)
          ..add('rejectionReason', rejectionReason)
          ..add('documentTypes', documentTypes))
        .toString();
  }
}

class V1UsersMeExportGet200ResponseVerificationRequestsInnerBuilder
    implements
        Builder<V1UsersMeExportGet200ResponseVerificationRequestsInner,
            V1UsersMeExportGet200ResponseVerificationRequestsInnerBuilder> {
  _$V1UsersMeExportGet200ResponseVerificationRequestsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  DateTime? _reviewedAt;
  DateTime? get reviewedAt => _$this._reviewedAt;
  set reviewedAt(DateTime? reviewedAt) => _$this._reviewedAt = reviewedAt;

  String? _rejectionReason;
  String? get rejectionReason => _$this._rejectionReason;
  set rejectionReason(String? rejectionReason) =>
      _$this._rejectionReason = rejectionReason;

  ListBuilder<String>? _documentTypes;
  ListBuilder<String> get documentTypes =>
      _$this._documentTypes ??= ListBuilder<String>();
  set documentTypes(ListBuilder<String>? documentTypes) =>
      _$this._documentTypes = documentTypes;

  V1UsersMeExportGet200ResponseVerificationRequestsInnerBuilder() {
    V1UsersMeExportGet200ResponseVerificationRequestsInner._defaults(this);
  }

  V1UsersMeExportGet200ResponseVerificationRequestsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _submittedAt = $v.submittedAt;
      _reviewedAt = $v.reviewedAt;
      _rejectionReason = $v.rejectionReason;
      _documentTypes = $v.documentTypes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1UsersMeExportGet200ResponseVerificationRequestsInner other) {
    _$v = other as _$V1UsersMeExportGet200ResponseVerificationRequestsInner;
  }

  @override
  void update(
      void Function(
              V1UsersMeExportGet200ResponseVerificationRequestsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1UsersMeExportGet200ResponseVerificationRequestsInner build() => _build();

  _$V1UsersMeExportGet200ResponseVerificationRequestsInner _build() {
    _$V1UsersMeExportGet200ResponseVerificationRequestsInner _$result;
    try {
      _$result = _$v ??
          _$V1UsersMeExportGet200ResponseVerificationRequestsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id,
                r'V1UsersMeExportGet200ResponseVerificationRequestsInner',
                'id'),
            status: BuiltValueNullFieldError.checkNotNull(
                status,
                r'V1UsersMeExportGet200ResponseVerificationRequestsInner',
                'status'),
            submittedAt: BuiltValueNullFieldError.checkNotNull(
                submittedAt,
                r'V1UsersMeExportGet200ResponseVerificationRequestsInner',
                'submittedAt'),
            reviewedAt: BuiltValueNullFieldError.checkNotNull(
                reviewedAt,
                r'V1UsersMeExportGet200ResponseVerificationRequestsInner',
                'reviewedAt'),
            rejectionReason: BuiltValueNullFieldError.checkNotNull(
                rejectionReason,
                r'V1UsersMeExportGet200ResponseVerificationRequestsInner',
                'rejectionReason'),
            documentTypes: documentTypes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'documentTypes';
        documentTypes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1UsersMeExportGet200ResponseVerificationRequestsInner',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

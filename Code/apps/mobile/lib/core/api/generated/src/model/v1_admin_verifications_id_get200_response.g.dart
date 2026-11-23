// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_admin_verifications_id_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1AdminVerificationsIdGet200ResponseStatusEnum
    _$v1AdminVerificationsIdGet200ResponseStatusEnum_NOT_SUBMITTED =
    const V1AdminVerificationsIdGet200ResponseStatusEnum._('NOT_SUBMITTED');
const V1AdminVerificationsIdGet200ResponseStatusEnum
    _$v1AdminVerificationsIdGet200ResponseStatusEnum_PENDING =
    const V1AdminVerificationsIdGet200ResponseStatusEnum._('PENDING');
const V1AdminVerificationsIdGet200ResponseStatusEnum
    _$v1AdminVerificationsIdGet200ResponseStatusEnum_MORE_INFO_REQUIRED =
    const V1AdminVerificationsIdGet200ResponseStatusEnum._(
        'MORE_INFO_REQUIRED');
const V1AdminVerificationsIdGet200ResponseStatusEnum
    _$v1AdminVerificationsIdGet200ResponseStatusEnum_APPROVED =
    const V1AdminVerificationsIdGet200ResponseStatusEnum._('APPROVED');
const V1AdminVerificationsIdGet200ResponseStatusEnum
    _$v1AdminVerificationsIdGet200ResponseStatusEnum_REJECTED =
    const V1AdminVerificationsIdGet200ResponseStatusEnum._('REJECTED');

V1AdminVerificationsIdGet200ResponseStatusEnum
    _$v1AdminVerificationsIdGet200ResponseStatusEnumValueOf(String name) {
  switch (name) {
    case 'NOT_SUBMITTED':
      return _$v1AdminVerificationsIdGet200ResponseStatusEnum_NOT_SUBMITTED;
    case 'PENDING':
      return _$v1AdminVerificationsIdGet200ResponseStatusEnum_PENDING;
    case 'MORE_INFO_REQUIRED':
      return _$v1AdminVerificationsIdGet200ResponseStatusEnum_MORE_INFO_REQUIRED;
    case 'APPROVED':
      return _$v1AdminVerificationsIdGet200ResponseStatusEnum_APPROVED;
    case 'REJECTED':
      return _$v1AdminVerificationsIdGet200ResponseStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1AdminVerificationsIdGet200ResponseStatusEnum>
    _$v1AdminVerificationsIdGet200ResponseStatusEnumValues = BuiltSet<
        V1AdminVerificationsIdGet200ResponseStatusEnum>(const <V1AdminVerificationsIdGet200ResponseStatusEnum>[
  _$v1AdminVerificationsIdGet200ResponseStatusEnum_NOT_SUBMITTED,
  _$v1AdminVerificationsIdGet200ResponseStatusEnum_PENDING,
  _$v1AdminVerificationsIdGet200ResponseStatusEnum_MORE_INFO_REQUIRED,
  _$v1AdminVerificationsIdGet200ResponseStatusEnum_APPROVED,
  _$v1AdminVerificationsIdGet200ResponseStatusEnum_REJECTED,
]);

Serializer<V1AdminVerificationsIdGet200ResponseStatusEnum>
    _$v1AdminVerificationsIdGet200ResponseStatusEnumSerializer =
    _$V1AdminVerificationsIdGet200ResponseStatusEnumSerializer();

class _$V1AdminVerificationsIdGet200ResponseStatusEnumSerializer
    implements
        PrimitiveSerializer<V1AdminVerificationsIdGet200ResponseStatusEnum> {
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
    V1AdminVerificationsIdGet200ResponseStatusEnum
  ];
  @override
  final String wireName = 'V1AdminVerificationsIdGet200ResponseStatusEnum';

  @override
  Object serialize(Serializers serializers,
          V1AdminVerificationsIdGet200ResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1AdminVerificationsIdGet200ResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1AdminVerificationsIdGet200ResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1AdminVerificationsIdGet200Response
    extends V1AdminVerificationsIdGet200Response {
  @override
  final String id;
  @override
  final String providerId;
  @override
  final V1AdminVerificationsIdGet200ResponseProvider provider;
  @override
  final String fullNameOnId;
  @override
  final V1AdminVerificationsIdGet200ResponseStatusEnum status;
  @override
  final DateTime submittedAt;
  @override
  final DateTime reviewedAt;
  @override
  final V1AdminVerificationsIdGet200ResponseReviewedBy reviewedBy;
  @override
  final String rejectionReason;
  @override
  final String internalNote;
  @override
  final DateTime? expiresAt;
  @override
  final BuiltList<V1AdminVerificationsIdGet200ResponseDocumentsInner> documents;

  factory _$V1AdminVerificationsIdGet200Response(
          [void Function(V1AdminVerificationsIdGet200ResponseBuilder)?
              updates]) =>
      (V1AdminVerificationsIdGet200ResponseBuilder()..update(updates))._build();

  _$V1AdminVerificationsIdGet200Response._(
      {required this.id,
      required this.providerId,
      required this.provider,
      required this.fullNameOnId,
      required this.status,
      required this.submittedAt,
      required this.reviewedAt,
      required this.reviewedBy,
      required this.rejectionReason,
      required this.internalNote,
      this.expiresAt,
      required this.documents})
      : super._();
  @override
  V1AdminVerificationsIdGet200Response rebuild(
          void Function(V1AdminVerificationsIdGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1AdminVerificationsIdGet200ResponseBuilder toBuilder() =>
      V1AdminVerificationsIdGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AdminVerificationsIdGet200Response &&
        id == other.id &&
        providerId == other.providerId &&
        provider == other.provider &&
        fullNameOnId == other.fullNameOnId &&
        status == other.status &&
        submittedAt == other.submittedAt &&
        reviewedAt == other.reviewedAt &&
        reviewedBy == other.reviewedBy &&
        rejectionReason == other.rejectionReason &&
        internalNote == other.internalNote &&
        expiresAt == other.expiresAt &&
        documents == other.documents;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, providerId.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, fullNameOnId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, reviewedAt.hashCode);
    _$hash = $jc(_$hash, reviewedBy.hashCode);
    _$hash = $jc(_$hash, rejectionReason.hashCode);
    _$hash = $jc(_$hash, internalNote.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, documents.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1AdminVerificationsIdGet200Response')
          ..add('id', id)
          ..add('providerId', providerId)
          ..add('provider', provider)
          ..add('fullNameOnId', fullNameOnId)
          ..add('status', status)
          ..add('submittedAt', submittedAt)
          ..add('reviewedAt', reviewedAt)
          ..add('reviewedBy', reviewedBy)
          ..add('rejectionReason', rejectionReason)
          ..add('internalNote', internalNote)
          ..add('expiresAt', expiresAt)
          ..add('documents', documents))
        .toString();
  }
}

class V1AdminVerificationsIdGet200ResponseBuilder
    implements
        Builder<V1AdminVerificationsIdGet200Response,
            V1AdminVerificationsIdGet200ResponseBuilder> {
  _$V1AdminVerificationsIdGet200Response? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _providerId;
  String? get providerId => _$this._providerId;
  set providerId(String? providerId) => _$this._providerId = providerId;

  V1AdminVerificationsIdGet200ResponseProviderBuilder? _provider;
  V1AdminVerificationsIdGet200ResponseProviderBuilder get provider =>
      _$this._provider ??=
          V1AdminVerificationsIdGet200ResponseProviderBuilder();
  set provider(V1AdminVerificationsIdGet200ResponseProviderBuilder? provider) =>
      _$this._provider = provider;

  String? _fullNameOnId;
  String? get fullNameOnId => _$this._fullNameOnId;
  set fullNameOnId(String? fullNameOnId) => _$this._fullNameOnId = fullNameOnId;

  V1AdminVerificationsIdGet200ResponseStatusEnum? _status;
  V1AdminVerificationsIdGet200ResponseStatusEnum? get status => _$this._status;
  set status(V1AdminVerificationsIdGet200ResponseStatusEnum? status) =>
      _$this._status = status;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  DateTime? _reviewedAt;
  DateTime? get reviewedAt => _$this._reviewedAt;
  set reviewedAt(DateTime? reviewedAt) => _$this._reviewedAt = reviewedAt;

  V1AdminVerificationsIdGet200ResponseReviewedByBuilder? _reviewedBy;
  V1AdminVerificationsIdGet200ResponseReviewedByBuilder get reviewedBy =>
      _$this._reviewedBy ??=
          V1AdminVerificationsIdGet200ResponseReviewedByBuilder();
  set reviewedBy(
          V1AdminVerificationsIdGet200ResponseReviewedByBuilder? reviewedBy) =>
      _$this._reviewedBy = reviewedBy;

  String? _rejectionReason;
  String? get rejectionReason => _$this._rejectionReason;
  set rejectionReason(String? rejectionReason) =>
      _$this._rejectionReason = rejectionReason;

  String? _internalNote;
  String? get internalNote => _$this._internalNote;
  set internalNote(String? internalNote) => _$this._internalNote = internalNote;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  ListBuilder<V1AdminVerificationsIdGet200ResponseDocumentsInner>? _documents;
  ListBuilder<V1AdminVerificationsIdGet200ResponseDocumentsInner>
      get documents => _$this._documents ??=
          ListBuilder<V1AdminVerificationsIdGet200ResponseDocumentsInner>();
  set documents(
          ListBuilder<V1AdminVerificationsIdGet200ResponseDocumentsInner>?
              documents) =>
      _$this._documents = documents;

  V1AdminVerificationsIdGet200ResponseBuilder() {
    V1AdminVerificationsIdGet200Response._defaults(this);
  }

  V1AdminVerificationsIdGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _providerId = $v.providerId;
      _provider = $v.provider.toBuilder();
      _fullNameOnId = $v.fullNameOnId;
      _status = $v.status;
      _submittedAt = $v.submittedAt;
      _reviewedAt = $v.reviewedAt;
      _reviewedBy = $v.reviewedBy.toBuilder();
      _rejectionReason = $v.rejectionReason;
      _internalNote = $v.internalNote;
      _expiresAt = $v.expiresAt;
      _documents = $v.documents.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AdminVerificationsIdGet200Response other) {
    _$v = other as _$V1AdminVerificationsIdGet200Response;
  }

  @override
  void update(
      void Function(V1AdminVerificationsIdGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AdminVerificationsIdGet200Response build() => _build();

  _$V1AdminVerificationsIdGet200Response _build() {
    _$V1AdminVerificationsIdGet200Response _$result;
    try {
      _$result = _$v ??
          _$V1AdminVerificationsIdGet200Response._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'V1AdminVerificationsIdGet200Response', 'id'),
            providerId: BuiltValueNullFieldError.checkNotNull(providerId,
                r'V1AdminVerificationsIdGet200Response', 'providerId'),
            provider: provider.build(),
            fullNameOnId: BuiltValueNullFieldError.checkNotNull(fullNameOnId,
                r'V1AdminVerificationsIdGet200Response', 'fullNameOnId'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'V1AdminVerificationsIdGet200Response', 'status'),
            submittedAt: BuiltValueNullFieldError.checkNotNull(submittedAt,
                r'V1AdminVerificationsIdGet200Response', 'submittedAt'),
            reviewedAt: BuiltValueNullFieldError.checkNotNull(reviewedAt,
                r'V1AdminVerificationsIdGet200Response', 'reviewedAt'),
            reviewedBy: reviewedBy.build(),
            rejectionReason: BuiltValueNullFieldError.checkNotNull(
                rejectionReason,
                r'V1AdminVerificationsIdGet200Response',
                'rejectionReason'),
            internalNote: BuiltValueNullFieldError.checkNotNull(internalNote,
                r'V1AdminVerificationsIdGet200Response', 'internalNote'),
            expiresAt: expiresAt,
            documents: documents.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'provider';
        provider.build();

        _$failedField = 'reviewedBy';
        reviewedBy.build();

        _$failedField = 'documents';
        documents.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1AdminVerificationsIdGet200Response',
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

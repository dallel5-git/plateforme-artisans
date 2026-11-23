// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_verification_get200_response_current_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_NOT_SUBMITTED =
    const V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum._(
        'NOT_SUBMITTED');
const V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_PENDING =
    const V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum._(
        'PENDING');
const V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_MORE_INFO_REQUIRED =
    const V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum._(
        'MORE_INFO_REQUIRED');
const V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_APPROVED =
    const V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum._(
        'APPROVED');
const V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_REJECTED =
    const V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum._(
        'REJECTED');

V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'NOT_SUBMITTED':
      return _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_NOT_SUBMITTED;
    case 'PENDING':
      return _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_PENDING;
    case 'MORE_INFO_REQUIRED':
      return _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_MORE_INFO_REQUIRED;
    case 'APPROVED':
      return _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_APPROVED;
    case 'REJECTED':
      return _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum>
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnumValues =
    BuiltSet<
        V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum>(const <V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum>[
  _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_NOT_SUBMITTED,
  _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_PENDING,
  _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_MORE_INFO_REQUIRED,
  _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_APPROVED,
  _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum_REJECTED,
]);

Serializer<V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum>
    _$v1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnumSerializer =
    _$V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnumSerializer();

class _$V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnumSerializer
    implements
        PrimitiveSerializer<
            V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum> {
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
    V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum
  ];
  @override
  final String wireName =
      'V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum';

  @override
  Object serialize(
          Serializers serializers,
          V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum
              object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1ProvidersMeVerificationGet200ResponseCurrentRequest
    extends V1ProvidersMeVerificationGet200ResponseCurrentRequest {
  @override
  final String id;
  @override
  final V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum status;
  @override
  final String fullNameOnId;
  @override
  final DateTime submittedAt;
  @override
  final DateTime reviewedAt;
  @override
  final String rejectionReason;
  @override
  final BuiltList<
          V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner>
      documents;

  factory _$V1ProvidersMeVerificationGet200ResponseCurrentRequest(
          [void Function(
                  V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder)?
              updates]) =>
      (V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder()
            ..update(updates))
          ._build();

  _$V1ProvidersMeVerificationGet200ResponseCurrentRequest._(
      {required this.id,
      required this.status,
      required this.fullNameOnId,
      required this.submittedAt,
      required this.reviewedAt,
      required this.rejectionReason,
      required this.documents})
      : super._();
  @override
  V1ProvidersMeVerificationGet200ResponseCurrentRequest rebuild(
          void Function(
                  V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder toBuilder() =>
      V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeVerificationGet200ResponseCurrentRequest &&
        id == other.id &&
        status == other.status &&
        fullNameOnId == other.fullNameOnId &&
        submittedAt == other.submittedAt &&
        reviewedAt == other.reviewedAt &&
        rejectionReason == other.rejectionReason &&
        documents == other.documents;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, fullNameOnId.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, reviewedAt.hashCode);
    _$hash = $jc(_$hash, rejectionReason.hashCode);
    _$hash = $jc(_$hash, documents.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersMeVerificationGet200ResponseCurrentRequest')
          ..add('id', id)
          ..add('status', status)
          ..add('fullNameOnId', fullNameOnId)
          ..add('submittedAt', submittedAt)
          ..add('reviewedAt', reviewedAt)
          ..add('rejectionReason', rejectionReason)
          ..add('documents', documents))
        .toString();
  }
}

class V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder
    implements
        Builder<V1ProvidersMeVerificationGet200ResponseCurrentRequest,
            V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder> {
  _$V1ProvidersMeVerificationGet200ResponseCurrentRequest? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum? _status;
  V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum? get status =>
      _$this._status;
  set status(
          V1ProvidersMeVerificationGet200ResponseCurrentRequestStatusEnum?
              status) =>
      _$this._status = status;

  String? _fullNameOnId;
  String? get fullNameOnId => _$this._fullNameOnId;
  set fullNameOnId(String? fullNameOnId) => _$this._fullNameOnId = fullNameOnId;

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

  ListBuilder<
          V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner>?
      _documents;
  ListBuilder<
          V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner>
      get documents => _$this._documents ??= ListBuilder<
          V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner>();
  set documents(
          ListBuilder<
                  V1ProvidersMeVerificationGet200ResponseCurrentRequestDocumentsInner>?
              documents) =>
      _$this._documents = documents;

  V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder() {
    V1ProvidersMeVerificationGet200ResponseCurrentRequest._defaults(this);
  }

  V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _fullNameOnId = $v.fullNameOnId;
      _submittedAt = $v.submittedAt;
      _reviewedAt = $v.reviewedAt;
      _rejectionReason = $v.rejectionReason;
      _documents = $v.documents.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeVerificationGet200ResponseCurrentRequest other) {
    _$v = other as _$V1ProvidersMeVerificationGet200ResponseCurrentRequest;
  }

  @override
  void update(
      void Function(
              V1ProvidersMeVerificationGet200ResponseCurrentRequestBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeVerificationGet200ResponseCurrentRequest build() => _build();

  _$V1ProvidersMeVerificationGet200ResponseCurrentRequest _build() {
    _$V1ProvidersMeVerificationGet200ResponseCurrentRequest _$result;
    try {
      _$result = _$v ??
          _$V1ProvidersMeVerificationGet200ResponseCurrentRequest._(
            id: BuiltValueNullFieldError.checkNotNull(id,
                r'V1ProvidersMeVerificationGet200ResponseCurrentRequest', 'id'),
            status: BuiltValueNullFieldError.checkNotNull(
                status,
                r'V1ProvidersMeVerificationGet200ResponseCurrentRequest',
                'status'),
            fullNameOnId: BuiltValueNullFieldError.checkNotNull(
                fullNameOnId,
                r'V1ProvidersMeVerificationGet200ResponseCurrentRequest',
                'fullNameOnId'),
            submittedAt: BuiltValueNullFieldError.checkNotNull(
                submittedAt,
                r'V1ProvidersMeVerificationGet200ResponseCurrentRequest',
                'submittedAt'),
            reviewedAt: BuiltValueNullFieldError.checkNotNull(
                reviewedAt,
                r'V1ProvidersMeVerificationGet200ResponseCurrentRequest',
                'reviewedAt'),
            rejectionReason: BuiltValueNullFieldError.checkNotNull(
                rejectionReason,
                r'V1ProvidersMeVerificationGet200ResponseCurrentRequest',
                'rejectionReason'),
            documents: documents.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'documents';
        documents.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1ProvidersMeVerificationGet200ResponseCurrentRequest',
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

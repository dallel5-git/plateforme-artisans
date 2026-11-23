// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_admin_verifications_get200_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const V1AdminVerificationsGet200ResponseItemsInnerStatusEnum
    _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_NOT_SUBMITTED =
    const V1AdminVerificationsGet200ResponseItemsInnerStatusEnum._(
        'NOT_SUBMITTED');
const V1AdminVerificationsGet200ResponseItemsInnerStatusEnum
    _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_PENDING =
    const V1AdminVerificationsGet200ResponseItemsInnerStatusEnum._('PENDING');
const V1AdminVerificationsGet200ResponseItemsInnerStatusEnum
    _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_MORE_INFO_REQUIRED =
    const V1AdminVerificationsGet200ResponseItemsInnerStatusEnum._(
        'MORE_INFO_REQUIRED');
const V1AdminVerificationsGet200ResponseItemsInnerStatusEnum
    _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_APPROVED =
    const V1AdminVerificationsGet200ResponseItemsInnerStatusEnum._('APPROVED');
const V1AdminVerificationsGet200ResponseItemsInnerStatusEnum
    _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_REJECTED =
    const V1AdminVerificationsGet200ResponseItemsInnerStatusEnum._('REJECTED');

V1AdminVerificationsGet200ResponseItemsInnerStatusEnum
    _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'NOT_SUBMITTED':
      return _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_NOT_SUBMITTED;
    case 'PENDING':
      return _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_PENDING;
    case 'MORE_INFO_REQUIRED':
      return _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_MORE_INFO_REQUIRED;
    case 'APPROVED':
      return _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_APPROVED;
    case 'REJECTED':
      return _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<V1AdminVerificationsGet200ResponseItemsInnerStatusEnum>
    _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnumValues = BuiltSet<
        V1AdminVerificationsGet200ResponseItemsInnerStatusEnum>(const <V1AdminVerificationsGet200ResponseItemsInnerStatusEnum>[
  _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_NOT_SUBMITTED,
  _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_PENDING,
  _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_MORE_INFO_REQUIRED,
  _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_APPROVED,
  _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnum_REJECTED,
]);

Serializer<V1AdminVerificationsGet200ResponseItemsInnerStatusEnum>
    _$v1AdminVerificationsGet200ResponseItemsInnerStatusEnumSerializer =
    _$V1AdminVerificationsGet200ResponseItemsInnerStatusEnumSerializer();

class _$V1AdminVerificationsGet200ResponseItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            V1AdminVerificationsGet200ResponseItemsInnerStatusEnum> {
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
    V1AdminVerificationsGet200ResponseItemsInnerStatusEnum
  ];
  @override
  final String wireName =
      'V1AdminVerificationsGet200ResponseItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          V1AdminVerificationsGet200ResponseItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  V1AdminVerificationsGet200ResponseItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      V1AdminVerificationsGet200ResponseItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$V1AdminVerificationsGet200ResponseItemsInner
    extends V1AdminVerificationsGet200ResponseItemsInner {
  @override
  final String id;
  @override
  final String providerId;
  @override
  final V1AdminVerificationsGet200ResponseItemsInnerProvider provider;
  @override
  final String fullNameOnId;
  @override
  final V1AdminVerificationsGet200ResponseItemsInnerStatusEnum status;
  @override
  final DateTime submittedAt;
  @override
  final DateTime reviewedAt;
  @override
  final V1AdminVerificationsGet200ResponseItemsInnerReviewedBy reviewedBy;
  @override
  final int documentsCount;
  @override
  final BuiltList<V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner>
      documents;

  factory _$V1AdminVerificationsGet200ResponseItemsInner(
          [void Function(V1AdminVerificationsGet200ResponseItemsInnerBuilder)?
              updates]) =>
      (V1AdminVerificationsGet200ResponseItemsInnerBuilder()..update(updates))
          ._build();

  _$V1AdminVerificationsGet200ResponseItemsInner._(
      {required this.id,
      required this.providerId,
      required this.provider,
      required this.fullNameOnId,
      required this.status,
      required this.submittedAt,
      required this.reviewedAt,
      required this.reviewedBy,
      required this.documentsCount,
      required this.documents})
      : super._();
  @override
  V1AdminVerificationsGet200ResponseItemsInner rebuild(
          void Function(V1AdminVerificationsGet200ResponseItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1AdminVerificationsGet200ResponseItemsInnerBuilder toBuilder() =>
      V1AdminVerificationsGet200ResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AdminVerificationsGet200ResponseItemsInner &&
        id == other.id &&
        providerId == other.providerId &&
        provider == other.provider &&
        fullNameOnId == other.fullNameOnId &&
        status == other.status &&
        submittedAt == other.submittedAt &&
        reviewedAt == other.reviewedAt &&
        reviewedBy == other.reviewedBy &&
        documentsCount == other.documentsCount &&
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
    _$hash = $jc(_$hash, documentsCount.hashCode);
    _$hash = $jc(_$hash, documents.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1AdminVerificationsGet200ResponseItemsInner')
          ..add('id', id)
          ..add('providerId', providerId)
          ..add('provider', provider)
          ..add('fullNameOnId', fullNameOnId)
          ..add('status', status)
          ..add('submittedAt', submittedAt)
          ..add('reviewedAt', reviewedAt)
          ..add('reviewedBy', reviewedBy)
          ..add('documentsCount', documentsCount)
          ..add('documents', documents))
        .toString();
  }
}

class V1AdminVerificationsGet200ResponseItemsInnerBuilder
    implements
        Builder<V1AdminVerificationsGet200ResponseItemsInner,
            V1AdminVerificationsGet200ResponseItemsInnerBuilder> {
  _$V1AdminVerificationsGet200ResponseItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _providerId;
  String? get providerId => _$this._providerId;
  set providerId(String? providerId) => _$this._providerId = providerId;

  V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder? _provider;
  V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder get provider =>
      _$this._provider ??=
          V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder();
  set provider(
          V1AdminVerificationsGet200ResponseItemsInnerProviderBuilder?
              provider) =>
      _$this._provider = provider;

  String? _fullNameOnId;
  String? get fullNameOnId => _$this._fullNameOnId;
  set fullNameOnId(String? fullNameOnId) => _$this._fullNameOnId = fullNameOnId;

  V1AdminVerificationsGet200ResponseItemsInnerStatusEnum? _status;
  V1AdminVerificationsGet200ResponseItemsInnerStatusEnum? get status =>
      _$this._status;
  set status(V1AdminVerificationsGet200ResponseItemsInnerStatusEnum? status) =>
      _$this._status = status;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  DateTime? _reviewedAt;
  DateTime? get reviewedAt => _$this._reviewedAt;
  set reviewedAt(DateTime? reviewedAt) => _$this._reviewedAt = reviewedAt;

  V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder? _reviewedBy;
  V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder
      get reviewedBy => _$this._reviewedBy ??=
          V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder();
  set reviewedBy(
          V1AdminVerificationsGet200ResponseItemsInnerReviewedByBuilder?
              reviewedBy) =>
      _$this._reviewedBy = reviewedBy;

  int? _documentsCount;
  int? get documentsCount => _$this._documentsCount;
  set documentsCount(int? documentsCount) =>
      _$this._documentsCount = documentsCount;

  ListBuilder<V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner>?
      _documents;
  ListBuilder<V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner>
      get documents => _$this._documents ??= ListBuilder<
          V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner>();
  set documents(
          ListBuilder<
                  V1AdminVerificationsGet200ResponseItemsInnerDocumentsInner>?
              documents) =>
      _$this._documents = documents;

  V1AdminVerificationsGet200ResponseItemsInnerBuilder() {
    V1AdminVerificationsGet200ResponseItemsInner._defaults(this);
  }

  V1AdminVerificationsGet200ResponseItemsInnerBuilder get _$this {
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
      _documentsCount = $v.documentsCount;
      _documents = $v.documents.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AdminVerificationsGet200ResponseItemsInner other) {
    _$v = other as _$V1AdminVerificationsGet200ResponseItemsInner;
  }

  @override
  void update(
      void Function(V1AdminVerificationsGet200ResponseItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AdminVerificationsGet200ResponseItemsInner build() => _build();

  _$V1AdminVerificationsGet200ResponseItemsInner _build() {
    _$V1AdminVerificationsGet200ResponseItemsInner _$result;
    try {
      _$result = _$v ??
          _$V1AdminVerificationsGet200ResponseItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'V1AdminVerificationsGet200ResponseItemsInner', 'id'),
            providerId: BuiltValueNullFieldError.checkNotNull(providerId,
                r'V1AdminVerificationsGet200ResponseItemsInner', 'providerId'),
            provider: provider.build(),
            fullNameOnId: BuiltValueNullFieldError.checkNotNull(
                fullNameOnId,
                r'V1AdminVerificationsGet200ResponseItemsInner',
                'fullNameOnId'),
            status: BuiltValueNullFieldError.checkNotNull(status,
                r'V1AdminVerificationsGet200ResponseItemsInner', 'status'),
            submittedAt: BuiltValueNullFieldError.checkNotNull(submittedAt,
                r'V1AdminVerificationsGet200ResponseItemsInner', 'submittedAt'),
            reviewedAt: BuiltValueNullFieldError.checkNotNull(reviewedAt,
                r'V1AdminVerificationsGet200ResponseItemsInner', 'reviewedAt'),
            reviewedBy: reviewedBy.build(),
            documentsCount: BuiltValueNullFieldError.checkNotNull(
                documentsCount,
                r'V1AdminVerificationsGet200ResponseItemsInner',
                'documentsCount'),
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
            r'V1AdminVerificationsGet200ResponseItemsInner',
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_admin_verifications_purge_expired_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1AdminVerificationsPurgeExpiredPost200Response
    extends V1AdminVerificationsPurgeExpiredPost200Response {
  @override
  final int totalProcessed;
  @override
  final int purgedCount;
  @override
  final int skippedCount;
  @override
  final int errorsCount;

  factory _$V1AdminVerificationsPurgeExpiredPost200Response(
          [void Function(
                  V1AdminVerificationsPurgeExpiredPost200ResponseBuilder)?
              updates]) =>
      (V1AdminVerificationsPurgeExpiredPost200ResponseBuilder()
            ..update(updates))
          ._build();

  _$V1AdminVerificationsPurgeExpiredPost200Response._(
      {required this.totalProcessed,
      required this.purgedCount,
      required this.skippedCount,
      required this.errorsCount})
      : super._();
  @override
  V1AdminVerificationsPurgeExpiredPost200Response rebuild(
          void Function(V1AdminVerificationsPurgeExpiredPost200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1AdminVerificationsPurgeExpiredPost200ResponseBuilder toBuilder() =>
      V1AdminVerificationsPurgeExpiredPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1AdminVerificationsPurgeExpiredPost200Response &&
        totalProcessed == other.totalProcessed &&
        purgedCount == other.purgedCount &&
        skippedCount == other.skippedCount &&
        errorsCount == other.errorsCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, totalProcessed.hashCode);
    _$hash = $jc(_$hash, purgedCount.hashCode);
    _$hash = $jc(_$hash, skippedCount.hashCode);
    _$hash = $jc(_$hash, errorsCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1AdminVerificationsPurgeExpiredPost200Response')
          ..add('totalProcessed', totalProcessed)
          ..add('purgedCount', purgedCount)
          ..add('skippedCount', skippedCount)
          ..add('errorsCount', errorsCount))
        .toString();
  }
}

class V1AdminVerificationsPurgeExpiredPost200ResponseBuilder
    implements
        Builder<V1AdminVerificationsPurgeExpiredPost200Response,
            V1AdminVerificationsPurgeExpiredPost200ResponseBuilder> {
  _$V1AdminVerificationsPurgeExpiredPost200Response? _$v;

  int? _totalProcessed;
  int? get totalProcessed => _$this._totalProcessed;
  set totalProcessed(int? totalProcessed) =>
      _$this._totalProcessed = totalProcessed;

  int? _purgedCount;
  int? get purgedCount => _$this._purgedCount;
  set purgedCount(int? purgedCount) => _$this._purgedCount = purgedCount;

  int? _skippedCount;
  int? get skippedCount => _$this._skippedCount;
  set skippedCount(int? skippedCount) => _$this._skippedCount = skippedCount;

  int? _errorsCount;
  int? get errorsCount => _$this._errorsCount;
  set errorsCount(int? errorsCount) => _$this._errorsCount = errorsCount;

  V1AdminVerificationsPurgeExpiredPost200ResponseBuilder() {
    V1AdminVerificationsPurgeExpiredPost200Response._defaults(this);
  }

  V1AdminVerificationsPurgeExpiredPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _totalProcessed = $v.totalProcessed;
      _purgedCount = $v.purgedCount;
      _skippedCount = $v.skippedCount;
      _errorsCount = $v.errorsCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1AdminVerificationsPurgeExpiredPost200Response other) {
    _$v = other as _$V1AdminVerificationsPurgeExpiredPost200Response;
  }

  @override
  void update(
      void Function(V1AdminVerificationsPurgeExpiredPost200ResponseBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1AdminVerificationsPurgeExpiredPost200Response build() => _build();

  _$V1AdminVerificationsPurgeExpiredPost200Response _build() {
    final _$result = _$v ??
        _$V1AdminVerificationsPurgeExpiredPost200Response._(
          totalProcessed: BuiltValueNullFieldError.checkNotNull(
              totalProcessed,
              r'V1AdminVerificationsPurgeExpiredPost200Response',
              'totalProcessed'),
          purgedCount: BuiltValueNullFieldError.checkNotNull(
              purgedCount,
              r'V1AdminVerificationsPurgeExpiredPost200Response',
              'purgedCount'),
          skippedCount: BuiltValueNullFieldError.checkNotNull(
              skippedCount,
              r'V1AdminVerificationsPurgeExpiredPost200Response',
              'skippedCount'),
          errorsCount: BuiltValueNullFieldError.checkNotNull(
              errorsCount,
              r'V1AdminVerificationsPurgeExpiredPost200Response',
              'errorsCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

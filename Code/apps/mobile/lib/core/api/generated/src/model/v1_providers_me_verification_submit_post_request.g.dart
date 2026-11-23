// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_providers_me_verification_submit_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1ProvidersMeVerificationSubmitPostRequest
    extends V1ProvidersMeVerificationSubmitPostRequest {
  @override
  final String cinNumber;
  @override
  final String fullNameOnId;
  @override
  final String cinFrontMediaId;
  @override
  final String cinBackMediaId;

  factory _$V1ProvidersMeVerificationSubmitPostRequest(
          [void Function(V1ProvidersMeVerificationSubmitPostRequestBuilder)?
              updates]) =>
      (V1ProvidersMeVerificationSubmitPostRequestBuilder()..update(updates))
          ._build();

  _$V1ProvidersMeVerificationSubmitPostRequest._(
      {required this.cinNumber,
      required this.fullNameOnId,
      required this.cinFrontMediaId,
      required this.cinBackMediaId})
      : super._();
  @override
  V1ProvidersMeVerificationSubmitPostRequest rebuild(
          void Function(V1ProvidersMeVerificationSubmitPostRequestBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1ProvidersMeVerificationSubmitPostRequestBuilder toBuilder() =>
      V1ProvidersMeVerificationSubmitPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1ProvidersMeVerificationSubmitPostRequest &&
        cinNumber == other.cinNumber &&
        fullNameOnId == other.fullNameOnId &&
        cinFrontMediaId == other.cinFrontMediaId &&
        cinBackMediaId == other.cinBackMediaId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cinNumber.hashCode);
    _$hash = $jc(_$hash, fullNameOnId.hashCode);
    _$hash = $jc(_$hash, cinFrontMediaId.hashCode);
    _$hash = $jc(_$hash, cinBackMediaId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'V1ProvidersMeVerificationSubmitPostRequest')
          ..add('cinNumber', cinNumber)
          ..add('fullNameOnId', fullNameOnId)
          ..add('cinFrontMediaId', cinFrontMediaId)
          ..add('cinBackMediaId', cinBackMediaId))
        .toString();
  }
}

class V1ProvidersMeVerificationSubmitPostRequestBuilder
    implements
        Builder<V1ProvidersMeVerificationSubmitPostRequest,
            V1ProvidersMeVerificationSubmitPostRequestBuilder> {
  _$V1ProvidersMeVerificationSubmitPostRequest? _$v;

  String? _cinNumber;
  String? get cinNumber => _$this._cinNumber;
  set cinNumber(String? cinNumber) => _$this._cinNumber = cinNumber;

  String? _fullNameOnId;
  String? get fullNameOnId => _$this._fullNameOnId;
  set fullNameOnId(String? fullNameOnId) => _$this._fullNameOnId = fullNameOnId;

  String? _cinFrontMediaId;
  String? get cinFrontMediaId => _$this._cinFrontMediaId;
  set cinFrontMediaId(String? cinFrontMediaId) =>
      _$this._cinFrontMediaId = cinFrontMediaId;

  String? _cinBackMediaId;
  String? get cinBackMediaId => _$this._cinBackMediaId;
  set cinBackMediaId(String? cinBackMediaId) =>
      _$this._cinBackMediaId = cinBackMediaId;

  V1ProvidersMeVerificationSubmitPostRequestBuilder() {
    V1ProvidersMeVerificationSubmitPostRequest._defaults(this);
  }

  V1ProvidersMeVerificationSubmitPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cinNumber = $v.cinNumber;
      _fullNameOnId = $v.fullNameOnId;
      _cinFrontMediaId = $v.cinFrontMediaId;
      _cinBackMediaId = $v.cinBackMediaId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1ProvidersMeVerificationSubmitPostRequest other) {
    _$v = other as _$V1ProvidersMeVerificationSubmitPostRequest;
  }

  @override
  void update(
      void Function(V1ProvidersMeVerificationSubmitPostRequestBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  V1ProvidersMeVerificationSubmitPostRequest build() => _build();

  _$V1ProvidersMeVerificationSubmitPostRequest _build() {
    final _$result = _$v ??
        _$V1ProvidersMeVerificationSubmitPostRequest._(
          cinNumber: BuiltValueNullFieldError.checkNotNull(cinNumber,
              r'V1ProvidersMeVerificationSubmitPostRequest', 'cinNumber'),
          fullNameOnId: BuiltValueNullFieldError.checkNotNull(fullNameOnId,
              r'V1ProvidersMeVerificationSubmitPostRequest', 'fullNameOnId'),
          cinFrontMediaId: BuiltValueNullFieldError.checkNotNull(
              cinFrontMediaId,
              r'V1ProvidersMeVerificationSubmitPostRequest',
              'cinFrontMediaId'),
          cinBackMediaId: BuiltValueNullFieldError.checkNotNull(cinBackMediaId,
              r'V1ProvidersMeVerificationSubmitPostRequest', 'cinBackMediaId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

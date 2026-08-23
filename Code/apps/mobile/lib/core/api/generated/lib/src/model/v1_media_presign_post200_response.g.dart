// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_media_presign_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1MediaPresignPost200Response extends V1MediaPresignPost200Response {
  @override
  final String mediaId;
  @override
  final String uploadUrl;
  @override
  final DateTime expiresAt;

  factory _$V1MediaPresignPost200Response(
          [void Function(V1MediaPresignPost200ResponseBuilder)? updates]) =>
      (V1MediaPresignPost200ResponseBuilder()..update(updates))._build();

  _$V1MediaPresignPost200Response._(
      {required this.mediaId, required this.uploadUrl, required this.expiresAt})
      : super._();
  @override
  V1MediaPresignPost200Response rebuild(
          void Function(V1MediaPresignPost200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1MediaPresignPost200ResponseBuilder toBuilder() =>
      V1MediaPresignPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1MediaPresignPost200Response &&
        mediaId == other.mediaId &&
        uploadUrl == other.uploadUrl &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mediaId.hashCode);
    _$hash = $jc(_$hash, uploadUrl.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1MediaPresignPost200Response')
          ..add('mediaId', mediaId)
          ..add('uploadUrl', uploadUrl)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class V1MediaPresignPost200ResponseBuilder
    implements
        Builder<V1MediaPresignPost200Response,
            V1MediaPresignPost200ResponseBuilder> {
  _$V1MediaPresignPost200Response? _$v;

  String? _mediaId;
  String? get mediaId => _$this._mediaId;
  set mediaId(String? mediaId) => _$this._mediaId = mediaId;

  String? _uploadUrl;
  String? get uploadUrl => _$this._uploadUrl;
  set uploadUrl(String? uploadUrl) => _$this._uploadUrl = uploadUrl;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  V1MediaPresignPost200ResponseBuilder() {
    V1MediaPresignPost200Response._defaults(this);
  }

  V1MediaPresignPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mediaId = $v.mediaId;
      _uploadUrl = $v.uploadUrl;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1MediaPresignPost200Response other) {
    _$v = other as _$V1MediaPresignPost200Response;
  }

  @override
  void update(void Function(V1MediaPresignPost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1MediaPresignPost200Response build() => _build();

  _$V1MediaPresignPost200Response _build() {
    final _$result = _$v ??
        _$V1MediaPresignPost200Response._(
          mediaId: BuiltValueNullFieldError.checkNotNull(
              mediaId, r'V1MediaPresignPost200Response', 'mediaId'),
          uploadUrl: BuiltValueNullFieldError.checkNotNull(
              uploadUrl, r'V1MediaPresignPost200Response', 'uploadUrl'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'V1MediaPresignPost200Response', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

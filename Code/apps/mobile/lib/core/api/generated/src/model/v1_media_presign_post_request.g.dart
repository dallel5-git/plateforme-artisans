// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_media_presign_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1MediaPresignPostRequest extends V1MediaPresignPostRequest {
  @override
  final String filename;
  @override
  final String mimeType;
  @override
  final int sizeBytes;

  factory _$V1MediaPresignPostRequest([
    void Function(V1MediaPresignPostRequestBuilder)? updates,
  ]) => (V1MediaPresignPostRequestBuilder()..update(updates))._build();

  _$V1MediaPresignPostRequest._({
    required this.filename,
    required this.mimeType,
    required this.sizeBytes,
  }) : super._();
  @override
  V1MediaPresignPostRequest rebuild(
    void Function(V1MediaPresignPostRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1MediaPresignPostRequestBuilder toBuilder() =>
      V1MediaPresignPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1MediaPresignPostRequest &&
        filename == other.filename &&
        mimeType == other.mimeType &&
        sizeBytes == other.sizeBytes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, filename.hashCode);
    _$hash = $jc(_$hash, mimeType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1MediaPresignPostRequest')
          ..add('filename', filename)
          ..add('mimeType', mimeType)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class V1MediaPresignPostRequestBuilder
    implements
        Builder<V1MediaPresignPostRequest, V1MediaPresignPostRequestBuilder> {
  _$V1MediaPresignPostRequest? _$v;

  String? _filename;
  String? get filename => _$this._filename;
  set filename(String? filename) => _$this._filename = filename;

  String? _mimeType;
  String? get mimeType => _$this._mimeType;
  set mimeType(String? mimeType) => _$this._mimeType = mimeType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  V1MediaPresignPostRequestBuilder() {
    V1MediaPresignPostRequest._defaults(this);
  }

  V1MediaPresignPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _filename = $v.filename;
      _mimeType = $v.mimeType;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1MediaPresignPostRequest other) {
    _$v = other as _$V1MediaPresignPostRequest;
  }

  @override
  void update(void Function(V1MediaPresignPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1MediaPresignPostRequest build() => _build();

  _$V1MediaPresignPostRequest _build() {
    final _$result =
        _$v ??
        _$V1MediaPresignPostRequest._(
          filename: BuiltValueNullFieldError.checkNotNull(
            filename,
            r'V1MediaPresignPostRequest',
            'filename',
          ),
          mimeType: BuiltValueNullFieldError.checkNotNull(
            mimeType,
            r'V1MediaPresignPostRequest',
            'mimeType',
          ),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
            sizeBytes,
            r'V1MediaPresignPostRequest',
            'sizeBytes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

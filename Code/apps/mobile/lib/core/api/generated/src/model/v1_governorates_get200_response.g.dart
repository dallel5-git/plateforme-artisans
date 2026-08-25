// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_governorates_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1GovernoratesGet200Response extends V1GovernoratesGet200Response {
  @override
  final BuiltList<V1GovernoratesGet200ResponseGovernoratesInner> governorates;

  factory _$V1GovernoratesGet200Response(
          [void Function(V1GovernoratesGet200ResponseBuilder)? updates]) =>
      (V1GovernoratesGet200ResponseBuilder()..update(updates))._build();

  _$V1GovernoratesGet200Response._({required this.governorates}) : super._();
  @override
  V1GovernoratesGet200Response rebuild(
          void Function(V1GovernoratesGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1GovernoratesGet200ResponseBuilder toBuilder() =>
      V1GovernoratesGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1GovernoratesGet200Response &&
        governorates == other.governorates;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, governorates.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1GovernoratesGet200Response')
          ..add('governorates', governorates))
        .toString();
  }
}

class V1GovernoratesGet200ResponseBuilder
    implements
        Builder<V1GovernoratesGet200Response,
            V1GovernoratesGet200ResponseBuilder> {
  _$V1GovernoratesGet200Response? _$v;

  ListBuilder<V1GovernoratesGet200ResponseGovernoratesInner>? _governorates;
  ListBuilder<V1GovernoratesGet200ResponseGovernoratesInner> get governorates =>
      _$this._governorates ??=
          ListBuilder<V1GovernoratesGet200ResponseGovernoratesInner>();
  set governorates(
          ListBuilder<V1GovernoratesGet200ResponseGovernoratesInner>?
              governorates) =>
      _$this._governorates = governorates;

  V1GovernoratesGet200ResponseBuilder() {
    V1GovernoratesGet200Response._defaults(this);
  }

  V1GovernoratesGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _governorates = $v.governorates.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1GovernoratesGet200Response other) {
    _$v = other as _$V1GovernoratesGet200Response;
  }

  @override
  void update(void Function(V1GovernoratesGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1GovernoratesGet200Response build() => _build();

  _$V1GovernoratesGet200Response _build() {
    _$V1GovernoratesGet200Response _$result;
    try {
      _$result = _$v ??
          _$V1GovernoratesGet200Response._(
            governorates: governorates.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'governorates';
        governorates.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1GovernoratesGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

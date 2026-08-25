// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_governorates_id_delegations_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1GovernoratesIdDelegationsGet200Response
    extends V1GovernoratesIdDelegationsGet200Response {
  @override
  final BuiltList<V1GovernoratesIdDelegationsGet200ResponseDelegationsInner>
  delegations;

  factory _$V1GovernoratesIdDelegationsGet200Response([
    void Function(V1GovernoratesIdDelegationsGet200ResponseBuilder)? updates,
  ]) => (V1GovernoratesIdDelegationsGet200ResponseBuilder()..update(updates))
      ._build();

  _$V1GovernoratesIdDelegationsGet200Response._({required this.delegations})
    : super._();
  @override
  V1GovernoratesIdDelegationsGet200Response rebuild(
    void Function(V1GovernoratesIdDelegationsGet200ResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  V1GovernoratesIdDelegationsGet200ResponseBuilder toBuilder() =>
      V1GovernoratesIdDelegationsGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1GovernoratesIdDelegationsGet200Response &&
        delegations == other.delegations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, delegations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'V1GovernoratesIdDelegationsGet200Response',
    )..add('delegations', delegations)).toString();
  }
}

class V1GovernoratesIdDelegationsGet200ResponseBuilder
    implements
        Builder<
          V1GovernoratesIdDelegationsGet200Response,
          V1GovernoratesIdDelegationsGet200ResponseBuilder
        > {
  _$V1GovernoratesIdDelegationsGet200Response? _$v;

  ListBuilder<V1GovernoratesIdDelegationsGet200ResponseDelegationsInner>?
  _delegations;
  ListBuilder<V1GovernoratesIdDelegationsGet200ResponseDelegationsInner>
  get delegations => _$this._delegations ??=
      ListBuilder<V1GovernoratesIdDelegationsGet200ResponseDelegationsInner>();
  set delegations(
    ListBuilder<V1GovernoratesIdDelegationsGet200ResponseDelegationsInner>?
    delegations,
  ) => _$this._delegations = delegations;

  V1GovernoratesIdDelegationsGet200ResponseBuilder() {
    V1GovernoratesIdDelegationsGet200Response._defaults(this);
  }

  V1GovernoratesIdDelegationsGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _delegations = $v.delegations.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1GovernoratesIdDelegationsGet200Response other) {
    _$v = other as _$V1GovernoratesIdDelegationsGet200Response;
  }

  @override
  void update(
    void Function(V1GovernoratesIdDelegationsGet200ResponseBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  V1GovernoratesIdDelegationsGet200Response build() => _build();

  _$V1GovernoratesIdDelegationsGet200Response _build() {
    _$V1GovernoratesIdDelegationsGet200Response _$result;
    try {
      _$result =
          _$v ??
          _$V1GovernoratesIdDelegationsGet200Response._(
            delegations: delegations.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'delegations';
        delegations.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'V1GovernoratesIdDelegationsGet200Response',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

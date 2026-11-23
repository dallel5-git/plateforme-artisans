// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_users_me_export_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$V1UsersMeExportGet200Response extends V1UsersMeExportGet200Response {
  @override
  final String legalNotice;
  @override
  final DateTime exportedAt;
  @override
  final V1UsersMeExportGet200ResponseUser user;
  @override
  final V1UsersMeExportGet200ResponseProviderProfile providerProfile;
  @override
  final BuiltList<V1UsersMeExportGet200ResponseReviewsWrittenInner>
      reviewsWritten;
  @override
  final BuiltList<V1UsersMeExportGet200ResponseFavoritesInner> favorites;
  @override
  final BuiltList<V1UsersMeExportGet200ResponseContactEventsInner>
      contactEvents;
  @override
  final BuiltList<V1UsersMeExportGet200ResponseVerificationRequestsInner>
      verificationRequests;

  factory _$V1UsersMeExportGet200Response(
          [void Function(V1UsersMeExportGet200ResponseBuilder)? updates]) =>
      (V1UsersMeExportGet200ResponseBuilder()..update(updates))._build();

  _$V1UsersMeExportGet200Response._(
      {required this.legalNotice,
      required this.exportedAt,
      required this.user,
      required this.providerProfile,
      required this.reviewsWritten,
      required this.favorites,
      required this.contactEvents,
      required this.verificationRequests})
      : super._();
  @override
  V1UsersMeExportGet200Response rebuild(
          void Function(V1UsersMeExportGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  V1UsersMeExportGet200ResponseBuilder toBuilder() =>
      V1UsersMeExportGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is V1UsersMeExportGet200Response &&
        legalNotice == other.legalNotice &&
        exportedAt == other.exportedAt &&
        user == other.user &&
        providerProfile == other.providerProfile &&
        reviewsWritten == other.reviewsWritten &&
        favorites == other.favorites &&
        contactEvents == other.contactEvents &&
        verificationRequests == other.verificationRequests;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, legalNotice.hashCode);
    _$hash = $jc(_$hash, exportedAt.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, providerProfile.hashCode);
    _$hash = $jc(_$hash, reviewsWritten.hashCode);
    _$hash = $jc(_$hash, favorites.hashCode);
    _$hash = $jc(_$hash, contactEvents.hashCode);
    _$hash = $jc(_$hash, verificationRequests.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'V1UsersMeExportGet200Response')
          ..add('legalNotice', legalNotice)
          ..add('exportedAt', exportedAt)
          ..add('user', user)
          ..add('providerProfile', providerProfile)
          ..add('reviewsWritten', reviewsWritten)
          ..add('favorites', favorites)
          ..add('contactEvents', contactEvents)
          ..add('verificationRequests', verificationRequests))
        .toString();
  }
}

class V1UsersMeExportGet200ResponseBuilder
    implements
        Builder<V1UsersMeExportGet200Response,
            V1UsersMeExportGet200ResponseBuilder> {
  _$V1UsersMeExportGet200Response? _$v;

  String? _legalNotice;
  String? get legalNotice => _$this._legalNotice;
  set legalNotice(String? legalNotice) => _$this._legalNotice = legalNotice;

  DateTime? _exportedAt;
  DateTime? get exportedAt => _$this._exportedAt;
  set exportedAt(DateTime? exportedAt) => _$this._exportedAt = exportedAt;

  V1UsersMeExportGet200ResponseUserBuilder? _user;
  V1UsersMeExportGet200ResponseUserBuilder get user =>
      _$this._user ??= V1UsersMeExportGet200ResponseUserBuilder();
  set user(V1UsersMeExportGet200ResponseUserBuilder? user) =>
      _$this._user = user;

  V1UsersMeExportGet200ResponseProviderProfileBuilder? _providerProfile;
  V1UsersMeExportGet200ResponseProviderProfileBuilder get providerProfile =>
      _$this._providerProfile ??=
          V1UsersMeExportGet200ResponseProviderProfileBuilder();
  set providerProfile(
          V1UsersMeExportGet200ResponseProviderProfileBuilder?
              providerProfile) =>
      _$this._providerProfile = providerProfile;

  ListBuilder<V1UsersMeExportGet200ResponseReviewsWrittenInner>?
      _reviewsWritten;
  ListBuilder<V1UsersMeExportGet200ResponseReviewsWrittenInner>
      get reviewsWritten => _$this._reviewsWritten ??=
          ListBuilder<V1UsersMeExportGet200ResponseReviewsWrittenInner>();
  set reviewsWritten(
          ListBuilder<V1UsersMeExportGet200ResponseReviewsWrittenInner>?
              reviewsWritten) =>
      _$this._reviewsWritten = reviewsWritten;

  ListBuilder<V1UsersMeExportGet200ResponseFavoritesInner>? _favorites;
  ListBuilder<V1UsersMeExportGet200ResponseFavoritesInner> get favorites =>
      _$this._favorites ??=
          ListBuilder<V1UsersMeExportGet200ResponseFavoritesInner>();
  set favorites(
          ListBuilder<V1UsersMeExportGet200ResponseFavoritesInner>?
              favorites) =>
      _$this._favorites = favorites;

  ListBuilder<V1UsersMeExportGet200ResponseContactEventsInner>? _contactEvents;
  ListBuilder<V1UsersMeExportGet200ResponseContactEventsInner>
      get contactEvents => _$this._contactEvents ??=
          ListBuilder<V1UsersMeExportGet200ResponseContactEventsInner>();
  set contactEvents(
          ListBuilder<V1UsersMeExportGet200ResponseContactEventsInner>?
              contactEvents) =>
      _$this._contactEvents = contactEvents;

  ListBuilder<V1UsersMeExportGet200ResponseVerificationRequestsInner>?
      _verificationRequests;
  ListBuilder<V1UsersMeExportGet200ResponseVerificationRequestsInner>
      get verificationRequests => _$this._verificationRequests ??=
          ListBuilder<V1UsersMeExportGet200ResponseVerificationRequestsInner>();
  set verificationRequests(
          ListBuilder<V1UsersMeExportGet200ResponseVerificationRequestsInner>?
              verificationRequests) =>
      _$this._verificationRequests = verificationRequests;

  V1UsersMeExportGet200ResponseBuilder() {
    V1UsersMeExportGet200Response._defaults(this);
  }

  V1UsersMeExportGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _legalNotice = $v.legalNotice;
      _exportedAt = $v.exportedAt;
      _user = $v.user.toBuilder();
      _providerProfile = $v.providerProfile.toBuilder();
      _reviewsWritten = $v.reviewsWritten.toBuilder();
      _favorites = $v.favorites.toBuilder();
      _contactEvents = $v.contactEvents.toBuilder();
      _verificationRequests = $v.verificationRequests.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(V1UsersMeExportGet200Response other) {
    _$v = other as _$V1UsersMeExportGet200Response;
  }

  @override
  void update(void Function(V1UsersMeExportGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  V1UsersMeExportGet200Response build() => _build();

  _$V1UsersMeExportGet200Response _build() {
    _$V1UsersMeExportGet200Response _$result;
    try {
      _$result = _$v ??
          _$V1UsersMeExportGet200Response._(
            legalNotice: BuiltValueNullFieldError.checkNotNull(
                legalNotice, r'V1UsersMeExportGet200Response', 'legalNotice'),
            exportedAt: BuiltValueNullFieldError.checkNotNull(
                exportedAt, r'V1UsersMeExportGet200Response', 'exportedAt'),
            user: user.build(),
            providerProfile: providerProfile.build(),
            reviewsWritten: reviewsWritten.build(),
            favorites: favorites.build(),
            contactEvents: contactEvents.build(),
            verificationRequests: verificationRequests.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
        _$failedField = 'providerProfile';
        providerProfile.build();
        _$failedField = 'reviewsWritten';
        reviewsWritten.build();
        _$failedField = 'favorites';
        favorites.build();
        _$failedField = 'contactEvents';
        contactEvents.build();
        _$failedField = 'verificationRequests';
        verificationRequests.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'V1UsersMeExportGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

// L'app stocke tout en UTC ISO-8601, la conversion vers Africa/Tunis n'a
// lieu qu'à l'affichage (cf. CLAUDE.md §4.1). La Tunisie est en UTC+1 fixe,
// sans heure d'été depuis 2009 — un décalage constant suffit, pas besoin du
// package `timezone` pour une seule règle sans DST.
const _tunisOffset = Duration(hours: 1);

/// Miroir Dart de `packages/i18n/src/format.ts#formatCurrency`.
/// `amountInMillimes` : montant entier en millimes (1 TND = 1000 millimes),
/// jamais un float (convention CLAUDE.md §4.1) — seul point de conversion
/// vers une unité affichable. Chiffres occidentaux dans les deux locales :
/// c'est déjà le comportement par défaut d'`intl` pour `ar` (ZERO_DIGIT: 0
/// dans ses données CLDR), aucun forçage nécessaire.
String formatCurrency(int amountInMillimes, Locale locale) {
  final amountInDinars = amountInMillimes / 1000;
  final format = NumberFormat.currency(
    locale: locale.languageCode,
    symbol: 'TND',
    decimalDigits: 3,
  );
  return format.format(amountInDinars);
}

/// Miroir Dart de `packages/i18n/src/format.ts#formatDate`. Nécessite
/// `initializeDateFormatting` appelé au préalable pour `locale` (cf.
/// lib/main.dart) — sans ça `DateFormat` lève une exception.
String formatDate(DateTime date, Locale locale) {
  final tunisTime = date.toUtc().add(_tunisOffset);
  return DateFormat.yMMMd(locale.languageCode).format(tunisTime);
}

/// Miroir Dart de `packages/i18n/src/format.ts#formatNumber`, restreint à un
/// nombre fixe de décimales (ex. note moyenne "4,8" — jamais "5" pour 5.0).
/// Utilisé par `RatingStars` (note) et `ProviderCard` (distance).
String formatNumber(num value, Locale locale, {int decimalDigits = 1}) {
  final pattern = '0.${'0' * decimalDigits}';
  return NumberFormat(pattern, locale.languageCode).format(value);
}

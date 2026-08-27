import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sanaya/core/i18n/format.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr');
    await initializeDateFormatting('ar');
  });

  group('FM-03d — formatCurrency', () {
    test('convertit les millimes en dinars et affiche 3 décimales (fr)', () {
      final result = formatCurrency(12345, const Locale('fr'));

      expect(result, contains('12,345'));
      expect(result, contains('TND'));
    });

    test('convertit les millimes en dinars et affiche 3 décimales (ar)', () {
      final result = formatCurrency(12345, const Locale('ar'));

      expect(result, contains('12.345'));
      expect(result, contains('TND'));
    });

    test('utilise des chiffres occidentaux même en arabe', () {
      final result = formatCurrency(12345, const Locale('ar'));

      expect(result, isNot(contains('١')));
      expect(result, isNot(contains('٢')));
    });

    test('un montant nul affiche 0,000', () {
      expect(formatCurrency(0, const Locale('fr')), contains('0,000'));
    });
  });

  group('FM-03d — formatDate', () {
    final date = DateTime.utc(2026, 8, 25, 23);

    test('formate une date en français', () {
      expect(formatDate(date, const Locale('fr')), contains('août'));
    });

    test('formate une date en arabe avec des chiffres occidentaux', () {
      final result = formatDate(date, const Locale('ar'));

      expect(result, contains('26'));
      expect(result, isNot(contains('٢٦')));
    });

    test('applique le décalage Africa/Tunis (UTC+1) avant formatage', () {
      // 25/08 23:00 UTC + 1h = 26/08 en heure de Tunis.
      final result = formatDate(date, const Locale('fr'));

      expect(result, contains('26'));
    });
  });

  group('formatNumber', () {
    test('formate un nombre avec 1 décimale en FR (virgule)', () {
      final result = formatNumber(4.8, const Locale('fr'));
      expect(result, '4,8');
    });

    test('formate un entier avec 1 décimale en FR (4,0)', () {
      final result = formatNumber(4, const Locale('fr'));
      expect(result, '4,0');
    });

    test(
      'formate un nombre avec 1 décimale en AR (point, chiffres occidentaux)',
      () {
        final result = formatNumber(4.8, const Locale('ar'));
        expect(result, '4.8');
      },
    );
  });
}

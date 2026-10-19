import 'package:avis/Helpers/format_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formate une date ISO en jj/MM/aaaa', () {
    expect(formatDate('2026-10-19'), '19/10/2026');
  });

  test('complète les jours et mois à un chiffre', () {
    expect(formatDate('2026-01-05'), '05/01/2026');
  });

  test('date invalide : retourne la valeur brute sans crash', () {
    expect(formatDate('invalide'), 'invalide');
  });

  test('date nulle : retourne une chaîne vide', () {
    expect(formatDate(null), '');
  });
}

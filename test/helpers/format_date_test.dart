import 'package:avis/Helpers/format_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('date absolue : le mois en toutes lettres remplace jj/MM/aaaa', () {
    expect(formatDate('2026-10-19'), '19 oct. 2026');
    expect(formatDate('2026-01-05'), '05 janv. 2026');
  });

  test('date invalide : retourne la valeur brute sans crash', () {
    expect(formatDate('invalide'), 'invalide');
  });

  test('date nulle : retourne une chaîne vide', () {
    expect(formatDate(null), '');
  });

  group('libellé relatif de la carte', () {
    final DateTime reference = DateTime(2026, 11, 23, 15, 30);

    test("aujourd'hui et hier", () {
      expect(
        formatDateRelative('2026-11-23T09:12:00', maintenant: reference),
        "Aujourd'hui",
      );
      expect(
        formatDateRelative('2026-11-22T09:12:00', maintenant: reference),
        'Hier',
      );
    });

    test('quelques jours puis date absolue', () {
      expect(
        formatDateRelative('2026-11-20T09:12:00', maintenant: reference),
        'il y a 3 jours',
      );
      expect(
        formatDateRelative('2026-10-19T09:12:00', maintenant: reference),
        '19 oct. 2026',
      );
    });

    test('une date invalide reste lisible telle quelle', () {
      expect(formatDateRelative('bientôt', maintenant: reference), 'bientôt');
    });
  });

  test('tooltip : date et heure complètes', () {
    expect(
      formatDateComplete('2026-10-19T14:07:00'),
      contains('19 octobre 2026'),
    );
    expect(formatDateComplete('invalide'), 'invalide');
  });
}

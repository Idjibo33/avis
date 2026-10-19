import 'package:avis/Helpers/pourcentage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('aucun vote : retourne 0 au lieu de NaN', () {
    expect(calculerPourcentage(0, 0), 0);
  });

  test('total nul négatif : retourne 0', () {
    expect(calculerPourcentage(3, -1), 0);
  });

  test('1 vote sur 4 : 25 %', () {
    expect(calculerPourcentage(1, 4), 25);
  });

  test('3 votes sur 4 : 75 %', () {
    expect(calculerPourcentage(3, 4), 75);
  });
}

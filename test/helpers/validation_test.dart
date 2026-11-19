import 'package:avis/Helpers/validation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('images manquantes : validation refusée', () {
    expect(validateImagesDuel('question', null, null), isFalse);
    expect(validateImagesDuel('', XFile('a.jpg'), XFile('b.jpg')), isFalse);
  });

  test('deux images choisies : validation acceptée', () {
    expect(
      validateImagesDuel('question', XFile('a.jpg'), XFile('b.jpg')),
      isTrue,
    );
  });

  test('pseudo : 3 à 20 lettres, chiffres ou tirets bas', () {
    expect(erreurValidationElevation('ab', 'motdepasse1'), contains('pseudo'));
    expect(
      erreurValidationElevation('a' * 21, 'motdepasse1'),
      contains('pseudo'),
    );
    expect(erreurValidationElevation('pseudo-1', 'motdepasse1'), isNotNull);
    expect(erreurValidationElevation('pseudo_1', 'motdepasse1'), isNull);
  });

  test('mot de passe : au moins 8 caractères', () {
    expect(
      erreurValidationElevation('joueur_1', '1234567'),
      contains('8 caractères'),
    );
    expect(erreurValidationElevation('joueur_1', '12345678'), isNull);
  });
}

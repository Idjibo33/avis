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
}

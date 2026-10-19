import 'package:avis/Helpers/responsiveness.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpResponsive(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Responsiveness(
            child: SizedBox(key: ValueKey('contenu'), child: Placeholder()),
          ),
        ),
      ),
    );
  }

  testWidgets('grand écran : contenu borné à 600 px et centré', (tester) async {
    await pumpResponsive(tester, const Size(1000, 800));

    final Finder contenu = find.byKey(const ValueKey('contenu'));
    expect(tester.getSize(contenu).width, 600);
    expect(tester.getRect(contenu).left, 200);
  });

  testWidgets('petit écran : contenu pleine largeur', (tester) async {
    await pumpResponsive(tester, const Size(360, 640));

    expect(tester.getSize(find.byKey(const ValueKey('contenu'))).width, 360);
  });
}

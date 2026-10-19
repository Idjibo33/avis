import 'package:avis/widgets/header_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('nom vide : pas de crash', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HeaderCardWidget(nom: '', date: '2026-10-19'),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('nom très long : tronqué sans débordement', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    const String nom = 'UnNomVraimentTresTresTresLongPourTester';
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HeaderCardWidget(nom: nom, date: '2026-10-19'),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    final Text texte = tester.widget<Text>(find.text(nom));
    expect(texte.maxLines, 1);
    expect(texte.overflow, TextOverflow.ellipsis);
  });
}

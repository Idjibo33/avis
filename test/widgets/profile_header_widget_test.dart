import 'package:avis/widgets/profile_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('nom long : tronqué sans débordement sur petit écran',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileHeaderWidget(
            nom: 'UnNomVraimentTresLongPourTesterLeRendu',
            prenom: 'UnPrenomVraimentTresLong',
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('nom vide : affiche un repli sans crash', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileHeaderWidget(nom: '', prenom: ''),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Utilisateur'), findsOneWidget);
  });
}

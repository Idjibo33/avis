import 'package:avis/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('le disque mesure exactement la taille demandée', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Center(child: Logo(size: 36)))),
    );

    final SizedBox disque = tester.widget<SizedBox>(
      find.descendant(of: find.byType(Logo), matching: find.byType(SizedBox)).first,
    );
    expect(disque.width, 36);
    expect(disque.height, 36);
    expect(tester.takeException(), isNull);
  });

  testWidgets('le point teal reste dans le disque, même en AppBar serrée', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(toolbarHeight: 56, title: const Logo(size: 36)),
          body: SizedBox.shrink(),
        ),
      ),
    );

    final Positioned point = tester.widget<Positioned>(
      find.descendant(of: find.byType(Logo), matching: find.byType(Positioned)),
    );
    final Container pastille = tester.widget<Container>(
      find.descendant(of: find.byType(Positioned), matching: find.byType(Container)),
    );
    final double marge = 36 * 0.035;
    final double diametre = 36 * 0.30;

    expect(point.top, marge);
    expect(point.right, marge);
    expect(pastille.constraints?.maxWidth, diametre);
    expect(marge + diametre, lessThan(36));
    expect(tester.takeException(), isNull);
  });

  testWidgets('avecTexte ajoute le mot « avis » à côté du disque', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Logo(size: 36, avecTexte: true))),
      ),
    );

    expect(find.text('avis'), findsOneWidget);
    expect(find.bySemanticsLabel('Avis'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sans texte, seul le disque est exposé', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Center(child: Logo(size: 36)))),
    );

    expect(find.text('avis'), findsNothing);
    expect(find.bySemanticsLabel('Avis'), findsOneWidget);
  });
}

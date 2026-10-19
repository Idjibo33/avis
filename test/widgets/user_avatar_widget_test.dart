import 'package:avis/widgets/user_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('nom vide : affiche un caractère de repli sans crash',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: UserAvatarWidget(radius: 24, nom: '')),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('?'), findsOneWidget);
  });

  testWidgets('affiche la première lettre du nom', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: UserAvatarWidget(radius: 24, nom: 'Ismaël')),
      ),
    );

    expect(find.text('I'), findsOneWidget);
  });
}

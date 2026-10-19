import 'package:avis/Models/interaction.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Screens/resultat_duel_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('petit écran : contenu défilable sans débordement',
      (tester) async {
    tester.view.physicalSize = const Size(320, 400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final FakeInteractionsServices services = FakeInteractionsServices()
      ..interactions = [
        Interaction(choix: 'A', postId: 1),
        Interaction(choix: 'B', postId: 1),
      ];

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) =>
            InteractionsServicesProvider(interactions: services),
        child: MaterialApp(
          home: ResultatDuelScreen(
            post: buildPost(
              question:
                  'Une question très longue pour occuper beaucoup de place '
                  'sur un écran de petite taille ?',
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(
      find.text('Nombre total de votes'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Nombre total de votes'), findsOneWidget);
  });
}

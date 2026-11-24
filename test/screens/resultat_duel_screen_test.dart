import 'package:avis/Models/interaction.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Screens/resultat_duel_screen.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/duel_resultat_pourcentage_widget.dart';
import 'package:avis/widgets/duel_resultat_total.dart';
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

  testWidgets('question, carte et chiffres partagent la même gouttière', (
    tester,
  ) async {
    const String question = 'Café ou thé ?';
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => InteractionsServicesProvider(
          interactions: FakeInteractionsServices(),
        ),
        child: MaterialApp(
          home: ResultatDuelScreen(post: buildPost(question: question)),
        ),
      ),
    );
    await tester.pump();

    final Padding questionPadding = tester.widget<Padding>(
      find.ancestor(
        of: find.text(question),
        matching: find.byType(Padding),
      ),
    );
    final Card carte = tester.widget<Card>(find.byType(Card).first);
    final Padding pourcentage = tester.widgetList<Padding>(
      find.descendant(
        of: find.byType(DuelResultatPourcentageWidget),
        matching: find.byType(Padding),
      ),
    ).first;
    final Padding total = tester.widgetList<Padding>(
      find.descendant(
        of: find.byType(DuelResultatTotal),
        matching: find.byType(Padding),
      ),
    ).first;

    const EdgeInsets gouttiere = EdgeInsets.symmetric(horizontal: espaceXl);
    expect(questionPadding.padding, gouttiere);
    expect(carte.margin, gouttiere);
    expect(pourcentage.padding, gouttiere);
    expect(total.padding, gouttiere);
  });
}

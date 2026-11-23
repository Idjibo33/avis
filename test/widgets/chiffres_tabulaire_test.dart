import 'package:avis/Models/interaction.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/duel_resultat_pourcentage_widget.dart';
import 'package:avis/widgets/post_reactions_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('pourcentages : chiffres tabulaires et couleurs conservées', (
    tester,
  ) async {
    final FakeInteractionsServices services = FakeInteractionsServices()
      ..interactions = [
        Interaction(choix: 'A', postId: 1),
        Interaction(choix: 'A', postId: 1),
        Interaction(choix: 'B', postId: 1),
      ];

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => InteractionsServicesProvider(interactions: services),
        child: const MaterialApp(
          home: Scaffold(body: DuelResultatPourcentageWidget(postId: 1)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final Text pourcentA = tester.widget<Text>(find.textContaining('A ·'));
    final Text pourcentB = tester.widget<Text>(find.textContaining('B ·'));
    for (final Text texte in [pourcentA, pourcentB]) {
      expect(
        texte.style?.fontFeatures?.map((feature) => feature.feature),
        contains('tnum'),
      );
      expect(texte.style?.fontSize, 14);
    }
    expect(pourcentA.style?.color, noir);
    expect(pourcentB.style?.color, teal);
    expect(pourcentA.data, 'A · 67 %');
    expect(pourcentB.data, 'B · 33 %');
  });

  testWidgets('réactions : le compteur est tabulaire et le libellé intact', (
    tester,
  ) async {
    final FakeInteractionsServices services = FakeInteractionsServices()
      ..interactions = [
        Interaction(choix: 'A', postId: 1),
        Interaction(choix: 'B', postId: 1),
      ];

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => InteractionsServicesProvider(interactions: services),
        child: const MaterialApp(
          home: Scaffold(body: PostReactionsWidget(postId: 1)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final Text compteur = tester.widget<Text>(find.text('2'));
    expect(
      compteur.style?.fontFeatures?.map((feature) => feature.feature),
      contains('tnum'),
    );
    expect(compteur.style?.fontSize, 14);
    expect(find.text('Votes'), findsOneWidget);
  });

  testWidgets('réactions : le repli zéro reste inchangé', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => InteractionsServicesProvider(
          interactions: FakeInteractionsServices(),
        ),
        child: const MaterialApp(
          home: Scaffold(body: PostReactionsWidget(postId: 1)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('0'), findsOneWidget);
    final Text compteur = tester.widget<Text>(find.text('0'));
    expect(
      compteur.style?.fontFeatures?.map((feature) => feature.feature),
      contains('tnum'),
    );
  });
}

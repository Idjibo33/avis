import 'package:avis/Models/interaction.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/duel_resultat_total.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

class InteractionsEnEchec extends FakeInteractionsServices {
  @override
  Future<List<Interaction>> readDataOnce(int postId) async {
    throw Exception('boom');
  }
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> pumpTotal(
    WidgetTester tester,
    FakeInteractionsServices services,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => InteractionsServicesProvider(interactions: services),
        child: const MaterialApp(
          home: Scaffold(body: DuelResultatTotal(postId: 1)),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('une lecture en échec affiche Indisponible sans planter', (
    tester,
  ) async {
    await pumpTotal(tester, InteractionsEnEchec());

    expect(tester.takeException(), isNull);
    expect(find.text('Indisponible'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('aucune interaction est un total à zéro', (tester) async {
    await pumpTotal(tester, FakeInteractionsServices());

    expect(tester.takeException(), isNull);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('Indisponible'), findsNothing);
  });

  testWidgets('le total reflète le nombre réel d interactions', (tester) async {
    final FakeInteractionsServices services = FakeInteractionsServices()
      ..interactions = [
        Interaction(choix: 'A', postId: 1),
        Interaction(choix: 'B', postId: 1),
        Interaction(choix: 'A', postId: 1),
      ];

    await pumpTotal(tester, services);

    expect(tester.takeException(), isNull);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('les totaux utilisent des chiffres tabulaires', (tester) async {
    final FakeInteractionsServices services = FakeInteractionsServices()
      ..interactions = [
        Interaction(choix: 'A', postId: 1),
        Interaction(choix: 'B', postId: 1),
      ];

    await pumpTotal(tester, services);

    final Text nombre = tester.widget<Text>(find.text('2'));
    expect(
      nombre.style?.fontFeatures?.map((feature) => feature.feature),
      contains('tnum'),
    );
    expect(nombre.style?.fontSize, 25);
    expect(nombre.style?.color, noir);
    expect(find.text('Indisponible'), findsNothing);
  });

  testWidgets('Indisponible garde son libellé et sa taille', (tester) async {
    await pumpTotal(tester, InteractionsEnEchec());

    final Text indisponible = tester.widget<Text>(find.text('Indisponible'));
    expect(indisponible.style?.fontSize, 25);
    expect(indisponible.style?.color, noir);
    expect(find.text('0'), findsNothing);
  });
}

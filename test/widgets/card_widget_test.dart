import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('petit écran avec contenus longs : pas de débordement',
      (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final FakeInteractionsServices interactions = FakeInteractionsServices();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) =>
            InteractionsServicesProvider(interactions: interactions),
        child: MaterialApp(
          home: Scaffold(
            body: CardWidget(
              post: buildPost(
                nom: 'Adamou Ismaël Djibo',
                question:
                    'Une question vraiment très longue pour tester le rendu '
                    'sur un petit écran ?',
                optionAText: 'Une option A très longue aussi',
                optionBText: 'Une option B très longue aussi',
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}

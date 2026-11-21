import 'package:avis/widgets/vote_description_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('petit écran : pas de débordement', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: VoteDescriptionWidget())),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('les boutons A et B sont des alternatives au swipe', (
    tester,
  ) async {
    int votesA = 0;
    int votesB = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VoteDescriptionWidget(
            onVoteA: () => votesA++,
            onVoteB: () => votesB++,
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Voter pour A'));
    await tester.tap(find.byTooltip('Voter pour B'));
    await tester.pump();

    expect(votesA, 1);
    expect(votesB, 1);
  });
}

import 'package:avis/widgets/vote_description_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('un votant normal garde les deux cibles actives', (tester) async {
    int votes = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VoteDescriptionWidget(
            onVoteA: () => votes++,
            onVoteB: () => votes++,
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Voter pour A'));
    expect(votes, 1);
    expect(find.text('Touchez une option ou glissez la carte'), findsOneWidget);
  });

  testWidgets('l auteur ne peut pas voter mais peut passer', (tester) async {
    int votes = 0;
    int passes = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VoteDescriptionWidget(
            estAuteur: true,
            onVoteA: () => votes++,
            onVoteB: () => votes++,
            onSkip: () => passes++,
          ),
        ),
      ),
    );

    expect(
      find.text("C'est votre duel : vous ne pouvez pas voter."),
      findsOneWidget,
    );
    expect(find.text('Touchez une option ou glissez la carte'), findsNothing);

    for (final String libelle in ['A', 'B']) {
      final FilledButton bouton = tester.widget<FilledButton>(
        find.descendant(
          of: find.byTooltip('Voter pour $libelle'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(bouton.onPressed, isNull);
      await tester.tap(find.byTooltip('Voter pour $libelle'));
    }

    await tester.tap(find.text('Passer ce duel'));

    expect(votes, 0);
    expect(passes, 1);
    expect(tester.takeException(), isNull);
  });
}

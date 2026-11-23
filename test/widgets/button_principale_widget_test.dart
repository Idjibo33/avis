import 'package:avis/constants.dart';
import 'package:avis/widgets/button_principale_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> pomperBouton(
    WidgetTester tester, {
    required bool chargement,
    VoidCallback? action,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ButtonPrincipaleWidget(
            texte: 'Publier',
            action: action ?? () {},
            chargement: chargement,
          ),
        ),
      ),
    );
  }

  testWidgets('chargement : spinner à côté de Patientez, hauteur conservée', (
    tester,
  ) async {
    await pomperBouton(tester, chargement: true);

    expect(find.text('Patientez'), findsOneWidget);
    expect(find.text('Publier'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    final CircularProgressIndicator spinner = tester.widget(
      find.byType(CircularProgressIndicator),
    );
    expect(spinner.strokeWidth, 2);
    // Fond teal du FilledButton : un spinner teal serait invisible.
    expect(spinner.valueColor?.value, blanc);

    final SizedBox spinnerCadre = tester.widget<SizedBox>(
      find
          .ancestor(
            of: find.byType(CircularProgressIndicator),
            matching: find.byType(SizedBox),
          )
          .first,
    );
    expect(spinnerCadre.width, 18);
    expect(spinnerCadre.height, 18);

    final SizedBox cadre = tester.widget<SizedBox>(find.byType(SizedBox).first);
    expect(cadre.height, 48);
    expect(cadre.width, double.infinity);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );

    final Rect texte = tester.getRect(find.text('Patientez'));
    final Rect indicateur = tester.getRect(
      find.byType(CircularProgressIndicator),
    );
    expect(texte.left, greaterThan(indicateur.right));
  });

  testWidgets('au repos : aucun spinner, action exécutée', (tester) async {
    int appels = 0;
    await pomperBouton(tester, chargement: false, action: () => appels++);

    expect(find.text('Publier'), findsOneWidget);
    expect(find.text('Patientez'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(appels, 1);
  });
}

import 'package:avis/constants.dart';
import 'package:avis/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('le thème applique uniquement noir, blanc et teal', (
    tester,
  ) async {
    late ThemeData theme;

    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme(),
        home: Builder(
          builder: (context) {
            theme = Theme.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(theme.colorScheme.primary, teal);
    expect(theme.colorScheme.onPrimary, blanc);
    expect(theme.colorScheme.surface, blanc);
    expect(theme.colorScheme.onSurface, noir);
    expect(theme.scaffoldBackgroundColor, blanc);
    expect(theme.cardTheme.elevation, 0);
  });

  test('textButtonTheme : foregroundColor pilote tous les états du texte', () {
    final ButtonStyle style = appTheme().textButtonTheme.style!;

    final Color? foreground = style.foregroundColor?.resolve(const {});
    final Color? couleurTexte = style.textStyle?.resolve(const {})?.color;

    expect(foreground, teal);
    // Aucune couleur figée dans textStyle : le disabled suit le thème.
    expect(couleurTexte, isNull);
  });

  test(
    'textChiffresStyle : chiffres tabulaires sans altérer le style titre',
    () {
      expect(
        textChiffresStyle.fontFeatures?.map((feature) => feature.feature),
        contains('tnum'),
      );
      expect(textChiffresStyle.fontSize, textTitreStyle.fontSize);
      expect(textChiffresStyle.fontWeight, textTitreStyle.fontWeight);
      expect(textChiffresStyle.color, textTitreStyle.color);
      expect(textChiffresStyle.letterSpacing, textTitreStyle.letterSpacing);
    },
  );
}

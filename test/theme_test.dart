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
}

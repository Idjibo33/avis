import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/widgets/inscription_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('les deux champs mot de passe sont masqués', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthServicesProviders(
          authServices: FakeAuthServices(),
          profileTableServices: FakeProfileTableServices(),
        ),
        child: const MaterialApp(
          home: Scaffold(body: InscriptionWidget()),
        ),
      ),
    );

    final TextField motDePasse = tester.widget<TextField>(
      find.byType(TextField).at(3),
    );
    final TextField confirmation = tester.widget<TextField>(
      find.byType(TextField).at(4),
    );
    expect(motDePasse.obscureText, isTrue);
    expect(confirmation.obscureText, isTrue);
  });
}

import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/widgets/connexion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<AuthServicesProviders> pumpConnexion(WidgetTester tester) async {
    final AuthServicesProviders auth = AuthServicesProviders(
      authServices: FakeAuthServices(),
      profileTableServices: FakeProfileTableServices(),
    );
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => auth,
        child: const MaterialApp(
          home: Scaffold(body: ConnexionWidget()),
        ),
      ),
    );
    return auth;
  }

  testWidgets('le mot de passe est masqué', (tester) async {
    await pumpConnexion(tester);

    final TextField motDePasse = tester.widget<TextField>(
      find.byType(TextField).at(1),
    );
    expect(motDePasse.obscureText, isTrue);
  });

  testWidgets('la saisie survit à un rebuild du parent', (tester) async {
    final AuthServicesProviders auth = await pumpConnexion(tester);

    await tester.enterText(find.byType(TextField).at(0), 'test@mail.com');
    auth.notifyListeners();
    await tester.pump();

    expect(find.text('test@mail.com'), findsOneWidget);
  });
}

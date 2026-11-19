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

  Future<FakeAuthRepository> pumpFormulaire(WidgetTester tester) async {
    final FakeAuthRepository repository = FakeAuthRepository();
    addTearDown(repository.close);
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthServicesProviders(repository: repository),
        child: const MaterialApp(home: Scaffold(body: ConnexionWidget())),
      ),
    );
    return repository;
  }

  testWidgets('un seul formulaire : pseudo puis mot de passe masqué', (
    tester,
  ) async {
    await pumpFormulaire(tester);

    expect(find.byType(TextField), findsNWidgets(2));
    final TextField motDePasse = tester.widget<TextField>(
      find.byType(TextField).at(1),
    );
    expect(motDePasse.obscureText, isTrue);
    expect(find.text('Email'), findsNothing);
  });

  testWidgets('pseudo inférieur à 3 caractères : message français', (
    tester,
  ) async {
    final FakeAuthRepository repository = await pumpFormulaire(tester);

    await tester.enterText(find.byType(TextField).at(0), 'ab');
    await tester.enterText(find.byType(TextField).at(1), 'motdepasse1');
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Le pseudo doit contenir entre 3 et 20 lettres, chiffres ou tirets bas.',
      ),
      findsOneWidget,
    );
    expect(repository.elevateCalls, 0);
  });

  testWidgets('mot de passe inférieur à 8 caractères : message français', (
    tester,
  ) async {
    final FakeAuthRepository repository = await pumpFormulaire(tester);

    await tester.enterText(find.byType(TextField).at(0), 'joueur_1');
    await tester.enterText(find.byType(TextField).at(1), 'court');
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();

    expect(
      find.text('Le mot de passe doit contenir au moins 8 caractères.'),
      findsOneWidget,
    );
    expect(repository.elevateCalls, 0);
  });
}

import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../fixtures/fakes.dart';

/// Premier abonnement en erreur, les suivants déconnectés : permet de vérifier
/// que « Réessayer » se réabonne réellement au flux d'authentification.
class AuthFluxEnEchecPuisDeconnecte extends FakeAuthServices {
  int abonnements = 0;

  @override
  Stream<AuthState> get authState {
    abonnements++;
    if (abonnements == 1) {
      return Stream<AuthState>.error(Exception('boom'));
    }
    return Stream<AuthState>.value(
      const AuthState(AuthChangeEvent.signedOut, null),
    );
  }
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets(
    'une erreur du flux affiche un état d échec distinct de déconnecté',
    (tester) async {
      final AuthFluxEnEchecPuisDeconnecte services =
          AuthFluxEnEchecPuisDeconnecte();
      final AuthServicesProviders provider = AuthServicesProviders(
        authServices: services,
        profileTableServices: FakeProfileTableServices(),
      );

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => provider,
          child: const MaterialApp(home: AuthGate()),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Impossible de vérifier la session'), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);
      expect(services.abonnements, 1);
    },
  );

  testWidgets('le bouton Réessayer se réabonne au flux auth', (tester) async {
    final AuthFluxEnEchecPuisDeconnecte services =
        AuthFluxEnEchecPuisDeconnecte();
    final AuthServicesProviders provider = AuthServicesProviders(
      authServices: services,
      profileTableServices: FakeProfileTableServices(),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => provider,
        child: const MaterialApp(home: AuthGate()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(services.abonnements, 2);
    expect(find.text('Impossible de vérifier la session'), findsNothing);
    expect(find.text('Connexion'), findsOneWidget);
  });
}

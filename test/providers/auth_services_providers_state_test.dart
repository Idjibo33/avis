import 'dart:async';

import 'package:avis/Helpers/snackbar.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/State/operation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fakes.dart';

class ControlledAuthServices extends FakeAuthServices {
  final List<Completer<void>> _enAttente = [];
  final List<Completer<void>> _enAttenteSignOut = [];
  int appels = 0;

  @override
  Future signInUserWithEmail(String email, String password) {
    appels++;
    final Completer<void> attente = Completer<void>();
    _enAttente.add(attente);
    return attente.future;
  }

  @override
  Future signOut() {
    final Completer<void> attente = Completer<void>();
    _enAttenteSignOut.add(attente);
    return attente.future;
  }

  void terminer({Object? erreur}) => _terminer(_enAttente, erreur);

  void terminerSignOut({Object? erreur}) =>
      _terminer(_enAttenteSignOut, erreur);

  void _terminer(List<Completer<void>> attentes, Object? erreur) {
    for (final Completer<void> attente in attentes) {
      if (attente.isCompleted) continue;
      if (erreur == null) {
        attente.complete();
      } else {
        attente.completeError(erreur);
      }
    }
  }
}

Future<void> pumpAvecMessenger(WidgetTester tester) => tester.pumpWidget(
  MaterialApp(
    home: ScaffoldMessenger(
      key: messengerKey,
      child: const Scaffold(body: SizedBox.shrink()),
    ),
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  AuthServicesProviders buildProvider(ControlledAuthServices services) =>
      AuthServicesProviders(
        authServices: services,
        profileTableServices: FakeProfileTableServices(),
      );

  Future<Map<String, dynamic>> connecter(AuthServicesProviders provider) async {
    final Future<bool> resultat = provider.signInUser(
      email: 'test@mail.com',
      password: 'secret1',
    );
    await Future<void>.value();
    return {'resultat': resultat, 'etat': provider.state};
  }

  test(
    'une connexion en cours est visible et bloque un second appel',
    () async {
      final ControlledAuthServices services = ControlledAuthServices();
      final AuthServicesProviders provider = buildProvider(services);

      final Map<String, dynamic> enCours = await connecter(provider);
      expect(enCours['etat'], isA<OperationRunning>());
      expect(provider.chargement, isTrue);

      final Future<bool> second = provider.signInUser(
        email: 'test@mail.com',
        password: 'secret1',
      );
      expect(services.appels, 1);

      services.terminer();
      expect(await enCours['resultat'], isTrue);
      await second;
      expect(provider.chargement, isFalse);
      expect(provider.state, isA<OperationSucceeded>());
    },
  );

  test('un échec est explicite et l état revient au repos', () async {
    final ControlledAuthServices services = ControlledAuthServices();
    final AuthServicesProviders provider = buildProvider(services);

    final Map<String, dynamic> enCours = await connecter(provider);
    services.terminer(erreur: Exception('boom'));

    expect(await enCours['resultat'], isFalse);
    expect(provider.chargement, isFalse);
    expect(provider.state, isA<OperationFailed>());
    expect(provider.messageErreur, contains('boom'));
  });

  test('un succès ultérieur efface le message d erreur périmé', () async {
    final ControlledAuthServices services = ControlledAuthServices();
    final AuthServicesProviders provider = buildProvider(services);

    final Map<String, dynamic> echec = await connecter(provider);
    services.terminer(erreur: Exception('boom'));
    await echec['resultat'];
    expect(provider.messageErreur, isNotEmpty);

    final Map<String, dynamic> succes = await connecter(provider);
    services.terminer();
    expect(await succes['resultat'], isTrue);
    expect(provider.messageErreur, isEmpty);
    expect(provider.state, isA<OperationSucceeded>());
  });

  testWidgets('une connexion en échec affiche un snackbar', (tester) async {
    await pumpAvecMessenger(tester);

    final ControlledAuthServices services = ControlledAuthServices();
    final AuthServicesProviders provider = buildProvider(services);
    final Future<bool> resultat = provider.signInUser(
      email: 'test@mail.com',
      password: 'secret1',
    );
    services.terminer(erreur: Exception('boom'));
    expect(await resultat, isFalse);

    await tester.pump();
    await tester.pump();
    expect(find.textContaining('boom'), findsOneWidget);
  });

  testWidgets('une déconnexion en échec reste silencieuse comme avant', (
    tester,
  ) async {
    await pumpAvecMessenger(tester);

    final ControlledAuthServices services = ControlledAuthServices();
    final AuthServicesProviders provider = buildProvider(services);
    final Future<bool> resultat = provider.signOutuser();
    services.terminerSignOut(erreur: Exception('boom'));
    expect(await resultat, isFalse);

    await tester.pump();
    await tester.pump();
    expect(provider.state, isA<OperationFailed>());
    expect(provider.messageErreur, contains('boom'));
    expect(find.textContaining('boom'), findsNothing);
  });
}

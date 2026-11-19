import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Services/auth_repository.dart';
import 'package:avis/State/operation_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fakes.dart';

void main() {
  test("l'initialisation publie l'état invité", () async {
    final FakeAuthRepository repository = FakeAuthRepository();
    final AuthServicesProviders provider = AuthServicesProviders(
      repository: repository,
    );

    expect(provider.current.status, AuthSessionStatus.unknown);
    expect(await provider.initialize(), isTrue);
    repository.devenirInvite();
    await Future<void>.value();

    expect(provider.current.status, AuthSessionStatus.guest);
    expect(repository.initializeCalls, 1);
    expect(provider.operation, isA<OperationSucceeded>());
    provider.dispose();
    await repository.close();
  });

  test('une opération en cours bloque le second appel', () async {
    final FakeAuthRepository repository = FakeAuthRepository();
    final AuthServicesProviders provider = AuthServicesProviders(
      repository: repository,
    );
    repository.devenirInvite();

    final Future<bool> premier = provider.elevate(
      pseudo: 'joueur_1',
      password: 'motdepasse1',
    );
    expect(provider.chargement, isTrue);
    final bool second = await provider.signOut();

    expect(second, isFalse);
    expect(repository.signOutCalls, 0);
    expect(await premier, isTrue);
    expect(repository.elevateCalls, 1);
    expect(provider.current.status, AuthSessionStatus.authenticated);
    provider.dispose();
    await repository.close();
  });

  test(
    "un échec d'élévation reste invité et garde un message explicite",
    () async {
      final FakeAuthRepository repository = FakeAuthRepository();
      final AuthServicesProviders provider = AuthServicesProviders(
        repository: repository,
      );
      repository.devenirInvite();
      repository.erreurElevation = Exception('Identifiants refusés');

      final bool resultat = await provider.elevate(
        pseudo: 'joueur_1',
        password: 'motdepasse1',
      );

      expect(resultat, isFalse);
      expect(provider.operation, isA<OperationFailed>());
      expect(provider.messageErreur, contains('Identifiants refusés'));
      expect(provider.current.status, AuthSessionStatus.guest);
      provider.dispose();
      await repository.close();
    },
  );

  test('validation : pseudo court ou mot de passe court refusés', () async {
    final FakeAuthRepository repository = FakeAuthRepository();
    final AuthServicesProviders provider = AuthServicesProviders(
      repository: repository,
    );

    expect(
      await provider.elevate(pseudo: 'ab', password: 'motdepasse1'),
      isFalse,
    );
    expect(provider.messageErreur, contains('pseudo'));

    expect(
      await provider.signIn(pseudo: 'joueur_1', password: 'court'),
      isFalse,
    );
    expect(provider.messageErreur, contains('8 caractères'));
    expect(repository.elevateCalls, 0);
    expect(repository.signInCalls, 0);
    provider.dispose();
    await repository.close();
  });

  test('déconnexion : retour invité sans navigation', () async {
    final FakeAuthRepository repository = FakeAuthRepository();
    final AuthServicesProviders provider = AuthServicesProviders(
      repository: repository,
    );
    repository.devenirAuthentifie();

    expect(await provider.signOut(), isTrue);
    await Future<void>.value();
    expect(repository.signOutCalls, 1);
    expect(provider.current.status, AuthSessionStatus.guest);
    provider.dispose();
    await repository.close();
  });

  test('erreur du flux convertie en état failed', () async {
    final FakeAuthRepository repository = FakeAuthRepository();
    final AuthServicesProviders provider = AuthServicesProviders(
      repository: repository,
    );

    repository.emit(
      const AuthSessionState(status: AuthSessionStatus.failed, error: 'boom'),
    );
    await Future<void>.value();

    expect(provider.current.status, AuthSessionStatus.failed);
    expect(provider.current.error?.toString(), 'boom');
    provider.dispose();
    await repository.close();
  });
}

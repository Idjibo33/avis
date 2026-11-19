import 'package:avis/Services/auth_repository.dart';
import 'package:avis/State/auth_gate_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('session inconnue : chargement', () {
    final AuthGateViewState vue = AuthGateViewState.from(
      const AuthSessionState(status: AuthSessionStatus.unknown),
    );

    expect(vue.status, AuthGateStatus.loading);
    expect(vue.erreur, isNull);
  });

  test('invité : feed affiché directement', () {
    final AuthGateViewState vue = AuthGateViewState.from(
      const AuthSessionState(
        status: AuthSessionStatus.guest,
        authUserId: 'invite-1',
      ),
    );

    expect(vue.status, AuthGateStatus.guest);
  });

  test('authentifié : feed affiché', () {
    final AuthGateViewState vue = AuthGateViewState.from(
      const AuthSessionState(
        status: AuthSessionStatus.authenticated,
        authUserId: 'utilisateur-1',
        pseudo: 'joueur_1',
      ),
    );

    expect(vue.status, AuthGateStatus.authenticated);
  });

  test('échec sans session : état failed distinct avec son erreur', () {
    final AuthGateViewState vue = AuthGateViewState.from(
      const AuthSessionState(status: AuthSessionStatus.failed, error: 'boom'),
    );

    expect(vue.status, AuthGateStatus.failed);
    expect(vue.erreur, 'boom');
  });

  test('échec avec identifiant invité : on reste invité avec erreur', () {
    final AuthGateViewState vue = AuthGateViewState.from(
      const AuthSessionState(
        status: AuthSessionStatus.failed,
        authUserId: 'invite-1',
        error: 'refusé',
      ),
    );

    expect(vue.status, AuthGateStatus.guest);
    expect(vue.erreur, 'refusé');
  });

  test("l'action différée est rejouée une seule fois après succès", () async {
    final AuthElevationController controller = AuthElevationController();
    int appels = 0;
    controller.demander(
      action: () async {
        appels++;
      },
    );

    expect(controller.aUneActionEnAttente, isTrue);
    await controller.reprendre();
    await controller.reprendre();

    expect(appels, 1);
    expect(controller.aUneActionEnAttente, isFalse);
    controller.dispose();
  });

  test("une annulation ne rejoue pas l'action", () async {
    final AuthElevationController controller = AuthElevationController();
    int appels = 0;
    controller.demander(
      action: () async {
        appels++;
      },
    );

    controller.annuler();
    await controller.reprendre();

    expect(appels, 0);
    controller.dispose();
  });
}

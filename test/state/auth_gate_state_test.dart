import 'package:avis/State/auth_gate_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Session _session() => Session(
  accessToken: 'jeton',
  tokenType: 'bearer',
  user: const User(
    id: 'utilisateur',
    appMetadata: <String, dynamic>{},
    userMetadata: null,
    aud: '',
    createdAt: '',
    updatedAt: '',
  ),
);

void main() {
  test('en attente du flux : état chargement', () {
    final AuthGateViewState state = AuthGateViewState.from(
      const AsyncSnapshot<AuthState>.waiting(),
    );

    expect(state.status, AuthGateStatus.loading);
  });

  test('session présente : connecté', () {
    final AuthGateViewState state = AuthGateViewState.from(
      AsyncSnapshot.withData(
        ConnectionState.done,
        AuthState(AuthChangeEvent.signedIn, _session()),
      ),
    );

    expect(state.status, AuthGateStatus.signedIn);
  });

  test('sans session : déconnecté', () {
    final AuthGateViewState state = AuthGateViewState.from(
      AsyncSnapshot.withData(
        ConnectionState.done,
        const AuthState(AuthChangeEvent.signedOut, null),
      ),
    );

    expect(state.status, AuthGateStatus.signedOut);
  });

  test('erreur du flux : échec distinct de déconnecté', () {
    final AuthGateViewState state = AuthGateViewState.from(
      AsyncSnapshot<AuthState>.withError(
        ConnectionState.done,
        Exception('boom'),
      ),
    );

    expect(state.status, AuthGateStatus.failed);
    expect(state.erreur, contains('boom'));
  });
}

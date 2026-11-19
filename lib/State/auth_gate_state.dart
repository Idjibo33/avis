import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthGateStatus { loading, signedIn, signedOut, failed }

/// État du garde-fou d'authentification, dérivé du flux Supabase.
final class AuthGateViewState {
  const AuthGateViewState._(this.status, this.erreur);

  final AuthGateStatus status;
  final String? erreur;

  factory AuthGateViewState.from(AsyncSnapshot<AuthState> snapshot) {
    if (snapshot.hasError) {
      return AuthGateViewState._(
        AuthGateStatus.failed,
        snapshot.error.toString(),
      );
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const AuthGateViewState._(AuthGateStatus.loading, null);
    }
    if (snapshot.hasData && snapshot.data!.session != null) {
      return const AuthGateViewState._(AuthGateStatus.signedIn, null);
    }
    return const AuthGateViewState._(AuthGateStatus.signedOut, null);
  }
}

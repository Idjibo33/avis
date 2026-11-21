import 'package:avis/Services/auth_repository.dart';
import 'package:flutter/foundation.dart';

enum AuthGateStatus { loading, guest, authenticated, failed }

/// Vue exhaustive du flux de session. Un échec qui conserve un identifiant
/// d'invité reste un invité : l'erreur est portée par [erreur] et affichée par
/// la feuille d'élévation, sans masquer le feed.
final class AuthGateViewState {
  const AuthGateViewState._(this.status, this.erreur);

  final AuthGateStatus status;
  final String? erreur;

  factory AuthGateViewState.from(AuthSessionState session) =>
      switch (session.status) {
        AuthSessionStatus.unknown => const AuthGateViewState._(
          AuthGateStatus.loading,
          null,
        ),
        AuthSessionStatus.guest => AuthGateViewState._(
          AuthGateStatus.guest,
          session.error?.toString(),
        ),
        AuthSessionStatus.authenticated => const AuthGateViewState._(
          AuthGateStatus.authenticated,
          null,
        ),
        AuthSessionStatus.failed =>
          session.authUserId != null
              ? AuthGateViewState._(
                  AuthGateStatus.guest,
                  session.error?.toString(),
                )
              : AuthGateViewState._(
                  AuthGateStatus.failed,
                  session.error?.toString(),
                ),
      };
}

/// Action d'écriture différée tant que l'élévation n'est pas confirmée.
///
/// Le flux d'authentification reste l'unique source de vérité : ce contrôleur
/// ne stocke que l'action à reprendre, jamais un état de connexion.
class AuthElevationController extends ChangeNotifier {
  Future<void> Function()? _actionEnAttente;

  bool get aUneActionEnAttente => _actionEnAttente != null;

  void demander({Future<void> Function()? action}) {
    _actionEnAttente = action;
    notifyListeners();
  }

  void annuler() {
    if (_actionEnAttente == null) return;
    _actionEnAttente = null;
    notifyListeners();
  }

  /// Rejoue l'action après une élévation réussie, puis la libère.
  Future<void> reprendre() async {
    final Future<void> Function()? action = _actionEnAttente;
    _actionEnAttente = null;
    notifyListeners();
    if (action != null) await action();
  }
}

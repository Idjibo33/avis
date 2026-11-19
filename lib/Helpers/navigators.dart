import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Screens/authentication_screen.dart';
import 'package:avis/Screens/new_post_screen.dart';
import 'package:avis/Screens/user_profil_screen.dart';
import 'package:avis/Services/auth_repository.dart';
import 'package:avis/State/auth_gate_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Porte d'entrée unique des écritures.
///
/// Un invité voit la feuille d'élévation avant l'action ; un échec annule
/// l'action (elle n'est jamais rejouée), un succès la rejoue une seule fois.
/// L'action est fournie par l'appelant : vote, publication ou profil.
Future<bool> demanderElevation(
  BuildContext context, {
  Future<void> Function()? action,
}) async {
  final AuthServicesProviders auth = context.read<AuthServicesProviders>();
  final AuthSessionStatus statut = auth.current.status;

  if (statut == AuthSessionStatus.authenticated) {
    await action?.call();
    return true;
  }
  // Un échec qui conserve l'identifiant invité reste une écriture invitée.
  final bool estInvite =
      statut == AuthSessionStatus.guest ||
      (statut == AuthSessionStatus.failed && auth.current.authUserId != null);
  if (!estInvite) return false;

  final AuthElevationController elevation = context
      .read<AuthElevationController>();
  elevation.demander(action: action);

  final bool reussi = await AuthenticationScreen.ouvrir(context);
  if (reussi) {
    await elevation.reprendre();
  } else {
    elevation.annuler();
  }
  return reussi;
}

void naviguerNewPostScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NewPostScreen()),
  );
}

void naviguerProfilScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => UserProfilScreen()),
  );
}

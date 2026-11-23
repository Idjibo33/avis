import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Screens/authentication_screen.dart';
import 'package:avis/Screens/new_post_screen.dart';
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
  // AuthServicesProviders vit au-dessus du Navigator : un appel sans ce
  // provider est une erreur de câblage, jamais une action à exécuter à blanc.
  final AuthServicesProviders? auth = _lire<AuthServicesProviders>(context);
  if (auth == null) {
    _signalerIndisponible(context);
    return false;
  }
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

  // AuthGate porte le contrôleur dans la route d'accueil. Une route poussée
  // (Nouveau duel) n'hérite pas de ce provider : on utilise alors un
  // contrôleur éphémère, limité à cet appel. L'état d'auth reste l'unique
  // source de vérité dans AuthServicesProviders.
  final AuthElevationController? fourni = _lire<AuthElevationController>(
    context,
  );
  final AuthElevationController elevation = fourni ?? AuthElevationController();
  try {
    elevation.demander(action: action);

    final bool reussi = await AuthenticationScreen.ouvrir(context);
    if (reussi) {
      await elevation.reprendre();
    } else {
      elevation.annuler();
    }
    return reussi;
  } finally {
    if (fourni == null) elevation.dispose();
  }
}

T? _lire<T extends Object>(BuildContext context) {
  try {
    return context.read<T>();
  } on ProviderNotFoundException {
    return null;
  }
}

void _signalerIndisponible(BuildContext context) {
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    const SnackBar(content: Text('Action indisponible pour le moment.')),
  );
}

void naviguerNewPostScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NewPostScreen()),
  );
}

/// Le changement d'onglet Feed/Profil ne passe pas par ici : il est géré par
/// `MainNavigationShell` via un `IndexedStack`, sans poussée de route.

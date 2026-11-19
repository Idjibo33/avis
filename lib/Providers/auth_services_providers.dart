import 'package:avis/Helpers/snackbar.dart';
import 'package:avis/Helpers/validation.dart';
import 'package:avis/Models/profile.dart';
import 'package:avis/Services/Supabase/auth_services.dart';
import 'package:avis/Services/Supabase/profile_table_services.dart';
import 'package:avis/State/operation_state.dart';
import 'package:flutter/foundation.dart';

class AuthServicesProviders extends ChangeNotifier {
  final AuthServices _authServices;
  final ProfileTableServices _profileTableServices;

  AuthServicesProviders({
    AuthServices? authServices,
    ProfileTableServices? profileTableServices,
  }) : _authServices = authServices ?? AuthServices(),
       _profileTableServices = profileTableServices ?? ProfileTableServices();

  OperationState _state = const OperationIdle();

  OperationState get state => _state;
  bool get chargement => _state.isRunning;
  String get messageErreur => _state.errorMessage ?? '';

  AuthServices get authServices => _authServices;

  void _setState(OperationState nouvelEtat) {
    _state = nouvelEtat;
    notifyListeners();
  }

  /// Une seule opération à la fois ; toute sortie est un état terminal explicite.
  Future<bool> _executer(
    Future<dynamic> Function() action, {
    bool afficherErreur = true,
  }) async {
    if (_state.isRunning) return false;
    _setState(const OperationRunning());
    try {
      await action();
      _setState(const OperationSucceeded(''));
      return true;
    } catch (e) {
      final String message = e.toString();
      _setState(OperationFailed(message));
      if (afficherErreur) showError(message);
      return false;
    }
  }

  Future<bool> signInUser({
    required String email,
    required String password,
  }) async {
    if (!validateConnexionForm(email, password)) return false;
    return _executer(
      () => _authServices.signInUserWithEmail(email.trim(), password.trim()),
    );
  }

  Future<bool> createUser({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String confPassword,
  }) async {
    if (!validateInscriptionForm(nom, prenom, email, password, confPassword)) {
      return false;
    }
    return _executer(() async {
      await _authServices.createUserWithEmail(email.trim(), password.trim());
      await _profileTableServices.addData(
        Profile(nom: nom.trim(), prenom: prenom.trim(), email: email.trim()),
      );
    });
  }

  Future<bool> signInAnonymeUser() {
    return _executer(() => _authServices.signInUserAnonynously());
  }

  Future<bool> signOutuser() {
    // Comportement historique préservé : une déconnexion en échec n'affichait
    // pas de snackbar (l'écran d'authentification reste affiché tel quel).
    return _executer(() => _authServices.signOut(), afficherErreur: false);
  }
}

import 'package:avis/Helpers/snackbar.dart';
import 'package:avis/Helpers/validation.dart';
import 'package:avis/Models/profile.dart';
import 'package:avis/Services/Supabase/auth_services.dart';
import 'package:avis/Services/Supabase/profile_table_services.dart';
import 'package:flutter/foundation.dart';

class AuthServicesProviders extends ChangeNotifier {
  final AuthServices _authServices = AuthServices();
  final ProfileTableServices _profileTableServices = ProfileTableServices();
  AuthServices get authServices => _authServices;
  bool _chargement = false;
  bool get chargement => _chargement;
  String _messageErreur = "";

  Future<bool> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      final validation = validateConnexionForm(email, password);
      if (validation) {
        _chargement = true;
        notifyListeners();
        await _authServices.signInUserWithEmail(email.trim(), password.trim());
        _chargement = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _chargement = false;
      _messageErreur = e.toString();
      notifyListeners();
      showError(_messageErreur);
      return false;
    }
  }

  Future<bool> createUser({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String confPassword,
  }) async {
    try {
      final validation = validateInscriptionForm(
        nom,
        prenom,
        email,
        password,
        confPassword,
      );
      if (validation) {
        _chargement = true;
        notifyListeners();
        await _authServices
            .createUserWithEmail(email.trim(), password.trim())
            .then((value) async {
              await _profileTableServices.addData(
                Profile(
                  nom: nom.trim(),
                  prenom: prenom.trim(),
                  email: email.trim(),
                ),
              );
            });
        _chargement = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _chargement = false;
      _messageErreur = e.toString();
      notifyListeners();
      showError(_messageErreur);
      return false;
    }
  }

  Future<bool> signInAnonymeUser() async {
    try {
      _chargement = true;
      notifyListeners();
      await _authServices.signInUserAnonynously();
      _chargement = false;
      notifyListeners();
      return true;
    } catch (e) {
      _chargement = false;
      _messageErreur = e.toString();
      notifyListeners();
      showError(_messageErreur);
      return false;
    }
  }

  Future signOutuser() async {
    try {
      _chargement = true;
      notifyListeners();
      await _authServices.signOut();
      _chargement = false;
      notifyListeners();
      return true;
    } catch (e) {
      _chargement = false;
      _messageErreur = e.toString();
      notifyListeners();
      return false;
    }
  }
}

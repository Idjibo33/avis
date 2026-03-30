import 'dart:io';

import 'package:avis/Helpers/snackbar.dart';

bool validateInscriptionForm(
  String nom,
  String prenom,
  String email,
  String pw,
  String confPw,
) {
  if (nom.isEmpty ||
      prenom.isEmpty ||
      email.isEmpty ||
      pw.isEmpty ||
      confPw.isEmpty) {
    showError("Toutes les cases sont obligatoires");
    return false;
  }
  if (pw != confPw) {
    showError("les mots de passes ne correspondent pas");
    return false;
  }
  if (pw.length < 6) {
    showError("Le mot de doit avoir plus de 5 caractères");
    return false;
  }
  return true;
}

bool validateConnexionForm(String email, String pw) {
  if (email.isEmpty || pw.isEmpty) {
    showError("Toutes les cases sont obligatoires");
    return false;
  }
  return true;
}

bool validateIdeasDuel(String question, String optionA, String optionB) {
  if (question.isEmpty || optionA.isEmpty || optionB.isEmpty) {
    showError("Toutes les cases sont obligatoires");
    return false;
  }
  return true;
}

bool validateImagesDuel(String question, File? optionA, File? optionB) {
  if (question.isEmpty || optionA == null || optionB == null) {
    showError("Toutes les cases sont obligatoires");
    return false;
  }
  return true;
}

import 'package:avis/Helpers/snackbar.dart';
import 'package:image_picker/image_picker.dart';

/// Un seul identifiant : 3 à 20 lettres, chiffres ou tirets bas.
final RegExp pseudoValide = RegExp(r'^[A-Za-z0-9_]{3,20}$');

/// Renvoie le message à afficher, ou `null` si l'élévation est valide.
String? erreurValidationElevation(String pseudo, String password) {
  if (!pseudoValide.hasMatch(pseudo.trim())) {
    return 'Le pseudo doit contenir entre 3 et 20 lettres, chiffres ou tirets bas.';
  }
  if (password.length < 8) {
    return 'Le mot de passe doit contenir au moins 8 caractères.';
  }
  return null;
}

bool validateIdeasDuel(String question, String optionA, String optionB) {
  if (question.isEmpty || optionA.isEmpty || optionB.isEmpty) {
    showError("Toutes les cases sont obligatoires");
    return false;
  }
  return true;
}

bool validateImagesDuel(String question, XFile? optionA, XFile? optionB) {
  if (question.isEmpty || optionA == null || optionB == null) {
    showError("Toutes les cases sont obligatoires");
    return false;
  }
  return true;
}

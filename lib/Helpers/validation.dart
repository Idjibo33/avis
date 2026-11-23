import 'package:avis/Helpers/snackbar.dart';
import 'package:image_picker/image_picker.dart';

/// Un seul identifiant : 3 à 20 lettres, chiffres ou tirets bas.
final RegExp pseudoValide = RegExp(r'^[A-Za-z0-9_]{3,20}$');

/// Champs d'un formulaire de duel, pour l'indication inline sous le champ
/// fautif. Le SnackBar global reste identique pour ne pas changer les textes.
enum ChampFormulaire { question, optionA, optionB }

String? erreurPseudoElevation(String pseudo) {
  final String valeur = pseudo.trim();
  if (valeur.isEmpty || !pseudoValide.hasMatch(valeur)) {
    return 'Le pseudo doit contenir entre 3 et 20 lettres, chiffres ou tirets bas.';
  }
  return null;
}

String? erreurMotDePasseElevation(String password) {
  if (password.length < 8) {
    return 'Le mot de passe doit contenir au moins 8 caractères.';
  }
  return null;
}

/// Renvoie le message à afficher, ou `null` si l'élévation est valide.
String? erreurValidationElevation(String pseudo, String password) =>
    erreurPseudoElevation(pseudo) ?? erreurMotDePasseElevation(password);

Set<ChampFormulaire> champsIdeasManquants(
  String question,
  String optionA,
  String optionB,
) => <ChampFormulaire>{
  if (question.trim().isEmpty) ChampFormulaire.question,
  if (optionA.trim().isEmpty) ChampFormulaire.optionA,
  if (optionB.trim().isEmpty) ChampFormulaire.optionB,
};

Set<ChampFormulaire> champsImagesManquants(
  String question,
  XFile? optionA,
  XFile? optionB,
) => <ChampFormulaire>{
  if (question.trim().isEmpty) ChampFormulaire.question,
  if (optionA == null) ChampFormulaire.optionA,
  if (optionB == null) ChampFormulaire.optionB,
};

bool validateIdeasDuel(String question, String optionA, String optionB) {
  final bool incomplet = champsIdeasManquants(
    question,
    optionA,
    optionB,
  ).isNotEmpty;
  if (incomplet) {
    showError("Toutes les cases sont obligatoires");
    return false;
  }
  return true;
}

bool validateImagesDuel(String question, XFile? optionA, XFile? optionB) {
  final bool incomplet = champsImagesManquants(
    question,
    optionA,
    optionB,
  ).isNotEmpty;
  if (incomplet) {
    showError("Toutes les cases sont obligatoires");
    return false;
  }
  return true;
}

import 'package:flutter/material.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();

void showSuccess(String message) {
  _afficher(message, Icons.check);
}

void showError(String message) {
  _afficher(message, Icons.error_outline);
}

/// Une seule couleur de fond (noir) : le succès et l'erreur se distinguent
/// par l'icône et par le libellé, jamais par une couleur supplémentaire.
void _afficher(String message, IconData icone) {
  messengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Row(
        spacing: 12,
        children: [
          Icon(icone, color: Colors.white, size: 20),
          Expanded(child: Text(message)),
        ],
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

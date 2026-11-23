import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/button_principale_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Barre d'action commune aux deux formulaires de création de duel.
///
/// Le bouton est toujours le dernier enfant du `Scaffold` (voir
/// `NewPostScreen`) : il reste ancré au-dessus de la zone défilante, au-dessus
/// du clavier et au-dessus de la zone de navigation du système.
class FormActionBarWidget extends StatelessWidget {
  final VoidCallback action;
  final String texte;

  const FormActionBarWidget({
    super.key,
    required this.texte,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: blanc,
        border: Border(top: BorderSide(color: bordureNeutre)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: espaceSm),
        child: Consumer<PostTableProider>(
          builder: (context, post, child) => ButtonPrincipaleWidget(
            texte: texte,
            action: action,
            chargement: post.chargement,
          ),
        ),
      ),
    );
  }
}

import 'package:avis/Helpers/navigators.dart';
import 'package:avis/Widget.dart/bouton_secondaire_widget.dart';
import 'package:flutter/material.dart';

class EmptyListCardWidget extends StatelessWidget {
  const EmptyListCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Aucun post à afficher"),
          BoutonSecondaireWidget(
            texte: "Créer un post",
            action: () => naviguerNewPostScreen(context),
            chargement: false,
          ),
        ],
      ),
    );
  }
}

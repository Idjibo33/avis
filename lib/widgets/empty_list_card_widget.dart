import 'package:avis/Helpers/navigators.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/bouton_secondaire_widget.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:flutter/material.dart';

class EmptyListCardWidget extends StatelessWidget {
  const EmptyListCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: espaceMd,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CorpsTextWidget(texte: "Aucun duel à afficher"),
          BoutonSecondaireWidget(
            texte: "Créer un duel",
            action: () => naviguerNewPostScreen(context),
            chargement: false,
          ),
        ],
      ),
    );
  }
}

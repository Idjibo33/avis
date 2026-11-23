import 'package:avis/Helpers/navigators.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/bouton_secondaire_widget.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:flutter/material.dart';

class EmptyListCardWidget extends StatelessWidget {
  /// Le libellé par défaut reste celui des autres écrans (profil) ; le feed
  /// peut préciser « tous votés » sans dupliquer le widget ni le CTA.
  const EmptyListCardWidget({
    super.key,
    this.texte = "Aucun duel à afficher",
    this.afficherCta = true,
  });

  final String texte;

  /// Le feed masque le CTA quand le « + » de la barre basse est déjà là ; le
  /// profil, sans barre, garde son bouton.
  final bool afficherCta;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: espaceMd,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CorpsTextWidget(texte: texte),
          if (afficherCta)
            BoutonSecondaireWidget(
              texte: "Créer un duel",
              // Même porte que le « + » : pas de formulaire direct pour un invité.
              action: () => demanderElevation(
                context,
                action: () async => naviguerNewPostScreen(context),
              ),
              chargement: false,
            ),
        ],
      ),
    );
  }
}

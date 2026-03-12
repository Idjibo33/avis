import 'package:avis/Widget.dart/bouton_secondaire_widget.dart';
import 'package:avis/Widget.dart/button_principale_widget.dart';
import 'package:avis/Widget.dart/texte_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class InscriptionWidget extends StatelessWidget {
  const InscriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: [
          const TexteFieldWidget(label: "Nom", hint: "ex"),
          const TexteFieldWidget(label: "Prenom", hint: "ex"),
          const TexteFieldWidget(label: "Email", hint: "ex"),
          const TexteFieldWidget(label: "Mot de passe", hint: "ex"),
          const Gap(18),
          ButtonPrincipaleWidget(
            texte: "Créer mon compte",
            action: () {},
            chargement: true,
          ),
          const Gap(8),
          const BoutonSecondaireWidget(texte: "Continuer en tant qu'invité"),
        ],
      ),
    );
  }
}

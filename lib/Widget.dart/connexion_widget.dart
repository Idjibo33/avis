import 'package:avis/Widget.dart/bouton_secondaire_widget.dart';
import 'package:avis/Widget.dart/button_principale_widget.dart';
import 'package:avis/Widget.dart/corps_text_widget.dart';
import 'package:avis/Widget.dart/texte_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class ConnexionWidget extends StatelessWidget {
  const ConnexionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const TexteFieldWidget(label: "Email", hint: "ex"),
          const TexteFieldWidget(label: "Mot de passe", hint: "ex"),
          const Gap(30),
          ButtonPrincipaleWidget(
            texte: "Se connecter",
            action: () {},
            chargement: false,
          ),
          const Gap(20),
          const CorpsTextWidget(texte: "Où connectez-vous avec"),
          const Gap(20),
          const BoutonSecondaireWidget(
            icone: FaIcon(FontAwesomeIcons.google),
            texte: 'Google',
          ),
        ],
      ),
    );
  }
}

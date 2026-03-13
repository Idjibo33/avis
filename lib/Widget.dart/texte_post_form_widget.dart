import 'package:avis/Widget.dart/button_principale_widget.dart';
import 'package:avis/Widget.dart/texte_field_widget.dart';
import 'package:flutter/material.dart';

class TextePostFormWidget extends StatelessWidget {
  const TextePostFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final questionTexteController = TextEditingController();
    final optionATexteController = TextEditingController();
    final optionBTexteController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: [
          TexteFieldWidget(
            controller: questionTexteController,
            label: "Votre question",
            hint: 'Quel photos est approprié pour ...?',
          ),
          TexteFieldWidget(
            controller: optionATexteController,
            lines: 7,

            label: "Option A",
            hint: "Expliquez votre concept en quelques mots",
          ),
          const Divider(thickness: 2),
          TexteFieldWidget(
            controller: optionBTexteController,
            lines: 7,
            label: "Option B",
            hint: "Expliquez votre concept en quelques mots",
          ),
          ButtonPrincipaleWidget(
            texte: "Publiez",
            action: () {},
            chargement: false,
          ),
        ],
      ),
    );
  }
}

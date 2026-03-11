import 'package:avis/widget.dart/corps_text_widget.dart';
import 'package:avis/widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';

class ButtonPrincipaleWidget extends StatelessWidget {
  final VoidCallback action;
  final bool chargement;
  final String texte;
  const ButtonPrincipaleWidget({
    super.key,
    required this.texte,
    required this.action,
    required this.chargement,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: FilledButton(
        onPressed: chargement ? null : action,
        child: chargement
            ? const CorpsTextWidget(texte: "Patientez")
            : TitreTextWidget(texte: texte),
      ),
    );
  }
}

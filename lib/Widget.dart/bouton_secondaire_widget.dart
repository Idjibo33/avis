import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';

class BoutonSecondaireWidget extends StatelessWidget {
  final bool chargement;
  final VoidCallback action;
  final String texte;
  final Icon? icone;
  const BoutonSecondaireWidget({
    super.key,
    this.icone,
    required this.texte,
    required this.action,
    required this.chargement,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ElevatedButton.icon(
        onPressed: chargement ? null : action,
        label: TitreTextWidget(texte: texte),
        icon: chargement ? CircularProgressIndicator.adaptive() : icone,
      ),
    );
  }
}

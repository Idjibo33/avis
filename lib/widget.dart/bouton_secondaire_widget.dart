import 'package:avis/widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';

class BoutonSecondaireWidget extends StatelessWidget {
  final String texte;
  final Icon? icone;
  const BoutonSecondaireWidget({super.key, this.icone, required this.texte});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ElevatedButton.icon(
        onPressed: () {},
        label: TitreTextWidget(texte: texte),
        icon: icone,
      ),
    );
  }
}

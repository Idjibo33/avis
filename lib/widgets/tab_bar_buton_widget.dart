import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';

class TabBarButonWidget extends StatelessWidget {
  final Icon icone;
  final String texte;
  const TabBarButonWidget({
    super.key,
    required this.icone,
    required this.texte,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 18, height: 18, child: FittedBox(child: icone)),
        // Un libellé long ne doit pas pousser l'onglet hors du TabBar.
        Flexible(
          child: TitreTextWidget(
            texte: texte,
            fontSize: 14,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

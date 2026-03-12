import 'package:avis/widget.dart/titre_text_widget.dart';
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
        icone,
        TitreTextWidget(texte: texte),
      ],
    );
  }
}

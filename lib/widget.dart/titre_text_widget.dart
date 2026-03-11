import 'package:avis/constants.dart';
import 'package:flutter/material.dart';

class TitreTextWidget extends StatelessWidget {
  final Color? couleur;
  final String texte;
  const TitreTextWidget({super.key, required this.texte, this.couleur});

  @override
  Widget build(BuildContext context) {
    return Text(texte, style: textTitreStyle.copyWith(color: couleur));
  }
}

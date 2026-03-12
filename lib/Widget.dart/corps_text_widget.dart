import 'package:avis/constants.dart';
import 'package:flutter/material.dart';

class CorpsTextWidget extends StatelessWidget {
  final Color? couleur;
  final String texte;
  const CorpsTextWidget({super.key, required this.texte, this.couleur});

  @override
  Widget build(BuildContext context) {
    return Text(texte, style: textCorpsStyle.copyWith(color: couleur));
  }
}

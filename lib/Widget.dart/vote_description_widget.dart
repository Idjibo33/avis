import 'package:avis/constants.dart';
import 'package:avis/Widget.dart/corps_text_widget.dart';
import 'package:flutter/material.dart';

class VoteDescriptionWidget extends StatelessWidget {
  const VoteDescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Card(
          color: backgroundCouleureBleue,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
            child: const CorpsTextWidget(
              texte: "Swipe à gauche pour A",
              couleur: Colors.white,
            ),
          ),
        ),
        Card(
          color: backgroundCouleureRose,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
            child: const CorpsTextWidget(
              texte: "Swipe à droite pour A",
              couleur: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

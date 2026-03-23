import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:avis/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DuelGagnantWidget extends StatelessWidget {
  final double optionAPourentage;
  final double optionBPourcentage;

  const DuelGagnantWidget({
    super.key,
    required this.optionAPourentage,
    required this.optionBPourcentage,
  });

  @override
  Widget build(BuildContext context) {
    bool isEqual = true;
    String? winner;
    if (optionAPourentage > optionBPourcentage) {
      winner = "A";
    } else if (optionBPourcentage > optionAPourentage) {
      winner = "B";
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(24),
      ),
      color: couleureBleue,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.solidCircleQuestion,
              color: Colors.white,
            ),

            TitreTextWidget(texte: "Match null", couleur: Colors.white),
          ],
        ),
      ),
    );
  }
}

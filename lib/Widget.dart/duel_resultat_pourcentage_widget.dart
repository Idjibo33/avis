import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:avis/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DuelResultatPourcentageWidget extends StatelessWidget {
  final int postId;
  const DuelResultatPourcentageWidget({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Consumer<InteractionsServicesProvider>(
      builder: (context, interactions, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: FutureBuilder(
              future: interactions.optionAPourcentage(postId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final optionA = snapshot.data!.toStringAsFixed(2);

                  return TitreTextWidget(
                    texte: "$optionA %",
                    couleur: couleureBleue,
                  );
                } else {
                  return TitreTextWidget(texte: "0 %", couleur: couleureBleue);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
            child: FutureBuilder(
              future: interactions.optionBPourcentage(postId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final optionB = snapshot.data!.toStringAsFixed(2);
                  return TitreTextWidget(
                    texte: "$optionB %",
                    couleur: couleureRose,
                  );
                } else {
                  return TitreTextWidget(texte: "0 %", couleur: couleureRose);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

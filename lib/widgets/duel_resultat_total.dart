import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DuelResultatTotal extends StatelessWidget {
  final int postId;
  const DuelResultatTotal({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: espaceXl),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(espaceLg),
            child: Column(
              spacing: espaceXs,
              children: [
                const CorpsTextWidget(texte: "Nombre total de votes"),
                Consumer<InteractionsServicesProvider>(
                  builder: (context, interations, child) => FutureBuilder(
                    future: interations.readInteractions(postId: postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const TitreTextWidget(texte: "0", fontSize: 25);
                      }
                      // Le provider avale les erreurs et renvoie null : le distinguer
                      // d'un vrai total à zéro, sans jamais dereferencer null.
                      if (snapshot.hasError || !snapshot.hasData) {
                        return const TitreTextWidget(
                          texte: "Indisponible",
                          fontSize: 25,
                        );
                      }
                      return TitreTextWidget(
                        texte: snapshot.data!.length.toString(),
                        fontSize: 25,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

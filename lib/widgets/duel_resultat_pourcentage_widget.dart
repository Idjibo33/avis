import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

/// Répartition réelle des votes : la barre rend la proportion lisible d'un
/// coup d'œil, les chiffres restent disponibles pour la précision.
class DuelResultatPourcentageWidget extends StatelessWidget {
  final int postId;
  const DuelResultatPourcentageWidget({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Consumer<InteractionsServicesProvider>(
      builder: (context, interactions, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: espaceXl),
        child: FutureBuilder<List<double>>(
          future: Future.wait([
            interactions.optionAPourcentage(postId),
            interactions.optionBPourcentage(postId),
          ]),
          builder: (context, snapshot) {
            final bool pret = snapshot.hasData;
            final double pourcentA = pret ? snapshot.data![0] : 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TitreTextWidget(
                        texte: pret
                            ? 'A · ${pourcentA.toStringAsFixed(0)} %'
                            : 'A · —',
                        couleur: noir,
                        fontSize: 14,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: TitreTextWidget(
                        texte: pret
                            ? 'B · ${(100 - pourcentA).toStringAsFixed(0)} %'
                            : 'B · —',
                        couleur: teal,
                        fontSize: 14,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Gap(espaceSm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(espaceSm),
                  child: SizedBox(
                    height: espaceMd,
                    child: Row(
                      children: [
                        Expanded(
                          flex: pret ? (pourcentA * 10).round() : 0,
                          child: Container(color: pret ? noir : surfaceNeutre),
                        ),
                        Expanded(
                          flex: pret ? ((100 - pourcentA) * 10).round() : 1,
                          child: Container(color: pret ? teal : surfaceNeutre),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

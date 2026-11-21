import 'package:avis/constants.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TextPostContentWidget extends StatelessWidget {
  final String optionA;
  final String optionB;
  final double heights;
  const TextPostContentWidget({
    super.key,
    required this.heights,
    required this.optionA,
    required this.optionB,
  });

  /// Nombre de lignes que peut afficher une option sans sortir de sa hauteur.
  static int _maxLignes(double heights) {
    final double hauteurLigne =
        (textTitreStyle.fontSize ?? 18) * (textTitreStyle.height ?? 1.25);
    final int lignes = ((heights - 2 * espaceLg) / hauteurLigne).floor();
    return lignes > 0 ? lignes : 1;
  }

  @override
  Widget build(BuildContext context) {
    final int maxLignes = _maxLignes(heights);
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: heights,
            child: Container(
              decoration: BoxDecoration(
                color: noir,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(rayonInterne),
                  bottomLeft: Radius.circular(rayonInterne),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(espaceLg),
                child: Center(
                  child: TitreTextWidget(
                    texte: optionA,
                    couleur: blanc,
                    align: TextAlign.center,
                    maxLines: maxLignes,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Gap(espaceXs),
        Expanded(
          child: SizedBox(
            height: heights,
            child: Container(
              decoration: BoxDecoration(
                color: teal,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(rayonInterne),
                  bottomRight: Radius.circular(rayonInterne),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(espaceLg),
                child: Center(
                  child: TitreTextWidget(
                    texte: optionB,
                    couleur: blanc,
                    align: TextAlign.center,
                    maxLines: maxLignes,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

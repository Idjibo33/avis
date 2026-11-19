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

  @override
  Widget build(BuildContext context) {
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

import 'package:avis/constants.dart';
import 'package:avis/Widget.dart/titre_text_widget.dart';
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
                color: couleureBleue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
              ),
              child: Center(
                child: TitreTextWidget(
                  texte: optionA,
                  couleur: Colors.white,
                  align: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        const Gap(2),
        Expanded(
          child: SizedBox(
            height: heights,
            child: Container(
              decoration: BoxDecoration(
                color: couleureRose,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Center(
                child: TitreTextWidget(
                  texte: optionB,
                  couleur: Colors.white,
                  align: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

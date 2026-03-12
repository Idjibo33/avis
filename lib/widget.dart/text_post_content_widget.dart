import 'package:avis/constants.dart';
import 'package:avis/widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TextPostContentWidget extends StatelessWidget {
  const TextPostContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 270,
            child: Container(
              color: couleureBleue,
              child: Center(
                child: TitreTextWidget(
                  texte: "content",
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
            height: 270,
            child: Container(
              color: couleureRose,
              child: Center(
                child: TitreTextWidget(
                  texte: "content",
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

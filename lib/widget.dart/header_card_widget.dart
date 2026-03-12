import 'package:avis/widget.dart/corps_text_widget.dart';
import 'package:avis/widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HeaderCardWidget extends StatelessWidget {
  const HeaderCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          const CircleAvatar(radius: 24, child: TitreTextWidget(texte: "S")),
          const Gap(8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitreTextWidget(texte: "Nom"),
              CorpsTextWidget(texte: "il y'a 10 min"),
            ],
          ),
        ],
      ),
    );
  }
}

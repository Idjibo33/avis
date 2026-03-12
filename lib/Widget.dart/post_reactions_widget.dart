import 'package:avis/constants.dart';
import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostReactionsWidget extends StatelessWidget {
  const PostReactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const FaIcon(FontAwesomeIcons.solidHeart, color: couleureRose),
        Row(
          spacing: 4,
          children: [
            TitreTextWidget(texte: "100"),
            TitreTextWidget(texte: "votes"),
          ],
        ),
      ],
    );
  }
}

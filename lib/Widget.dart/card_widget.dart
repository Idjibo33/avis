import 'package:avis/Widget.dart/header_card_widget.dart';
import 'package:avis/Widget.dart/image_post_content_widget.dart';
import 'package:avis/Widget.dart/post_reactions_widget.dart';
import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:avis/Widget.dart/vote_description_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(24),
          side: BorderSide(color: Colors.white, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HeaderCardWidget(),
            const ImagePostContentWidget(heights: 270),
            const Gap(4),
            const TitreTextWidget(
              texte:
                  "Quel logo choisir pour mon entreprise Quel logo choisir pour mon entreprise Quel logo choisir pour mon entreprise",
              align: TextAlign.center,
            ),
            const Gap(4),
            const VoteDescriptionWidget(),
            const Gap(4),
            const PostReactionsWidget(),
            const Gap(16),
          ],
        ),
      ),
    );
  }
}

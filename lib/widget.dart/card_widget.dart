import 'package:avis/constants.dart';
import 'package:avis/widget.dart/corps_text_widget.dart';
import 'package:avis/widget.dart/header_card_widget.dart';
import 'package:avis/widget.dart/image_post_content_widget.dart';
import 'package:avis/widget.dart/post_reactions_widget.dart';
import 'package:avis/widget.dart/text_post_content_widget.dart';
import 'package:avis/widget.dart/titre_text_widget.dart';
import 'package:avis/widget.dart/vote_description_widget.dart';
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
            const TextPostContentWidget(),
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

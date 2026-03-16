import 'package:avis/Models/post.dart';
import 'package:avis/Widget.dart/header_card_widget.dart';
import 'package:avis/Widget.dart/image_post_content_widget.dart';
import 'package:avis/Widget.dart/post_reactions_widget.dart';
import 'package:avis/Widget.dart/text_post_content_widget.dart';
import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:avis/Widget.dart/vote_description_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CardWidget extends StatelessWidget {
  final Post post;
  const CardWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    bool isTextPost = post.type == 'text';
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
            HeaderCardWidget(nom: post.nom!, date: post.created_at!),
            TitreTextWidget(texte: post.question, align: TextAlign.center),
            const Gap(4),

            isTextPost
                ? TextPostContentWidget(
                    heights: 250,
                    optionA: post.option_a_text!,
                    optionB: post.option_b_text!,
                  )
                : ImagePostContentWidget(
                    heights: 250,
                    optionAUrl: post.option_a_url!,
                    optionBUrl: post.option_b_url!,
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

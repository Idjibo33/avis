import 'package:avis/Models/post.dart';
import 'package:avis/widgets/header_card_widget.dart';
import 'package:avis/widgets/image_post_content_widget.dart';
import 'package:avis/widgets/post_reactions_widget.dart';
import 'package:avis/widgets/text_post_content_widget.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:avis/widgets/vote_description_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CardWidget extends StatelessWidget {
  final Post post;
  const CardWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    bool isTextPost = post.type == 'text';
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(24),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderCardWidget(
              nom: post.nom ?? 'Utilisateur',
              date: post.created_at ?? '',
            ),
            TitreTextWidget(texte: post.question, align: TextAlign.center),
            const Gap(4),

            isTextPost
                ? TextPostContentWidget(
                    heights: 250,
                    optionA: post.option_a_text ?? '',
                    optionB: post.option_b_text ?? '',
                  )
                : ImagePostContentWidget(
                    heights: 250,
                    optionAUrl: post.option_a_url ?? '',
                    optionBUrl: post.option_b_url ?? '',
                  ),
            const Gap(4),
            const VoteDescriptionWidget(),
            const Gap(4),
            PostReactionsWidget(postId: post.id ?? 0),
            const Gap(16),
          ],
        ),
      ),
    );
  }
}

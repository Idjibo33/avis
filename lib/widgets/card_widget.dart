import 'package:avis/Models/post.dart';
import 'package:avis/constants.dart';
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
  final VoidCallback? onVoteA;
  final VoidCallback? onVoteB;
  const CardWidget({super.key, required this.post, this.onVoteA, this.onVoteB});

  @override
  Widget build(BuildContext context) {
    final bool isTextPost = post.type == 'text';
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderCardWidget(
              nom: post.nom ?? 'Utilisateur',
              date: post.created_at ?? '',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: espaceLg,
                vertical: espaceSm,
              ),
              child: TitreTextWidget(
                texte: post.question,
                align: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(espaceSm),
              child: isTextPost
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
            ),
            const Gap(espaceSm),
            VoteDescriptionWidget(onVoteA: onVoteA, onVoteB: onVoteB),
            const Gap(espaceSm),
            PostReactionsWidget(postId: post.id ?? 0),
            const Gap(espaceLg),
          ],
        ),
      ),
    );
  }
}

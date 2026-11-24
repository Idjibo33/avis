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
  final VoidCallback? onSkip;

  /// Transmis au feed pour retirer les cibles de vote d'un duel créé par
  /// l'utilisateur courant.
  final bool estAuteur;
  const CardWidget({
    super.key,
    required this.post,
    this.onVoteA,
    this.onVoteB,
    this.onSkip,
    this.estAuteur = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTextPost = post.type == 'text';
    return SizedBox(
      width: double.infinity,
      child: Card(
        // Le feed donne une hauteur bornée à la carte : le contenu doit pouvoir
        // défiler plutôt que de déborder verticalement du RenderFlex.
        child: SingleChildScrollView(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: espaceLg,
                  vertical: espaceSm,
                ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: espaceLg),
                child: VoteDescriptionWidget(
                  onVoteA: onVoteA,
                  onVoteB: onVoteB,
                  onSkip: onSkip,
                  estAuteur: estAuteur,
                ),
              ),
              const Gap(espaceSm),
              PostReactionsWidget(postId: post.id ?? 0),
              const Gap(espaceLg),
            ],
          ),
        ),
      ),
    );
  }
}

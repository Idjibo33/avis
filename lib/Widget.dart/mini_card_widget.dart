import 'package:avis/Models/post.dart';
import 'package:avis/Screens/resultat_duel_screen.dart';
import 'package:avis/Widget.dart/image_post_content_widget.dart';
import 'package:avis/Widget.dart/post_reactions_widget.dart';
import 'package:avis/Widget.dart/text_post_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MiniCardWidget extends StatelessWidget {
  final Post post;
  const MiniCardWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    bool isTextPost = post.type == 'text';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultatDuelScreen(post: post)),
      ),
      child: SizedBox(
        child: Column(
          children: [
            Stack(
              children: [
                isTextPost
                    ? TextPostContentWidget(
                        heights: 150,
                        optionA: post.option_a_text!,
                        optionB: post.option_b_text!,
                      )
                    : ImagePostContentWidget(
                        heights: 150,
                        optionAUrl: post.option_a_url!,
                        optionBUrl: post.option_b_url!,
                      ),
              ],
            ),
            const Gap(4),
            PostReactionsWidget(postId: post.id!),
          ],
        ),
      ),
    );
  }
}

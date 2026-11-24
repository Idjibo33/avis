import 'package:avis/Models/post.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/image_post_content_widget.dart';
import 'package:avis/widgets/text_post_content_widget.dart';
import 'package:flutter/material.dart';

class ResultatCardWidget extends StatelessWidget {
  final Post post;
  const ResultatCardWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final bool isTextPost = post.type == 'text';
    return SizedBox(
      width: double.infinity,
      child: Card(
        // Même gouttière que la question et les chiffres : les bords du
        // résultat restent alignés sur toute la page.
        margin: const EdgeInsets.symmetric(horizontal: espaceXl),
        child: Padding(
          padding: const EdgeInsets.all(espaceLg),
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
      ),
    );
  }
}

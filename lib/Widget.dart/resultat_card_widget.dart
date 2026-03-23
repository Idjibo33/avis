import 'package:avis/Models/post.dart';
import 'package:avis/Widget.dart/image_post_content_widget.dart';
import 'package:avis/Widget.dart/text_post_content_widget.dart';
import 'package:flutter/material.dart';

class ResultatCardWidget extends StatelessWidget {
  final Post post;
  const ResultatCardWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    bool isTextPost = post.type == 'text';
    return SizedBox(
      width: 400,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(24),
        ),
        child: isTextPost
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
      ),
    );
  }
}

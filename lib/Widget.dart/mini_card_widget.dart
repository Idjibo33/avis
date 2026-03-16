import 'package:avis/Widget.dart/image_post_content_widget.dart';
import 'package:avis/Widget.dart/post_reactions_widget.dart';
import 'package:flutter/material.dart';

class MiniCardWidget extends StatelessWidget {
  const MiniCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(24),
          side: BorderSide(color: Colors.white, width: 2),
        ),
        child: Stack(
          alignment: AlignmentGeometry.bottomCenter,
          children: [const PostReactionsWidget()],
        ),
      ),
    );
  }
}

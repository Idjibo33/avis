import 'package:avis/widgets/expanded_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final double height;
  final String url;
  final String semanticLabel;
  const ImageWidget({
    super.key,
    required this.url,
    required this.height,
    this.semanticLabel = 'Image du duel',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (context, animation, secondaryAnimation) =>
              ExpandedImage(imageUrl: url),
        );
      },
      child: Image.network(
        url,
        fit: BoxFit.cover,
        height: height,
        semanticLabel: semanticLabel,
      ),
    );
  }
}

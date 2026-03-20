import 'package:avis/constants.dart';
import 'package:flutter/material.dart';

class ExpandedImage extends StatelessWidget {
  final String imageUrl;
  const ExpandedImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.center,
      children: [
        Image.network(imageUrl),
        SafeArea(
          child: CloseButton(
            style: ButtonStyle(
              iconSize: WidgetStatePropertyAll(24),
              backgroundColor: WidgetStatePropertyAll(backgroundCouleureBleue),
            ),
            color: couleureRose,
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}

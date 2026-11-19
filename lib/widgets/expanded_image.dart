import 'package:avis/constants.dart';
import 'package:flutter/material.dart';

class ExpandedImage extends StatelessWidget {
  final String imageUrl;
  const ExpandedImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.network(imageUrl),
        SafeArea(
          child: CloseButton(
            style: ButtonStyle(
              iconSize: WidgetStatePropertyAll(24),
              backgroundColor: WidgetStatePropertyAll(noir),
              foregroundColor: WidgetStatePropertyAll(blanc),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}

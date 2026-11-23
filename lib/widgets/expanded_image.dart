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
        // L'image est bornée à l'écran : un fichier très grand ne peut pas
        // dépasser le cadre de la boîte de dialogue.
        Image.network(
          imageUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
          semanticLabel: 'Image agrandie du duel',
        ),
        Align(
          alignment: Alignment.topRight,
          child: SafeArea(
            child: CloseButton(
              style: ButtonStyle(
                iconSize: WidgetStatePropertyAll(24),
                backgroundColor: WidgetStatePropertyAll(noir),
                foregroundColor: WidgetStatePropertyAll(blanc),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }
}

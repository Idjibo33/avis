import 'package:avis/Widget.dart/button_principale_widget.dart';
import 'package:avis/Widget.dart/image_field_widget.dart';
import 'package:avis/Widget.dart/texte_field_widget.dart';
import 'package:flutter/material.dart';

class PhotosPostFormWidget extends StatelessWidget {
  const PhotosPostFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: [
          const TexteFieldWidget(
            label: "Votre question",
            hint: 'Quel photos est approprié pour ...?',
          ),
          const ImageFieldWidget(label: "Option A"),
          const Divider(thickness: 2),
          const ImageFieldWidget(label: "Option B"),
          ButtonPrincipaleWidget(
            texte: "Publiez",
            action: () {},
            chargement: false,
          ),
        ],
      ),
    );
  }
}

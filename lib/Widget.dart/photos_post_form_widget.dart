import 'dart:io';

import 'package:avis/Widget.dart/button_principale_widget.dart';
import 'package:avis/Widget.dart/image_field_widget.dart';
import 'package:avis/Widget.dart/texte_field_widget.dart';
import 'package:flutter/material.dart';

class PhotosPostFormWidget extends StatefulWidget {
  const PhotosPostFormWidget({super.key});

  @override
  State<PhotosPostFormWidget> createState() => _PhotosPostFormWidgetState();
}

class _PhotosPostFormWidgetState extends State<PhotosPostFormWidget> {
  File? optionAImage;
  File? optionBImage;
  @override
  Widget build(BuildContext context) {
    final texteController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: [
          TexteFieldWidget(
            label: "Votre question",
            hint: 'Quel photos est approprié pour ...?',
            controller: texteController,
          ),
          ImageFieldWidget(
            label: "Option A",
            imagePicked: (File i) {
              setState(() {
                optionAImage = i;
              });
            },
          ),
          const Divider(thickness: 2),
          ImageFieldWidget(
            label: "Option B",
            imagePicked: (File i) {
              setState(() {
                optionBImage = i;
              });
            },
          ),
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

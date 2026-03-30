import 'dart:io';

import 'package:avis/Helpers/validation.dart';
import 'package:avis/Models/post.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Widget.dart/button_principale_widget.dart';
import 'package:avis/Widget.dart/image_field_widget.dart';
import 'package:avis/Widget.dart/texte_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhotosPostFormWidget extends StatefulWidget {
  const PhotosPostFormWidget({super.key});

  @override
  State<PhotosPostFormWidget> createState() => _PhotosPostFormWidgetState();
}

class _PhotosPostFormWidgetState extends State<PhotosPostFormWidget> {
  final texteController = TextEditingController();

  File? optionAImage;
  File? optionBImage;
  @override
  void initState() {
    optionAImage = null;
    optionBImage = null;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    texteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: [
          TexteFieldWidget(
            label: "Votre question",
            hint: 'Entrez la question de votre duel',
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
          Consumer<PostTableProider>(
            builder: (context, post, child) => ButtonPrincipaleWidget(
              texte: "Publiez",
              action: () async {
                final validation = validateImagesDuel(
                  texteController.text,
                  optionAImage,
                  optionBImage,
                );

                if (validation) {
                  await post.addPost(
                    post: Post(question: texteController.text, type: "image"),
                    optionA: optionAImage,
                    optionB: optionBImage,
                  );
                  initState();
                }
              },
              chargement: post.chargement,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:avis/Helpers/navigators.dart';
import 'package:avis/Helpers/validation.dart';
import 'package:avis/Models/post.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/form_action_bar_widget.dart';
import 'package:avis/widgets/image_field_widget.dart';
import 'package:avis/widgets/texte_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PhotosPostFormWidget extends StatefulWidget {
  const PhotosPostFormWidget({super.key});

  @override
  State<PhotosPostFormWidget> createState() => _PhotosPostFormWidgetState();
}

class _PhotosPostFormWidgetState extends State<PhotosPostFormWidget> {
  final texteController = TextEditingController();

  XFile? optionAImage;
  XFile? optionBImage;
  final Set<ChampFormulaire> _champsManquants = <ChampFormulaire>{};

  @override
  void dispose() {
    texteController.dispose();
    super.dispose();
  }

  void _optionAChoisie(XFile image) {
    setState(() {
      optionAImage = image;
      _champsManquants.remove(ChampFormulaire.optionA);
    });
  }

  void _optionBChoisie(XFile image) {
    setState(() {
      optionBImage = image;
      _champsManquants.remove(ChampFormulaire.optionB);
    });
  }

  void _optionARetiree() {
    setState(() {
      optionAImage = null;
      _champsManquants.add(ChampFormulaire.optionA);
    });
  }

  void _optionBRetiree() {
    setState(() {
      optionBImage = null;
      _champsManquants.add(ChampFormulaire.optionB);
    });
  }

  Future<void> _publier(PostTableProider post) async {
    setState(() {
      _champsManquants
        ..clear()
        ..addAll(
          champsImagesManquants(
            texteController.text,
            optionAImage,
            optionBImage,
          ),
        );
    });
    if (!validateImagesDuel(texteController.text, optionAImage, optionBImage)) {
      return;
    }

    await demanderElevation(
      context,
      action: () async {
        final bool publie = await post.addPost(
          post: Post(question: texteController.text.trim(), type: "image"),
          optionA: optionAImage,
          optionB: optionBImage,
        );
        if (!publie || !mounted) return;
        setState(() {
          optionAImage = null;
          optionBImage = null;
          texteController.clear();
          _champsManquants.clear();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: espaceXl),
      // Les deux sélecteurs d'image occupent plus de 500 px : le bouton reste
      // ancré sous la zone défilante pour rester visible et tactile.
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                TexteFieldWidget(
                  label: "Votre question",
                  hint: 'Entrez la question de votre duel',
                  controller: texteController,
                  erreur: _champsManquants.contains(ChampFormulaire.question)
                      ? 'Ce champ est obligatoire.'
                      : null,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) =>
                      _publier(context.read<PostTableProider>()),
                  onChanged: (_) {
                    if (_champsManquants.contains(ChampFormulaire.question)) {
                      setState(
                        () => _champsManquants.remove(ChampFormulaire.question),
                      );
                    }
                  },
                ),
                ImageFieldWidget(
                  label: "Option A",
                  image: optionAImage,
                  imagePicked: _optionAChoisie,
                  imageRemoved: _optionARetiree,
                  erreur: _champsManquants.contains(ChampFormulaire.optionA)
                      ? 'Ajoutez une image.'
                      : null,
                ),
                const Divider(),
                ImageFieldWidget(
                  label: "Option B",
                  image: optionBImage,
                  imagePicked: _optionBChoisie,
                  imageRemoved: _optionBRetiree,
                  erreur: _champsManquants.contains(ChampFormulaire.optionB)
                      ? 'Ajoutez une image.'
                      : null,
                ),
              ],
            ),
          ),
          FormActionBarWidget(
            texte: 'Publier',
            action: () => _publier(context.read<PostTableProider>()),
          ),
        ],
      ),
    );
  }
}

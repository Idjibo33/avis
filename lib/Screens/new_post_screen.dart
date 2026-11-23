import 'package:avis/Helpers/responsiveness.dart';
import 'package:avis/widgets/photos_post_form_widget.dart';
import 'package:avis/widgets/tab_bar_buton_widget.dart';
import 'package:avis/widgets/texte_post_form_widget.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const TitreTextWidget(texte: 'Nouveau duel')),
        // Le bouton « Publier » vit dans le bas de cet écran : le SafeArea
        // l'écarte de la barre de navigation gestuelle du téléphone.
        body: SafeArea(
          bottom: true,
          child: Responsiveness(
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(
                      child: TabBarButonWidget(
                        icone: const FaIcon(FontAwesomeIcons.image),
                        texte: 'Photos',
                      ),
                    ),
                    const Tab(
                      child: TabBarButonWidget(
                        icone: FaIcon(FontAwesomeIcons.lightbulb),
                        texte: 'Idées',
                      ),
                    ),
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [PhotosPostFormWidget(), TextePostFormWidget()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

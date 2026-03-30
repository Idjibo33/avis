import 'package:avis/Helpers/responsiveness.dart';
import 'package:avis/Widget.dart/photos_post_form_widget.dart';
import 'package:avis/Widget.dart/tab_bar_buton_widget.dart';
import 'package:avis/Widget.dart/texte_post_form_widget.dart';
import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: TitreTextWidget(texte: "Nouveau duel")),
        body: Responsiveness(
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(
                    child: TabBarButonWidget(
                      icone: const FaIcon(FontAwesomeIcons.image),
                      texte: "Photos",
                    ),
                  ),
                  const Tab(
                    child: TabBarButonWidget(
                      icone: FaIcon(FontAwesomeIcons.lightbulb),
                      texte: "Idées",
                    ),
                  ),
                ],
              ),
              Expanded(
                child: const TabBarView(
                  children: [PhotosPostFormWidget(), TextePostFormWidget()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

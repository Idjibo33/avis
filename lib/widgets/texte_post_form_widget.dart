import 'package:avis/Helpers/navigators.dart';
import 'package:avis/Helpers/validation.dart';
import 'package:avis/Models/post.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/form_action_bar_widget.dart';
import 'package:avis/widgets/texte_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextePostFormWidget extends StatefulWidget {
  const TextePostFormWidget({super.key});

  @override
  State<TextePostFormWidget> createState() => _TextePostFormWidgetState();
}

class _TextePostFormWidgetState extends State<TextePostFormWidget> {
  final TextEditingController questionTexteController = TextEditingController();
  final TextEditingController optionATexteController = TextEditingController();
  final TextEditingController optionBTexteController = TextEditingController();
  final Set<ChampFormulaire> _champsManquants = <ChampFormulaire>{};

  @override
  void dispose() {
    questionTexteController.dispose();
    optionATexteController.dispose();
    optionBTexteController.dispose();
    super.dispose();
  }

  void _effacerErreur(ChampFormulaire champ) {
    if (_champsManquants.contains(champ)) {
      setState(() => _champsManquants.remove(champ));
    }
  }

  String? _erreur(ChampFormulaire champ) =>
      _champsManquants.contains(champ) ? 'Ce champ est obligatoire.' : null;

  Future<void> _publier(PostTableProider post) async {
    setState(() {
      _champsManquants
        ..clear()
        ..addAll(
          champsIdeasManquants(
            questionTexteController.text,
            optionATexteController.text,
            optionBTexteController.text,
          ),
        );
    });
    if (!validateIdeasDuel(
      questionTexteController.text,
      optionATexteController.text,
      optionBTexteController.text,
    )) {
      return;
    }

    await demanderElevation(
      context,
      action: () async {
        final bool publie = await post.addPost(
          post: Post(
            created_at: '',
            user: '',
            question: questionTexteController.text.trim(),
            type: "text",
            option_a_text: optionATexteController.text.trim(),
            option_a_url: "",
            option_b_text: optionBTexteController.text.trim(),
            option_b_url: "",
          ),
        );
        if (!publie || !mounted) return;
        setState(() {
          questionTexteController.clear();
          optionATexteController.clear();
          optionBTexteController.clear();
          _champsManquants.clear();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Même schéma que l'onglet Photos : la zone saisie défile, « Publier »
    // reste ancré en bas et visible sur un écran de 320x500.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: espaceXl),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                TexteFieldWidget(
                  controller: questionTexteController,
                  label: "Votre question",
                  hint: 'Entrez la question de votre duel',
                  erreur: _erreur(ChampFormulaire.question),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  onChanged: (_) => _effacerErreur(ChampFormulaire.question),
                ),
                TexteFieldWidget(
                  controller: optionATexteController,
                  lines: 7,
                  label: "Option A",
                  hint: "Entrez l'option A de votre duel",
                  erreur: _erreur(ChampFormulaire.optionA),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  onChanged: (_) => _effacerErreur(ChampFormulaire.optionA),
                ),
                const Divider(),
                TexteFieldWidget(
                  controller: optionBTexteController,
                  lines: 7,
                  label: "Option B",
                  hint: "Entrez l'option B de votre duel",
                  erreur: _erreur(ChampFormulaire.optionB),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) =>
                      _publier(context.read<PostTableProider>()),
                  onChanged: (_) => _effacerErreur(ChampFormulaire.optionB),
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

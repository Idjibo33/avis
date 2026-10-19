import 'package:avis/Helpers/validation.dart';
import 'package:avis/Models/post.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/widgets/button_principale_widget.dart';
import 'package:avis/widgets/texte_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextePostFormWidget extends StatefulWidget {
  const TextePostFormWidget({super.key});

  @override
  State<TextePostFormWidget> createState() => _TextePostFormWidgetState();
}

class _TextePostFormWidgetState extends State<TextePostFormWidget> {
  final TextEditingController questionTexteController =
      TextEditingController();
  final TextEditingController optionATexteController =
      TextEditingController();
  final TextEditingController optionBTexteController =
      TextEditingController();

  @override
  void dispose() {
    questionTexteController.dispose();
    optionATexteController.dispose();
    optionBTexteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: [
          TexteFieldWidget(
            controller: questionTexteController,
            label: "Votre question",
            hint: 'Entrez la question de votre duel',
          ),
          TexteFieldWidget(
            controller: optionATexteController,
            lines: 7,
            label: "Option A",
            hint: "Entrez l'option A de votre duel",
          ),
          const Divider(thickness: 2),
          TexteFieldWidget(
            controller: optionBTexteController,
            lines: 7,
            label: "Option B",
            hint: "Entrez l'option B de votre duel",
          ),
          Consumer<PostTableProider>(
            builder: (context, post, child) => ButtonPrincipaleWidget(
              texte: "Publiez",
              action: () async {
                final validation = validateIdeasDuel(
                  questionTexteController.text,
                  optionATexteController.text,
                  optionBTexteController.text,
                );
                if (validation) {
                  await post.addPost(
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
                  questionTexteController.clear();
                  optionATexteController.clear();
                  optionBTexteController.clear();
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

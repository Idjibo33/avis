import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PostReactionsWidget extends StatelessWidget {
  final int postId;
  const PostReactionsWidget({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: espaceSm,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const FaIcon(FontAwesomeIcons.solidHeart, color: teal, size: 18),
        Row(
          spacing: espaceXs,
          children: [
            Consumer<InteractionsServicesProvider>(
              builder: (context, interaction, child) => FutureBuilder(
                future: interaction.readInteractions(postId: postId),
                builder: (context, snapshot) {
                  final String valeur = snapshot.hasData
                      ? snapshot.data!.length.toString()
                      : '0';
                  return Text(
                    valeur,
                    style: textChiffresStyle.copyWith(fontSize: 14),
                  );
                },
              ),
            ),
            const TitreTextWidget(texte: "Votes", fontSize: 14),
          ],
        ),
      ],
    );
  }
}

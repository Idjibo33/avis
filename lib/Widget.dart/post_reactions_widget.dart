import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/constants.dart';
import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PostReactionsWidget extends StatelessWidget {
  final int postId;
  const PostReactionsWidget({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const FaIcon(FontAwesomeIcons.solidHeart, color: couleureRose),
        Row(
          spacing: 4,
          children: [
            Consumer<InteractionsServicesProvider>(
              builder: (context, interaction, child) => FutureBuilder(
                future: interaction.readInteractions(postId: postId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return TitreTextWidget(
                      texte: snapshot.data!.length.toString(),
                    );
                  }
                  return const Center(child: TitreTextWidget(texte: "0"));
                },
              ),
            ),

            const TitreTextWidget(texte: "Votes"),
          ],
        ),
      ],
    );
  }
}

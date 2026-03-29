import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Widget.dart/corps_text_widget.dart';
import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DuelResultatTotal extends StatelessWidget {
  final int postId;
  const DuelResultatTotal({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const CorpsTextWidget(texte: "Nombre total de votes"),
                Consumer<InteractionsServicesProvider>(
                  builder: (context, interations, child) => FutureBuilder(
                    future: interations.readInteractions(postId: postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const TitreTextWidget(texte: "0");
                      }
                      if (snapshot.hasError) {
                        return TitreTextWidget(
                          texte: snapshot.error.toString(),
                        );
                      } else {
                        return TitreTextWidget(
                          texte: snapshot.data!.length.toString(),
                        );
                      }
                    },
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

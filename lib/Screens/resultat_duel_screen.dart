import 'package:avis/Models/post.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Widget.dart/duel_resultat_pourcentage_widget.dart';
import 'package:avis/Widget.dart/list_tile_widget.dart';
import 'package:avis/Widget.dart/resultat_card_widget.dart';
import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:avis/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ResultatDuelScreen extends StatelessWidget {
  final Post post;
  const ResultatDuelScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TitreTextWidget(texte: "Resultat du duel")),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const Gap(12),
                TitreTextWidget(texte: post.question, align: TextAlign.center),
                const Gap(12),
                ResultatCardWidget(post: post),
                DuelResultatPourcentageWidget(postId: post.id!),
              ],
            ),
          ),
          Consumer<InteractionsServicesProvider>(
            builder: (context, interactions, child) => FutureBuilder(
              future: interactions.readInteractions(postId: post.id!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null || snapshot.data!.isNotEmpty) {
                    final vote = snapshot.data;
                    return SliverList.builder(
                      itemCount: vote!.length,
                      itemBuilder: (context, index) => ListTileWidget(
                        leading: FaIcon(
                          FontAwesomeIcons.layerGroup,
                          color: vote[index].choix == "A"
                              ? couleureBleue
                              : couleureRose,
                        ),
                        titre: vote[index].choix!,
                      ),
                    );
                  }
                }
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: TitreTextWidget(texte: snapshot.error.toString()),
                  );
                }
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

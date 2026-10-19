import 'package:avis/Helpers/responsiveness.dart';
import 'package:avis/Models/post.dart';
import 'package:avis/widgets/duel_resultat_pourcentage_widget.dart';
import 'package:avis/widgets/duel_resultat_total.dart';
import 'package:avis/widgets/resultat_card_widget.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ResultatDuelScreen extends StatelessWidget {
  final Post post;
  const ResultatDuelScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TitreTextWidget(texte: "Resultat du duel")),
      body: Responsiveness(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(12),
              TitreTextWidget(texte: post.question, align: TextAlign.center),
              const Gap(12),
              ResultatCardWidget(post: post),
              DuelResultatPourcentageWidget(postId: post.id ?? 0),
              DuelResultatTotal(postId: post.id ?? 0),
              const Gap(12),
            ],
          ),
        ),
      ),
    );
  }
}

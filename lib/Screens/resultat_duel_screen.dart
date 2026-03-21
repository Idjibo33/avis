import 'package:avis/Models/post.dart';
import 'package:avis/Widget.dart/duel_gagnant_widget.dart';
import 'package:avis/Widget.dart/duel_resultat_pourcentage_widget.dart';
import 'package:avis/Widget.dart/resultat_card_widget.dart';
import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:avis/Widget.dart/vote_description_widget.dart';
import 'package:avis/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class ResultatDuelScreen extends StatelessWidget {
  final Post post;
  const ResultatDuelScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TitreTextWidget(texte: "Resultat du duel")),
      body: ListView(
        children: [
          Gap(12),
          TitreTextWidget(texte: post.question, align: TextAlign.center),
          Gap(12),
          ResultatCardWidget(post: post),
          DuelResultatPourcentageWidget(postId: post.id!),
          Gap(16),
          DuelGagnantWidget(),
        ],
      ),
    );
  }
}

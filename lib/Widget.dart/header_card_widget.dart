import 'package:avis/Widget.dart/corps_text_widget.dart';
import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:avis/Widget.dart/user_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HeaderCardWidget extends StatelessWidget {
  final String nom;
  final String date;
  const HeaderCardWidget({super.key, required this.nom, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          const UserAvatarWidget(radius: 24),
          const Gap(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitreTextWidget(texte: nom),
              CorpsTextWidget(texte: date),
            ],
          ),
        ],
      ),
    );
  }
}

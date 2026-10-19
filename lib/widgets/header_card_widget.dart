import 'package:avis/Helpers/format_date.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:avis/widgets/user_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HeaderCardWidget extends StatelessWidget {
  final String nom;
  final String date;
  const HeaderCardWidget({super.key, required this.nom, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          UserAvatarWidget(radius: 24, nom: nom),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitreTextWidget(
                  texte: nom,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                CorpsTextWidget(texte: formatDate(date)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

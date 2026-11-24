import 'package:avis/Helpers/format_date.dart';
import 'package:avis/constants.dart';
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
      padding: const EdgeInsets.all(espaceLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserAvatarWidget(radius: 24, nom: nom),
          const Gap(espaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitreTextWidget(
                  texte: nom,
                  fontSize: 14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Le libellé court reste lisible d'un coup d'œil ; le tooltip
                // garde la date exacte accessible au survol et aux lecteurs.
                Tooltip(
                  message: formatDateComplete(date),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 13,
                        color: texteSecondaire,
                      ),
                      const Gap(espaceXs),
                      Flexible(
                        child: CorpsTextWidget(
                          texte: formatDateRelative(date),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:avis/constants.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:avis/widgets/user_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// En-tête de profil : une surface carte, un avatar et une hiérarchie
/// nom / mention claire. Le nom peut occuper deux lignes avant d'être tronqué.
class ProfileHeaderWidget extends StatelessWidget {
  final String nom;
  final String prenom;
  final double radius;
  const ProfileHeaderWidget({
    super.key,
    required this.nom,
    required this.prenom,
    this.radius = 32,
  });

  String get nomComplet {
    final String complet = '$nom $prenom'.trim();
    return complet.isEmpty ? 'Utilisateur' : complet;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(espaceLg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserAvatarWidget(radius: radius, nom: nom),
            const Gap(espaceLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TitreTextWidget(
                    texte: nomComplet,
                    fontSize: 17,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(espaceXs),
                  const CorpsTextWidget(texte: 'Votre espace Avis'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

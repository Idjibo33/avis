import 'package:avis/constants.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:avis/widgets/user_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String nom;
  final String prenom;
  final double radius;
  const ProfileHeaderWidget({
    super.key,
    required this.nom,
    required this.prenom,
    this.radius = 40,
  });

  String get nomComplet {
    final String complet = '$nom $prenom'.trim();
    return complet.isEmpty ? 'Utilisateur' : complet;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserAvatarWidget(radius: radius, nom: nom),
        const Gap(espaceLg),
        Expanded(
          child: TitreTextWidget(
            texte: nomComplet,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';

class UserAvatarWidget extends StatelessWidget {
  final String nom;
  final double radius;
  const UserAvatarWidget({super.key, required this.radius, required this.nom});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: TitreTextWidget(texte: nom[0], fontSize: radius),
    );
  }
}

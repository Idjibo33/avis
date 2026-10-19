import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';

class UserAvatarWidget extends StatelessWidget {
  final String nom;
  final double radius;
  const UserAvatarWidget({super.key, required this.radius, required this.nom});

  String get initiale {
    final String nomNettoye = nom.trim();
    if (nomNettoye.isEmpty) {
      return '?';
    }
    return String.fromCharCode(nomNettoye.runes.first);
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: TitreTextWidget(texte: initiale, fontSize: radius),
    );
  }
}

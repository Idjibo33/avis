import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';

class UserAvatarWidget extends StatelessWidget {
  final double radius;
  const UserAvatarWidget({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: TitreTextWidget(texte: "S", fontSize: radius),
    );
  }
}

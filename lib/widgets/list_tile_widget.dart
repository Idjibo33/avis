import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  final VoidCallback? action;
  final Icon? leading;
  final String titre;
  const ListTileWidget({
    super.key,
    required this.titre,
    this.leading,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: action,
      leading: leading,
      title: TitreTextWidget(texte: titre, fontSize: 14),
    );
  }
}

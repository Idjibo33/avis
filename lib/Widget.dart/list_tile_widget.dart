import 'package:avis/Widget.dart/titre_text_widget.dart';
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
    return Card(
      child: ListTile(
        onTap: action,
        leading: leading,
        title: TitreTextWidget(texte: titre),
      ),
    );
  }
}

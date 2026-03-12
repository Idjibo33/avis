import 'package:avis/widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  final Icon? leading;
  final String titre;
  const ListTileWidget({super.key, required this.titre, this.leading});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: leading,
        title: TitreTextWidget(texte: titre),
      ),
    );
  }
}

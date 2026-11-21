import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';

class BoutonSecondaireWidget extends StatelessWidget {
  final bool chargement;
  final VoidCallback action;
  final String texte;
  final Icon? icone;
  const BoutonSecondaireWidget({
    super.key,
    this.icone,
    required this.texte,
    required this.action,
    required this.chargement,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: chargement ? null : action,
        label: TitreTextWidget(texte: texte, fontSize: 14),
        icon: chargement
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              )
            : (icone ?? const Icon(Icons.arrow_forward, size: 18)),
      ),
    );
  }
}

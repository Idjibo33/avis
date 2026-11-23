import 'package:avis/constants.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';

class ButtonPrincipaleWidget extends StatelessWidget {
  final VoidCallback action;
  final bool chargement;
  final String texte;
  const ButtonPrincipaleWidget({
    super.key,
    required this.texte,
    required this.action,
    required this.chargement,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: FilledButton(
        onPressed: chargement ? null : action,
        child: chargement
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 18,
                    height: 18,
                    // Fond teal du FilledButton : le spinner doit rester blanc.
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(blanc),
                    ),
                  ),
                  const SizedBox(width: espaceSm),
                  const CorpsTextWidget(texte: "Patientez"),
                ],
              )
            : TitreTextWidget(texte: texte, fontSize: 14),
      ),
    );
  }
}

import 'package:avis/constants.dart';
import 'package:avis/widgets/connexion_widget.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Feuille modale réutilisable d'élévation d'un compte invité.
///
/// Ce n'est plus un écran racine : le feed reste monté derrière, et la feuille
/// ne contient qu'un formulaire pseudo + mot de passe.
class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  /// Ouvre la feuille au-dessus du widget courant.
  /// Renvoie `true` uniquement après une élévation réussie.
  static Future<bool> ouvrir(BuildContext context) async {
    final bool? resultat = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: blanc,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(rayonCarte)),
      ),
      builder: (BuildContext context) => const Padding(
        padding: EdgeInsets.fromLTRB(espaceLg, espaceMd, espaceLg, espaceXl),
        child: AuthenticationScreen(),
      ),
    );
    return resultat ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: bordureNeutre,
                borderRadius: BorderRadius.circular(espaceXs / 2),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Fermer',
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ),
          const TitreTextWidget(texte: 'Créez votre compte', fontSize: 20),
          const Gap(espaceSm),
          const CorpsTextWidget(
            texte: 'Un pseudo et un mot de passe pour voter et publier.',
          ),
          const Gap(espaceLg),
          ConnexionWidget(
            onSuccess: () {
              if (context.mounted) Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  }
}

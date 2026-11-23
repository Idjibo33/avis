import 'package:avis/Helpers/validation.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/button_principale_widget.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:avis/widgets/texte_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

/// Unique formulaire d'élévation : pseudo + mot de passe.
///
/// Les contrôleurs vivent aussi longtemps que la feuille : une soumission
/// refusée conserve les saisies et permet un nouvel essai.
class ConnexionWidget extends StatefulWidget {
  const ConnexionWidget({super.key, this.onSuccess});

  final VoidCallback? onSuccess;

  @override
  State<ConnexionWidget> createState() => _ConnexionWidgetState();
}

class _ConnexionWidgetState extends State<ConnexionWidget> {
  final TextEditingController pseudoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? _erreur;
  String? _erreurPseudo;
  String? _erreurMotDePasse;

  @override
  void dispose() {
    pseudoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _soumettre(AuthServicesProviders auth) async {
    final String pseudo = pseudoController.text.trim();
    final String motDePasse = passwordController.text;
    final String? erreurPseudo = erreurPseudoElevation(pseudo);
    final String? erreurMotDePasse = erreurMotDePasseElevation(motDePasse);
    if (erreurPseudo != null || erreurMotDePasse != null) {
      setState(() {
        _erreur = null;
        _erreurPseudo = erreurPseudo;
        _erreurMotDePasse = erreurMotDePasse;
      });
      return;
    }

    final bool reussi = await auth.elevate(
      pseudo: pseudo,
      password: motDePasse,
    );
    if (!mounted) return;
    if (reussi) {
      setState(() {
        _erreur = null;
        _erreurPseudo = null;
        _erreurMotDePasse = null;
      });
      widget.onSuccess?.call();
      return;
    }

    final String? erreurSession = auth.current.error?.toString();
    setState(() {
      _erreurPseudo = null;
      _erreurMotDePasse = null;
      _erreur = auth.messageErreur.isNotEmpty
          ? auth.messageErreur
          : (erreurSession ?? 'Impossible de créer le compte.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthServicesProviders>(
      builder: (context, auth, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TexteFieldWidget(
            controller: pseudoController,
            label: 'Pseudo',
            hint: 'votre_pseudo',
            erreur: _erreurPseudo,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            onChanged: (_) {
              if (_erreurPseudo != null) {
                setState(() => _erreurPseudo = null);
              }
            },
          ),
          TexteFieldWidget(
            controller: passwordController,
            label: 'Mot de passe',
            hint: 'Au moins 8 caractères',
            obscureText: true,
            erreur: _erreurMotDePasse,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _soumettre(auth),
            onChanged: (_) {
              if (_erreurMotDePasse != null) {
                setState(() => _erreurMotDePasse = null);
              }
            },
          ),
          if (_erreur != null) ...[
            const Gap(espaceSm),
            CorpsTextWidget(texte: _erreur!, couleur: noir),
          ],
          const Gap(espaceLg),
          ButtonPrincipaleWidget(
            texte: 'Créer mon compte',
            action: () => _soumettre(auth),
            chargement: auth.chargement,
          ),
        ],
      ),
    );
  }
}

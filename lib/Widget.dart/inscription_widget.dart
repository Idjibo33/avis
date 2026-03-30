import 'package:avis/Helpers/navigators.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Widget.dart/bouton_secondaire_widget.dart';
import 'package:avis/Widget.dart/button_principale_widget.dart';
import 'package:avis/Widget.dart/texte_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class InscriptionWidget extends StatelessWidget {
  const InscriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final nomController = TextEditingController();
    final prenomController = TextEditingController();
    final emailController = TextEditingController();
    final pwController = TextEditingController();
    final confPwController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: [
          TexteFieldWidget(controller: nomController, label: "Nom", hint: "ex"),
          TexteFieldWidget(
            controller: prenomController,
            label: "Prenom",
            hint: "ex",
          ),
          TexteFieldWidget(
            controller: emailController,
            label: "Email",
            hint: "ex",
          ),
          TexteFieldWidget(
            controller: pwController,
            label: "Mot de passe",
            hint: "ex",
          ),
          TexteFieldWidget(
            controller: confPwController,
            label: "Confirmer mot de passe",
            hint: "ex",
          ),
          const Gap(18),
          Consumer<AuthServicesProviders>(
            builder: (context, auth, child) => Column(
              children: [
                ButtonPrincipaleWidget(
                  texte: "Créer mon compte",
                  action: () async {
                    final inscription = await auth.createUser(
                      nom: nomController.text,
                      prenom: prenomController.text,
                      email: emailController.text,
                      password: pwController.text,
                      confPassword: confPwController.text,
                    );
                    if (inscription) {
                      if (context.mounted) naviguerAuthGate(context);
                    }
                  },
                  chargement: auth.chargement,
                ),

                const Gap(8),
                BoutonSecondaireWidget(
                  texte: "Continuer en tant qu'invité",
                  action: () => auth.signInAnonymeUser(),
                  chargement: auth.chargement,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:avis/Helpers/navigators.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/widgets/button_principale_widget.dart';
import 'package:avis/widgets/texte_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class InscriptionWidget extends StatefulWidget {
  const InscriptionWidget({super.key});

  @override
  State<InscriptionWidget> createState() => _InscriptionWidgetState();
}

class _InscriptionWidgetState extends State<InscriptionWidget> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController confPwController = TextEditingController();

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    pwController.dispose();
    confPwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            obscureText: true,
          ),
          TexteFieldWidget(
            controller: confPwController,
            label: "Confirmer mot de passe",
            hint: "ex",
            obscureText: true,
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

                // const Gap(8),
                // BoutonSecondaireWidget(
                //   texte: "Continuer en tant qu'invité",
                //   action: () => auth.signInAnonymeUser(),
                //   chargement: auth.chargement,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

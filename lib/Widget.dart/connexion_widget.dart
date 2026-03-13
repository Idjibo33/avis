import 'package:avis/Helpers/navigators.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Widget.dart/bouton_secondaire_widget.dart';
import 'package:avis/Widget.dart/button_principale_widget.dart';
import 'package:avis/Widget.dart/corps_text_widget.dart';
import 'package:avis/Widget.dart/texte_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ConnexionWidget extends StatelessWidget {
  const ConnexionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final pwController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
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
          const Gap(30),
          Consumer<AuthServicesProviders>(
            builder: (context, auth, child) => ButtonPrincipaleWidget(
              texte: "Se connecter",
              action: () async {
                await auth.signInUser(
                  email: emailController.text,
                  password: pwController.text,
                );
                if (context.mounted) naviguerAuthGate(context);
              },
              chargement: auth.chargement,
            ),
          ),
          const Gap(20),
          const CorpsTextWidget(texte: "Où connectez-vous avec"),
          const Gap(20),
          BoutonSecondaireWidget(
            action: () {},
            icone: FaIcon(FontAwesomeIcons.google),
            texte: 'Google',
            chargement: false,
          ),
        ],
      ),
    );
  }
}

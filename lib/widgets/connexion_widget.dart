import 'package:avis/Helpers/navigators.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/widgets/button_principale_widget.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:avis/widgets/texte_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ConnexionWidget extends StatefulWidget {
  const ConnexionWidget({super.key});

  @override
  State<ConnexionWidget> createState() => _ConnexionWidgetState();
}

class _ConnexionWidgetState extends State<ConnexionWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
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
              obscureText: true,
            ),
            const Gap(30),
            Consumer<AuthServicesProviders>(
              builder: (context, auth, child) => ButtonPrincipaleWidget(
                texte: "Se connecter",
                action: () async {
                  final connexion = await auth.signInUser(
                    email: emailController.text,
                    password: pwController.text,
                  );
                  if (connexion) {
                    if (context.mounted) naviguerAuthGate(context);
                  }
                },
                chargement: auth.chargement,
              ),
            ),
            const Gap(20),
            const CorpsTextWidget(texte: "Où connectez-vous avec"),
            const Gap(20),
            //  BoutonSecondaireWidget(
            //       action: () {},
            //       icone: FaIcon(FontAwesomeIcons.google),
            //       texte: 'Google',
            //       chargement: false,
            //     ),
          ],
        ),
      ),
    );
  }
}

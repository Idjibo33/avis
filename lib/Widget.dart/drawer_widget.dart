import 'package:avis/Helpers/navigators.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Widget.dart/list_tile_widget.dart';
import 'package:avis/Widget.dart/logo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Logo(size: 40),
                const Gap(30),
                const ListTileWidget(
                  leading: FaIcon(FontAwesomeIcons.user),
                  titre: "Profil",
                ),
                const ListTileWidget(
                  leading: FaIcon(FontAwesomeIcons.plus),
                  titre: "Faire un post",
                ),
                const ListTileWidget(
                  leading: FaIcon(FontAwesomeIcons.bell),
                  titre: "Activités",
                ),
              ],
            ),
            Consumer<AuthServicesProviders>(
              builder: (context, auth, child) => ListTileWidget(
                action: () async {
                  await auth.signOutuser();
                  if (context.mounted) naviguerAuthGate(context);
                },
                leading: FaIcon(FontAwesomeIcons.arrowRightFromBracket),
                titre: "Déconnecter",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

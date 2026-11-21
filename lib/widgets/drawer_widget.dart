import 'package:avis/Helpers/navigators.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/list_tile_widget.dart';
import 'package:avis/widgets/logo.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: espaceLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Logo(size: 40),
                const Gap(30),
                ListTileWidget(
                  action: () => naviguerProfilScreen(context),
                  leading: const FaIcon(FontAwesomeIcons.user, size: 20),
                  titre: "Profil",
                ),
                const Gap(espaceSm),
                ListTileWidget(
                  action: () => demanderElevation(
                    context,
                    action: () async => naviguerNewPostScreen(context),
                  ),
                  leading: const FaIcon(FontAwesomeIcons.plus, size: 20),
                  titre: "Faire un post",
                ),
              ],
            ),
            Consumer<AuthServicesProviders>(
              builder: (context, auth, child) => ListTileWidget(
                action: () => auth.signOut(),
                leading: const FaIcon(
                  FontAwesomeIcons.arrowRightFromBracket,
                  size: 20,
                ),
                titre: "Déconnecter",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

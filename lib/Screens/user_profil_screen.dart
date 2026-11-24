import 'package:avis/Helpers/responsiveness.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/profile_table_provider.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:avis/widgets/profile_header_widget.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:avis/widgets/user_post_list_widget.dart';
import 'package:avis/widgets/user_statistics_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

/// Le messager est capturé avant l'appel : le [Consumer] se reconstruit dès
/// que la session change, ce qui invalide le contexte du bouton pendant l'attente.
Future<void> _deconnecter(
  BuildContext context,
  AuthServicesProviders auth,
) async {
  final ScaffoldMessengerState messager = ScaffoldMessenger.of(context);
  final bool reussi = await auth.signOut();
  messager.showSnackBar(
    SnackBar(content: Text(reussi ? 'Déconnecté.' : 'Déconnexion impossible.')),
  );
}

class UserProfilScreen extends StatelessWidget {
  const UserProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userId = context
        .read<AuthServicesProviders>()
        .current
        .authUserId;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: espaceMd),
          child: Responsiveness(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  // Une seule lecture du profil : dans l'en-tête. Le titre
                  // reste stable et n'entre pas en compétition avec le nom.
                  title: const TitreTextWidget(
                    texte: 'Mon profil',
                    fontSize: 16,
                  ),
                  // La déconnexion est une action de session, pas un contenu
                  // de liste : elle reste accessible sans parcourir les duels.
                  actions: [
                    Consumer<AuthServicesProviders>(
                      builder: (context, auth, child) => IconButton(
                        tooltip: 'Déconnecter',
                        icon: const FaIcon(
                          FontAwesomeIcons.arrowRightFromBracket,
                          size: 20,
                        ),
                        onPressed: () => _deconnecter(context, auth),
                      ),
                    ),
                  ],
                  centerTitle: true,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Consumer<ProfileTableProvider>(
                        builder: (context, profile, child) => FutureBuilder(
                          future: userId == null
                              ? Future.value(null)
                              : profile.readRow(id: userId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return ProfileHeaderWidget(
                                nom: snapshot.data!.nom,
                                prenom: snapshot.data!.prenom,
                              );
                            }
                            return const ProfileHeaderWidget(
                              nom: '',
                              prenom: '',
                            );
                          },
                        ),
                      ),
                      const Gap(espaceLg),
                      const UserStatisticsWidget(),
                      const Gap(espaceLg),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      espaceSm,
                      0,
                      espaceSm,
                      espaceMd,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitreTextWidget(texte: 'Mes duels', fontSize: 16),
                        Gap(espaceXs),
                        CorpsTextWidget(
                          texte: 'Touchez un duel pour voir son résultat.',
                        ),
                      ],
                    ),
                  ),
                ),
                const UserPostListWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

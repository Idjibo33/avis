import 'package:avis/Helpers/responsiveness.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/profile_table_provider.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/profile_header_widget.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:avis/widgets/user_post_list_widget.dart';
import 'package:avis/widgets/user_statistics_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

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
                  title: Consumer<ProfileTableProvider>(
                    builder: (context, profile, child) => FutureBuilder(
                      future: userId == null
                          ? Future.value(null)
                          : profile.readRow(id: userId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return TitreTextWidget(
                            texte: snapshot.data!.nom,
                            couleur: texteSecondaire,
                            fontSize: 16,
                          );
                        }
                        return const TitreTextWidget(
                          texte: "@Utilisateur",
                          couleur: texteSecondaire,
                          fontSize: 16,
                        );
                      },
                    ),
                  ),
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
                const UserPostListWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

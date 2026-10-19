import 'package:avis/Helpers/responsiveness.dart';
import 'package:avis/Providers/profile_table_provider.dart';
import 'package:avis/widgets/profile_header_widget.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:avis/widgets/user_post_list_widget.dart';
import 'package:avis/widgets/user_statistics_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfilScreen extends StatelessWidget {
  const UserProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Responsiveness(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  title: Consumer<ProfileTableProvider>(
                    builder: (context, profile, child) => FutureBuilder(
                      future: user == null
                          ? Future.value(null)
                          : profile.readRow(id: user.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return TitreTextWidget(
                            texte: snapshot.data!.nom,
                            couleur: Colors.grey,
                          );
                        } else {
                          return const TitreTextWidget(
                            texte: " @ Utilisateur",
                            couleur: Colors.grey,
                          );
                        }
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
                          future: user == null
                              ? Future.value(null)
                              : profile.readRow(id: user.id),
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
                      const Gap(12),
                      const UserStatisticsWidget(),
                      const Gap(12),
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

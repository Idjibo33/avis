import 'package:avis/Providers/profile_table_provider.dart';
import 'package:avis/Widget.dart/corps_text_widget.dart';
import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:avis/Widget.dart/user_avatar_widget.dart';
import 'package:avis/Widget.dart/user_post_list_widget.dart';
import 'package:avis/Widget.dart/user_statistics_widget.dart';
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
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                title: Consumer<ProfileTableProvider>(
                  builder: (context, profile, child) => FutureBuilder(
                    future: profile.readRow(id: user!.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
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
                        future: profile.readRow(id: user!.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Row(
                              children: [
                                UserAvatarWidget(
                                  radius: 40,
                                  nom: snapshot.data!.nom,
                                ),
                                Gap(8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TitreTextWidget(
                                      texte:
                                          "${snapshot.data!.nom} ${snapshot.data!.prenom}",
                                    ),

                                    CorpsTextWidget(texte: "bio"),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return const Row(
                              children: [
                                UserAvatarWidget(radius: 40, nom: 'U'),
                                Gap(8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TitreTextWidget(texte: "Utilisateur"),

                                    CorpsTextWidget(texte: "bio"),
                                  ],
                                ),
                              ],
                            );
                          }
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
    );
  }
}

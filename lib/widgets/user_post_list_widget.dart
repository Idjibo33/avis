import 'package:avis/Models/post.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Services/auth_repository.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/State/profile_posts_view_state.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:avis/widgets/empty_list_card_widget.dart';
import 'package:avis/widgets/mini_card_widget.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Grille des duels de l'utilisateur (S26/S29 de `docs/state-machines.md`).
///
/// L'identifiant peut être nul (invité) : on ne force jamais `userId!`, et un
/// échec de flux est un état terminal avec réessai, pas un spinner sans fin.
class UserPostListWidget extends StatefulWidget {
  const UserPostListWidget({super.key});

  @override
  State<UserPostListWidget> createState() => _UserPostListWidgetState();
}

class _UserPostListWidgetState extends State<UserPostListWidget> {
  int _tentative = 0;

  @override
  Widget build(BuildContext context) {
    final AuthSessionState session = context.read<AuthServicesProviders>().current;
    final String? userId = session.authUserId;
    // Un invité Serverpod possède un `authUserId` : le statut est l'unique
    // source de vérité, pas la présence d'un identifiant.
    final bool invite = session.status == AuthSessionStatus.guest;

    return Consumer<PostTableProider>(
      builder: (context, posts, child) => StreamBuilder<PostWithCount>(
        // Une nouvelle génération force l'abonnement au flux : le service
        // relance la requête quand il n'a pas encore de données en cache.
        key: ValueKey(_tentative),
        stream: invite || userId == null
            ? null
            : posts.readUserPost(userId: userId),
        builder: (context, snapshot) {
          final ProfilePostsViewState vue = ProfilePostsViewState.from(
            snapshot,
            invite: invite,
          );
          return switch (vue.statut) {
            ProfilePostsStatus.chargement => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
            ProfilePostsStatus.pret => SliverGrid.builder(
              itemCount: vue.posts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: espaceSm,
                mainAxisSpacing: espaceXs,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) =>
                  MiniCardWidget(post: vue.posts[index]),
            ),
            ProfilePostsStatus.vide => const SliverToBoxAdapter(
              child: EmptyListCardWidget(),
            ),
            ProfilePostsStatus.invite => const SliverToBoxAdapter(
              child: EmptyListCardWidget(
                texte: 'Connectez-vous pour voir vos duels',
                afficherCta: false,
              ),
            ),
            ProfilePostsStatus.echec => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: espaceLg),
                child: Column(
                  spacing: espaceSm,
                  children: [
                    const CorpsTextWidget(
                      texte: 'Impossible de charger vos duels',
                    ),
                    TextButton(
                      onPressed: () => setState(() => _tentative++),
                      child: const TitreTextWidget(
                        texte: 'Réessayer',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          };
        },
      ),
    );
  }
}

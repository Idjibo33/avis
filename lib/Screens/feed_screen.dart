import 'dart:async';

import 'package:avis/Helpers/navigators.dart';
import 'package:avis/Helpers/responsiveness.dart';
import 'package:avis/Models/interaction.dart';
import 'package:avis/Models/post.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/State/feed_view_state.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/card_widget.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:avis/widgets/drawer_widget.dart';
import 'package:avis/widgets/empty_list_card_widget.dart';
import 'package:avis/widgets/logo.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<int> interactedDuals = [];
  final CardSwiperController _swipeController = CardSwiperController();
  int tentative = 0;

  @override
  void dispose() {
    unawaited(_swipeController.dispose());
    super.dispose();
  }

  /// Une seule porte d'entrée pour le vote, qu'il vienne du swipe ou du tap.
  ///
  /// Le duel n'est retiré du feed qu'après confirmation de l'écriture : un
  /// échec d'élévation annule le vote et laisse la carte en place.
  Future<bool> _enregistrerVote(
    Post post,
    String choix,
    InteractionsServicesProvider interaction,
  ) async {
    final int id = post.id ?? 0;
    if (interactedDuals.contains(id)) {
      return false;
    }

    final bool reussi = await demanderElevation(
      context,
      action: () async {
        await interaction.addInteraction(
          interaction: Interaction(choix: choix, postId: post.id),
        );
      },
    );
    if (!reussi || !mounted || interactedDuals.contains(id)) {
      return reussi;
    }
    setState(() {
      interactedDuals.add(id);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: DrawerWidget()),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Logo(size: 28),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Menu',
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          const Gap(espaceSm),
        ],
      ),
      body: Responsiveness(
        child: Consumer<PostTableProider>(
          builder: (context, posts, child) => StreamBuilder<List<Post>>(
            key: ValueKey(tentative),
            stream: posts.streamPosts,
            builder: (context, snapshot) {
              final FeedViewState vue = FeedViewState.from(
                snapshot,
                interactedDuals.toSet(),
              );
              return switch (vue.status) {
                FeedStatus.failed => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(espaceLg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: espaceMd,
                      children: [
                        const CorpsTextWidget(
                          texte: "Impossible de charger le feed",
                        ),
                        TextButton(
                          onPressed: () => setState(() {
                            tentative++;
                          }),
                          child: const TitreTextWidget(
                            texte: "Réessayer",
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FeedStatus.empty => const EmptyListCardWidget(),
                FeedStatus.ready => Consumer<InteractionsServicesProvider>(
                  builder: (context, interaction, child) => CardSwiper(
                    controller: _swipeController,
                    scale: 0.95,
                    duration: const Duration(milliseconds: 180),
                    isLoop: false,
                    allowedSwipeDirection: AllowedSwipeDirection.symmetric(
                      horizontal: true,
                      vertical: false,
                    ),
                    cardBuilder:
                        (
                          context,
                          cardIndex,
                          horizontalOffsetPercentage,
                          verticalOffsetPercentage,
                        ) {
                          final Post post = vue.postsVisibles[cardIndex];
                          return CardWidget(
                            post: post,
                            onVoteA: () => _swipeController.swipe(
                              CardSwiperDirection.left,
                            ),
                            onVoteB: () => _swipeController.swipe(
                              CardSwiperDirection.right,
                            ),
                          );
                        },
                    cardsCount: vue.postsVisibles.length,
                    numberOfCardsDisplayed: vue.postsVisibles.length > 2
                        ? 2
                        : vue.postsVisibles.length,
                    onSwipe: (previousIndex, currentIndex, direction) async {
                      if (previousIndex >= vue.postsVisibles.length) {
                        return false;
                      }
                      final Post swipedPost = vue.postsVisibles[previousIndex];
                      return switch (direction) {
                        CardSwiperDirection.right =>
                          await _enregistrerVoteEtContinuer(
                            swipedPost,
                            "B",
                            interaction,
                          ),
                        CardSwiperDirection.left =>
                          await _enregistrerVoteEtContinuer(
                            swipedPost,
                            "A",
                            interaction,
                          ),
                        _ => false,
                      };
                    },
                  ),
                ),
                FeedStatus.loading => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              };
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _enregistrerVoteEtContinuer(
    Post post,
    String choix,
    InteractionsServicesProvider interaction,
  ) => _enregistrerVote(post, choix, interaction);
}

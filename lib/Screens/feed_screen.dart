import 'package:avis/Helpers/responsiveness.dart';
import 'package:avis/Models/interaction.dart';
import 'package:avis/Models/post.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/State/feed_view_state.dart';
import 'package:avis/widgets/card_widget.dart';
import 'package:avis/widgets/drawer_widget.dart';
import 'package:avis/widgets/empty_list_card_widget.dart';
import 'package:avis/widgets/logo.dart';
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
  int tentative = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: DrawerWidget()),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Logo(size: 28),
        actions: [
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Icon(Icons.menu, size: 30),
            ),
          ),

          const Gap(12),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 12,
                    children: [
                      const Text("Impossible de charger le feed"),
                      TextButton(
                        onPressed: () => setState(() {
                          tentative++;
                        }),
                        child: const Text("Réessayer"),
                      ),
                    ],
                  ),
                ),
                FeedStatus.empty => const EmptyListCardWidget(),
                FeedStatus.ready => Consumer<InteractionsServicesProvider>(
                  builder: (context, interaction, child) => CardSwiper(
                    scale: 0.9,
                    duration: const Duration(milliseconds: 100),
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
                          return CardWidget(post: vue.postsVisibles[cardIndex]);
                        },
                    cardsCount: vue.postsVisibles.length,
                    numberOfCardsDisplayed: vue.postsVisibles.length > 2
                        ? 2
                        : vue.postsVisibles.length,
                    onSwipe: (previousIndex, currentIndex, direction) async {
                      final swipedPost = vue.postsVisibles[previousIndex];
                      if (direction == CardSwiperDirection.right) {
                        interaction.addInteraction(
                          interaction: Interaction(
                            choix: "B",
                            postId: swipedPost.id,
                          ),
                        );
                        setState(() {
                          interactedDuals.add(swipedPost.id ?? 0);
                        });
                        return true;
                      }
                      if (direction == CardSwiperDirection.left) {
                        interaction.addInteraction(
                          interaction: Interaction(
                            choix: "A",
                            postId: swipedPost.id,
                          ),
                        );
                        setState(() {
                          interactedDuals.add(swipedPost.id ?? 0);
                        });
                        return true;
                      } else {
                        return false;
                      }
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
}

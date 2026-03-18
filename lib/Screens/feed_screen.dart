import 'package:avis/Helpers/navigators.dart';
import 'package:avis/Models/interaction.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Widget.dart/button_principale_widget.dart';
import 'package:avis/Widget.dart/card_widget.dart';
import 'package:avis/Widget.dart/drawer_widget.dart';
import 'package:avis/Widget.dart/empty_list_card_widget.dart';
import 'package:avis/Widget.dart/logo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: DrawerWidget()),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Logo(size: 28),
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
      body: Consumer<PostTableProider>(
        builder: (context, posts, child) => StreamBuilder(
          stream: posts.streamPosts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty || snapshot.data == null) {
                return const EmptyListCardWidget();
              } else {
                return Consumer<InteractionsServicesProvider>(
                  builder: (context, interaction, child) => CardSwiper(
                    scale: 0.9,
                    duration: Duration(milliseconds: 100),
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
                          return CardWidget(post: snapshot.data![cardIndex]);
                        },
                    cardsCount: snapshot.data!.length,
                    numberOfCardsDisplayed: snapshot.data!.length,
                    onSwipe: (previousIndex, currentIndex, direction) async {
                      final swipedPost = snapshot.data![previousIndex];
                      if (direction == CardSwiperDirection.right) {
                        interaction.addInteraction(
                          interaction: Interaction(
                            choix: "B",
                            postId: swipedPost.id,
                          ),
                        );
                        return true;
                      }
                      if (direction == CardSwiperDirection.left) {
                        interaction.addInteraction(
                          interaction: Interaction(
                            choix: "A",
                            postId: swipedPost.id,
                          ),
                        );
                        return true;
                      } else {
                        return false;
                      }
                    },
                  ),
                );
              }
            }
            return const Center(child: CircularProgressIndicator.adaptive());
          },
        ),
      ),
    );
  }
}

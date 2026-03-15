import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Widget.dart/card_widget.dart';
import 'package:avis/Widget.dart/drawer_widget.dart';
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty || snapshot.data == null) {
                return const Center(child: Text("Aucun post à afficher"));
              }
              return CardSwiper(
                onSwipeDirectionChange:
                    (horizontalDirection, verticalDirection) {
                      if (horizontalDirection.angle == 90) {
                        debugPrint(("Swipped right"));
                      }
                      if (horizontalDirection.angle == 270) {
                        debugPrint("Swipped left");
                      }
                    },
                scale: 0.9,
                duration: Duration(milliseconds: 100),
                allowedSwipeDirection: AllowedSwipeDirection.symmetric(
                  horizontal: true,
                  vertical: false,
                ),
                cardBuilder:
                    (
                      context,
                      index,
                      horizontalOffsetPercentage,
                      verticalOffsetPercentage,
                    ) => CardWidget(post: snapshot.data![index]),
                cardsCount: snapshot.data!.length,
                numberOfCardsDisplayed: snapshot.data!.length,
              );
            }
            return Center(child: Text(snapshot.error.toString()));
          },
        ),
      ),
    );
  }
}

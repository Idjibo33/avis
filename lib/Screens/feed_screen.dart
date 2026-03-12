import 'package:avis/widget.dart/card_widget.dart';
import 'package:avis/widget.dart/drawer_widget.dart';
import 'package:avis/widget.dart/logo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

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
      body: CardSwiper(
        onSwipeDirectionChange: (horizontalDirection, verticalDirection) {
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
            ) => CardWidget(),
        cardsCount: 10,
      ),
    );
  }
}

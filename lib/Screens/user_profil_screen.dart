import 'package:avis/Widget.dart/corps_text_widget.dart';
import 'package:avis/Widget.dart/mini_card_widget.dart';
import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:avis/Widget.dart/user_avatar_widget.dart';
import 'package:avis/Widget.dart/user_statistics_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserProfilScreen extends StatelessWidget {
  const UserProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                title: TitreTextWidget(
                  texte: " @nom user",
                  couleur: Colors.grey,
                ),
                centerTitle: true,
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const UserAvatarWidget(radius: 40),
                        const Gap(8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TitreTextWidget(texte: "Nom user"),
                            const CorpsTextWidget(texte: "bio"),
                          ],
                        ),
                      ],
                    ),
                    const Gap(12),
                    const UserStatisticsWidget(),
                    const Gap(12),
                  ],
                ),
              ),
              SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) => MiniCardWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

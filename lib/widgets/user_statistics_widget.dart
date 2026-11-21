import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:avis/widgets/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserStatisticsWidget extends StatelessWidget {
  const UserStatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userId = context
        .read<AuthServicesProviders>()
        .current
        .authUserId;
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(espaceXl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CorpsTextWidget(texte: 'Publications'),
                  Consumer<PostTableProider>(
                    builder: (context, posts, child) => StreamBuilder(
                      stream: posts.readUserPost(userId: userId!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return TitreTextWidget(
                            fontSize: 25,
                            texte: snapshot.data!.count.toString(),
                          );
                        }
                        return const TitreTextWidget(fontSize: 25, texte: '0');
                      },
                    ),
                  ),
                ],
              ),
              const VerticalDivider(width: espaceXl),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CorpsTextWidget(texte: 'Votes'),
                  Consumer<InteractionsServicesProvider>(
                    builder: (context, interactions, child) => FutureBuilder(
                      future: interactions.readUserInteractions(
                        userId: userId!,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return TitreTextWidget(
                            fontSize: 25,
                            texte: snapshot.data!.count.toString(),
                          );
                        } else {
                          return TitreTextWidget(fontSize: 25, texte: '0');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

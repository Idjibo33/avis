import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Widget.dart/corps_text_widget.dart';
import 'package:avis/Widget.dart/titre_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserStatisticsWidget extends StatelessWidget {
  const UserStatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CorpsTextWidget(texte: 'posts'),
                  Consumer<PostTableProider>(
                    builder: (context, posts, child) => StreamBuilder(
                      stream: posts.readUserPost(userId: user!.id),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CorpsTextWidget(texte: 'Votes'),
                  Consumer<InteractionsServicesProvider>(
                    builder: (context, interactions, child) => FutureBuilder(
                      future: interactions.readUserInteractions(
                        userId: user!.id,
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

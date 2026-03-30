import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Services/Supabase/posts_table_services.dart';
import 'package:avis/Widget.dart/empty_list_card_widget.dart';
import 'package:avis/Widget.dart/mini_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserPostListWidget extends StatelessWidget {
  const UserPostListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Consumer<PostTableProider>(
      builder: (context, value, child) => StreamBuilder(
        stream: PostsTableServices().getUserPosts(user!.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.count == 0) {
              return const SliverToBoxAdapter(child: EmptyListCardWidget());
            }
            return SliverGrid.builder(
              itemCount: snapshot.data!.count,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 8,
                mainAxisSpacing: 4,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) =>
                  MiniCardWidget(post: snapshot.data!.posts![index]),
            );
          } else {
            return SliverToBoxAdapter(
              child: const Center(child: CircularProgressIndicator.adaptive()),
            );
          }
        },
      ),
    );
  }
}

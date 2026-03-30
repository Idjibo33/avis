import 'package:avis/Helpers/post_table_helper.dart';
import 'package:avis/Models/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostsTableServices implements PostTableHelper<Post> {
  final _supabase = Supabase.instance.client;
  final String table = 'posts';
  @override
  Future<dynamic> addData(Post item) {
    final textPost = {
      'type': item.type,
      'question': item.question,
      'option_a_text': item.option_a_text,
      'option_b_text': item.option_b_text,
    };
    final imagePost = {
      'type': item.type,
      'question': item.question,
      'option_a_url': item.option_a_url,
      'option_b_url': item.option_b_url,
    };
    return _supabase
        .from(table)
        .insert(item.type == "text" ? textPost : imagePost);
  }

  @override
  Future<dynamic> deletedata(Post item) {
    return _supabase.from(table).delete().eq('id', item.id!);
  }

  Stream<List<Post>> readData() {
    final resultat = _supabase.from("post_to_show").stream(primaryKey: ['id']);
    return resultat.map((event) => event.map((e) => Post.fromMap(e)).toList());
  }

  @override
  Future<dynamic> updateData(Post item) {
    final textPost = {
      'created_at': item.created_at,
      'type': item.type,
      'question': item.question,
      'option_a_text': item.option_a_text,
      'option_b_text': item.option_b_text,
    };
    final imagePost = {
      'created_at': item.created_at,
      'type': item.type,
      'question': item.question,
      'option_a_url': item.option_a_url,
      'option_b_url': item.option_b_url,
    };
    return _supabase
        .from(table)
        .update(item.type == "text" ? textPost : imagePost);
  }

  @override
  Stream<PostWithCount> getUserPosts(String userId) {
    final resultat = _supabase
        .from(table)
        .stream(primaryKey: ['id'])
        .eq('user', userId);
    return resultat.map(
      (event) => PostWithCount.fromMap({'data': event, 'count': event.length}),
    );
  }
}

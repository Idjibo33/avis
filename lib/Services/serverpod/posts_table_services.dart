import 'dart:async';

import 'package:avis/Models/post.dart';
import 'package:avis/Services/serverpod/client.dart';
import 'package:avis_client/avis_client.dart';

Post _duelVersPost(Duel duel) => Post(
  id: duel.id,
  created_at: duel.createdAt.toIso8601String(),
  user: duel.authorId.toString(),
  question: duel.question,
  type: duel.type,
  option_a_text: duel.optionAText,
  option_a_url: duel.optionAUrl,
  option_b_text: duel.optionBText,
  option_b_url: duel.optionBUrl,
  nom: duel.authorName,
);

/// Adaptateur du feed : les duels du backend sont convertis en [Post] pour ne
/// pas modifier les écrans tant que la migration UI n'est pas faite.
class PostsTableServices {
  PostsTableServices({Client? client}) : _client = client ?? serverpodClient;

  final Client _client;
  final String table = 'posts';

  int _abonnes = 0;
  late final StreamController<List<Post>> _controller =
      StreamController<List<Post>>.broadcast(
        onListen: () {
          _abonnes++;
          if (_abonnes == 1) unawaited(_rafraichir());
        },
        onCancel: () {
          if (_abonnes > 0) _abonnes--;
        },
      );

  Stream<List<Post>> readData() => _controller.stream;

  Stream<PostWithCount> getUserPosts(String userId) => readData().map((posts) {
    final List<Post> propres = posts
        .where((post) => post.user == userId)
        .toList();
    return PostWithCount(posts: propres, count: propres.length);
  });

  Future<dynamic> addData(Post item) async {
    await _client.user.createDuel(
      item.question,
      item.type,
      item.option_a_text,
      item.option_a_url,
      item.option_b_text,
      item.option_b_url,
    );
    await _rafraichir();
  }

  Future<dynamic> deletedata(Post item) async {
    final int? id = item.id;
    if (id == null) {
      throw ArgumentError.value(
        item,
        'post',
        'Un duel sans id ne peut pas être supprimé',
      );
    }
    await _client.user.deleteDuel(id);
    await _rafraichir();
  }

  Future<dynamic> updateData(Post item) async {
    throw UnimplementedError(
      'Le backend Serverpod n\'expose pas encore la modification d\'un duel',
    );
  }

  /// Recharge le feed et alimente le flux broadcast, y compris en cas d'erreur
  /// pour que l'écran puisse afficher son état d'échec.
  Future<void> _rafraichir() async {
    try {
      final List<Duel> duels = await _client.publicFeed.listDuels(limit: 50);
      if (!_controller.isClosed) {
        _controller.add(duels.map(_duelVersPost).toList());
      }
    } catch (error, stackTrace) {
      if (!_controller.isClosed) _controller.addError(error, stackTrace);
    }
  }
}

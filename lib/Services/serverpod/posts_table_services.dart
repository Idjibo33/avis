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
  PostsTableServices({Client? client, Future<List<Duel>> Function()? chargeur})
    : _client = client ?? serverpodClient,
      _chargeur =
          chargeur ?? (() => (client ?? serverpodClient).publicFeed.listDuels(limit: 50));

  final Client _client;
  final Future<List<Duel>> Function() _chargeur;
  final String table = 'posts';

  /// Dernier feed reçu. Un `StreamController.broadcast` ne rejoue pas son
  /// historique et son `onListen` ne s'appelle que pour le **premier** abonné :
  /// publier le cache là-dedans ne suffit pas quand le feed est déjà ouvert.
  List<Post>? _dernierFeed;
  late final StreamController<List<Post>> _controller =
      StreamController<List<Post>>.broadcast(
        onListen: () {
          if (_dernierFeed == null) unawaited(_rafraichir());
        },
      );

  /// Chaque lecteur reçoit son propre flux broadcast, qui commence par le
  /// dernier feed connu. Le profil empilé au-dessus du feed reçoit ainsi une
  /// première image au lieu de rester sur son spinner.
  Stream<List<Post>> readData() {
    late final StreamController<List<Post>> flux;
    flux = StreamController<List<Post>>.broadcast(
      onListen: () {
        final List<Post>? dernier = _dernierFeed;
        if (dernier != null) flux.add(dernier);
      },
    );
    final StreamSubscription<List<Post>> abonnement = _controller.stream.listen(
      flux.add,
      onError: flux.addError,
      onDone: flux.close,
    );
    flux.onCancel = () => unawaited(abonnement.cancel());
    return flux.stream;
  }

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
      final List<Duel> duels = await _chargeur();
      if (!_controller.isClosed) {
        _dernierFeed = duels.map(_duelVersPost).toList();
        _controller.add(_dernierFeed!);
      }
    } catch (error, stackTrace) {
      // Le cache est vidé pour qu'un nouvel abonné (bouton Réessayer du feed,
      // retour sur le profil) relance effectivement la requête.
      _dernierFeed = null;
      if (!_controller.isClosed) _controller.addError(error, stackTrace);
    }
  }
}

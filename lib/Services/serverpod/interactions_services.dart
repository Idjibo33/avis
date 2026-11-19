import 'package:avis/Models/interaction.dart';
import 'package:avis/Services/serverpod/client.dart';
import 'package:avis_client/avis_client.dart';

Interaction _voteVersInteraction(Vote vote) => Interaction(
  id: vote.id,
  postId: vote.duelId,
  userId: vote.userId.toString(),
  // Les pourcentages existants comparent les choix en MAJUSCULE.
  choix: vote.choix.toUpperCase(),
);

/// Adaptateur des votes : l'identité du votant est dérivée de la session côté
/// serveur, les lectures passent par l'endpoint public.
class InteractionsServices {
  InteractionsServices({Client? client}) : _client = client ?? serverpodClient;

  final Client _client;
  final String table = 'interactions';

  Future<dynamic> addData(Interaction item) async {
    final int? duelId = item.postId;
    final String? choix = item.choix;
    if (duelId == null || choix == null) {
      throw ArgumentError.value(
        item,
        'interaction',
        'Un vote nécessite un duel et un choix',
      );
    }
    await _client.user.vote(duelId, choix.toLowerCase());
  }

  Future<dynamic> deletedata(Interaction item) async {
    throw UnimplementedError(
      'Le backend Serverpod n\'expose pas encore la suppression d\'un vote',
    );
  }

  Future<dynamic> updateData(Interaction item) async {
    throw UnimplementedError(
      'Le backend Serverpod n\'expose pas encore la modification d\'un vote',
    );
  }

  Future<List<Interaction>> readDataOnce(int postId) async {
    final List<Vote> votes = await _client.publicFeed.listVotes(postId);
    return votes.map(_voteVersInteraction).toList();
  }

  /// Le backend ne filtre pas les votes par utilisateur : on parcourt les
  /// duels publics du feed puis on filtre côté client.
  Future<InteractionWithCount> readUserData(String userId) async {
    final List<Duel> duels = await _client.publicFeed.listDuels(limit: 50);
    final List<List<Interaction>> parDuel = await Future.wait(
      duels.map((duel) => readDataOnce(duel.id ?? 0)),
    );
    final List<Interaction> propres = parDuel
        .expand((interactions) => interactions)
        .where((interaction) => interaction.userId == userId)
        .toList();
    return InteractionWithCount(interactions: propres, count: propres.length);
  }
}

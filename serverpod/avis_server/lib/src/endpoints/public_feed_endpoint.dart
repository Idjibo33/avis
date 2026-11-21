import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Lecture publique du feed : aucun `requireLogin`, aucun jeton nécessaire.
class PublicFeedEndpoint extends Endpoint {
  /// Liste des duels à afficher dans le feed, du plus récent au plus ancien.
  Future<List<Duel>> listDuels(Session session, {int limit = 50}) async {
    return Duel.db.find(
      session,
      orderBy: (t) => t.createdAt.desc(),
      limit: limit.clamp(1, 200).toInt(),
    );
  }

  /// Votes d'un duel, pour afficher les totals de l'écran de résultats.
  Future<List<Vote>> listVotes(Session session, int duelId) async {
    return Vote.db.find(
      session,
      where: (t) => t.duelId.equals(duelId),
      orderBy: (t) => t.createdAt.desc(),
    );
  }

  /// Nombre de votes d'un duel.
  Future<int> countVotes(Session session, int duelId) async {
    return Vote.db.count(
      session,
      where: (t) => t.duelId.equals(duelId),
    );
  }

  /// Pseudo public d'un auteur, sans exposer les données du compte.
  Future<String?> authorName(Session session, UuidValue authUserId) async {
    final account = await UsernameAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );
    return account?.username;
  }
}

import 'package:avis/Models/post.dart';
import 'package:flutter/material.dart';

enum FeedStatus { loading, ready, empty, allVoted, failed }

/// État du feed : flux Serverpod, duels votés et duels ignorés localement.
///
/// `empty` (aucun duel publié) et `allVoted` (le flux contenait des duels mais
/// tous ont été votés localement) restent distincts : le second état mérite un
/// message explicite, sinon l'utilisateur croit le feed cassé.
///
/// Les identifiants ignorés ne sont pas des votes : ils quittent le tour
/// courant puis reviennent dès que la file est vide. Tant qu'il en reste,
/// l'état `allVoted` serait faux, donc il n'est jamais exposé.
final class FeedViewState {
  const FeedViewState._({
    required this.status,
    this.postsVisibles = const <Post>[],
    this.erreur,
  });

  final FeedStatus status;
  final List<Post> postsVisibles;
  final String? erreur;

  factory FeedViewState.from(
    AsyncSnapshot<List<Post>> snapshot,
    Set<int> votedIds, {
    Set<int> skippedIds = const <int>{},
  }) {
    if (snapshot.hasError) {
      return FeedViewState._(
        status: FeedStatus.failed,
        erreur: snapshot.error.toString(),
      );
    }
    if (!snapshot.hasData) {
      return const FeedViewState._(status: FeedStatus.loading);
    }
    final List<Post> candidats = snapshot.data!;
    List<Post> visibles = candidats
        .where(
          (post) =>
              !votedIds.contains(post.id) && !skippedIds.contains(post.id),
        )
        .toList();
    // Le tour est terminé : les duels ignorés reviennent d'eux-mêmes. Aucun
    // état transitoire n'est exposé, donc aucun message ni compteur.
    if (visibles.isEmpty && skippedIds.isNotEmpty) {
      visibles = candidats
          .where(
            (post) =>
                skippedIds.contains(post.id) && !votedIds.contains(post.id),
          )
          .toList();
    }
    if (visibles.isEmpty) {
      final bool tousVotes = snapshot.data!.isNotEmpty;
      return FeedViewState._(
        status: tousVotes ? FeedStatus.allVoted : FeedStatus.empty,
      );
    }
    return FeedViewState._(status: FeedStatus.ready, postsVisibles: visibles);
  }
}

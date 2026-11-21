import 'package:avis/Models/post.dart';
import 'package:flutter/material.dart';

enum FeedStatus { loading, ready, empty, failed }

/// État du feed : flux Serverpod + duels déjà votés localement.
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
    Set<int> votedIds,
  ) {
    if (snapshot.hasError) {
      return FeedViewState._(
        status: FeedStatus.failed,
        erreur: snapshot.error.toString(),
      );
    }
    if (!snapshot.hasData) {
      return const FeedViewState._(status: FeedStatus.loading);
    }
    final List<Post> visibles = snapshot.data!
        .where((post) => !votedIds.contains(post.id))
        .toList();
    if (visibles.isEmpty) {
      return const FeedViewState._(status: FeedStatus.empty);
    }
    return FeedViewState._(status: FeedStatus.ready, postsVisibles: visibles);
  }
}

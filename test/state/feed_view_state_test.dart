import 'package:avis/Models/post.dart';
import 'package:avis/State/feed_view_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fakes.dart';

void main() {
  test('snapshot en attente : chargement', () {
    final FeedViewState state = FeedViewState.from(
      const AsyncSnapshot<List<Post>>.waiting(),
      const <int>{},
    );

    expect(state.status, FeedStatus.loading);
    expect(state.postsVisibles, isEmpty);
  });

  test('des duels restants : prêt', () {
    final FeedViewState state = FeedViewState.from(
      AsyncSnapshot.withData(ConnectionState.done, [
        buildPost(id: 1),
        buildPost(id: 2),
      ]),
      const <int>{1},
    );

    expect(state.status, FeedStatus.ready);
    expect(state.postsVisibles.map((post) => post.id), [2]);
  });

  test('aucun duel publié : vide', () {
    final FeedViewState state = FeedViewState.from(
      AsyncSnapshot.withData(ConnectionState.done, const <Post>[]),
      const <int>{},
    );

    expect(state.status, FeedStatus.empty);
  });

  test('tous les duels votés : état explicite distinct du vide', () {
    final FeedViewState state = FeedViewState.from(
      AsyncSnapshot.withData(ConnectionState.done, [buildPost(id: 1)]),
      const <int>{1},
    );

    expect(state.status, FeedStatus.allVoted);
    expect(state.postsVisibles, isEmpty);
  });

  test('un duel ignoré : retiré de la file courante', () {
    final FeedViewState state = FeedViewState.from(
      AsyncSnapshot.withData(ConnectionState.done, [
        buildPost(id: 1),
        buildPost(id: 2),
      ]),
      const <int>{},
      skippedIds: const <int>{1},
    );

    expect(state.status, FeedStatus.ready);
    expect(state.postsVisibles.map((post) => post.id), [2]);
  });

  test('tour terminé : le duel ignoré revient sans état intermédiaire', () {
    final FeedViewState state = FeedViewState.from(
      AsyncSnapshot.withData(ConnectionState.done, [buildPost(id: 1)]),
      const <int>{},
      skippedIds: const <int>{1},
    );

    expect(state.status, FeedStatus.ready);
    expect(state.postsVisibles.map((post) => post.id), [1]);
  });

  test('duel ignoré puis voté : aucun retour fantôme', () {
    final FeedViewState state = FeedViewState.from(
      AsyncSnapshot.withData(ConnectionState.done, [buildPost(id: 1)]),
      const <int>{1},
      skippedIds: const <int>{1},
    );

    expect(state.status, FeedStatus.allVoted);
    expect(state.postsVisibles, isEmpty);
  });

  test('flux vide avec un ignoré : reste vide', () {
    final FeedViewState state = FeedViewState.from(
      AsyncSnapshot.withData(ConnectionState.done, const <Post>[]),
      const <int>{},
      skippedIds: const <int>{1},
    );

    expect(state.status, FeedStatus.empty);
  });

  test('erreur du flux : échec', () {
    final FeedViewState state = FeedViewState.from(
      AsyncSnapshot<List<Post>>.withError(
        ConnectionState.done,
        Exception('boom'),
      ),
      const <int>{},
    );

    expect(state.status, FeedStatus.failed);
  });
}

import 'package:avis/Models/post.dart';
import 'package:avis/State/profile_posts_view_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AsyncSnapshot<PostWithCount> snapshotAvec(Object? data) =>
      AsyncSnapshot<PostWithCount>.withData(
        ConnectionState.done,
        data as PostWithCount,
      );

  test('invité : pas de crash, état invité sans donnée', () {
    final ProfilePostsViewState vue = ProfilePostsViewState.from(
      null,
      invite: true,
    );

    expect(vue.statut, ProfilePostsStatus.invite);
    expect(vue.posts, isEmpty);
  });

  test('en attente : état chargement', () {
    final ProfilePostsViewState vue = ProfilePostsViewState.from(
      const AsyncSnapshot<PostWithCount>.waiting(),
      invite: false,
    );

    expect(vue.statut, ProfilePostsStatus.chargement);
  });

  test('erreur : état echec, jamais un spinner infini', () {
    final AsyncSnapshot<PostWithCount> erreur =
        AsyncSnapshot<PostWithCount>.withError(
          ConnectionState.done,
          Exception('boom'),
          StackTrace.empty,
        );

    final ProfilePostsViewState vue = ProfilePostsViewState.from(
      erreur,
      invite: false,
    );

    expect(vue.statut, ProfilePostsStatus.echec);
    expect(vue.posts, isEmpty);
  });

  test('liste vide : état vide', () {
    final ProfilePostsViewState vue = ProfilePostsViewState.from(
      snapshotAvec(PostWithCount(posts: const [], count: 0)),
      invite: false,
    );

    expect(vue.statut, ProfilePostsStatus.vide);
  });

  test('duels présents : état pret avec les posts', () {
    final Post duel = Post(question: 'Café ou thé ?', type: 'text');
    final ProfilePostsViewState vue = ProfilePostsViewState.from(
      snapshotAvec(PostWithCount(posts: [duel], count: 1)),
      invite: false,
    );

    expect(vue.statut, ProfilePostsStatus.pret);
    expect(vue.posts, hasLength(1));
    expect(vue.posts.single.question, 'Café ou thé ?');
  });
}

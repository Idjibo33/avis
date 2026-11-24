import 'package:avis/Models/post.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fakes.dart';

class PostsEnEchec extends FakePostsTableServices {
  @override
  Future addData(Post item) async {
    throw Exception('refus serveur');
  }
}

void main() {
  // showError utilise la GlobalKey du messenger : sans binding, currentState
  // lève avant même que le test puisse observer la valeur renvoyée.
  TestWidgetsFlutterBinding.ensureInitialized();

  test('addPost : succès explicite', () async {
    final PostTableProider provider = PostTableProider(
      postsTableServices: FakePostsTableServices(),
      storageServices: FakeStorageServices(),
    );

    expect(await provider.addPost(post: buildPost()), isTrue);
  });

  test('readUserPost : chaque lecteur reçoit un flux distinct avec le rejeu',
      () async {
    final PostTableProider provider = PostTableProider(
      postsTableServices: FakePostsTableServices(),
    );

    final Stream<PostWithCount> statistiques =
        provider.readUserPost(userId: '42')!;
    final Stream<PostWithCount> liste =
        provider.readUserPost(userId: '42')!;

    expect(statistiques, isNot(same(liste)));

    final PostWithCount valeurStatistiques = await statistiques.first;
    final PostWithCount valeurListe = await liste.first;

    expect(valeurStatistiques.posts, isEmpty);
    expect(valeurListe.posts, isEmpty);
  });

  test('addPost : échec explicite sans exception', () async {
    final PostTableProider provider = PostTableProider(
      postsTableServices: PostsEnEchec(),
      storageServices: FakeStorageServices(),
    );

    expect(await provider.addPost(post: buildPost()), isFalse);
  });
}

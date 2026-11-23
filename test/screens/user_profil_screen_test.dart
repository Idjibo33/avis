import 'package:avis/Models/post.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Providers/profile_table_provider.dart';
import 'package:avis/Screens/user_profil_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

class AuthRepositoryEnEchec extends FakeAuthRepository {
  @override
  Future<void> signOut() async {
    signOutCalls++;
    throw Exception('boom');
  }
}

class PostsEnEchec extends FakePostsTableServices {
  @override
  Stream<PostWithCount> getUserPosts(String userId) =>
      Stream<PostWithCount>.error(Exception('boom')).asBroadcastStream();
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<FakeAuthRepository> pomperProfil(
    WidgetTester tester, {
    FakeAuthRepository? repository,
    FakePostsTableServices? postsServices,
    bool authentifie = true,
  }) async {
    final FakeAuthRepository depot = repository ?? FakeAuthRepository();
    final AuthServicesProviders auth = AuthServicesProviders(repository: depot);
    if (authentifie) {
      depot.devenirAuthentifie();
    } else {
      depot.devenirInvite();
    }
    final FakePostsTableServices posts = postsServices ?? FakePostsTableServices();
    addTearDown(posts.close);
    addTearDown(depot.close);
    addTearDown(auth.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: auth),
          ChangeNotifierProvider(
            create: (_) => ProfileTableProvider(
              profileTableServices: FakeProfileTableServices(),
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => PostTableProider(postsTableServices: posts),
          ),
          ChangeNotifierProvider(
            create: (_) => InteractionsServicesProvider(
              interactions: FakeInteractionsServices(),
            ),
          ),
        ],
        child: const MaterialApp(home: UserProfilScreen()),
      ),
    );
    await tester.pumpAndSettle();
    return depot;
  }

  testWidgets('Déconnecter : dans le trailing de l app bar, pas en bas de liste', (
    tester,
  ) async {
    await pomperProfil(tester);

    final SliverAppBar appBar = tester.widget<SliverAppBar>(
      find.byType(SliverAppBar),
    );
    expect(appBar.actions, hasLength(1));
    expect(
      find.ancestor(
        of: find.byTooltip('Déconnecter'),
        matching: find.byType(SliverAppBar),
      ),
      findsOneWidget,
    );
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('profil invité : aucun userId forcé, état invité lisible', (
    tester,
  ) async {
    await pomperProfil(tester, authentifie: false);

    expect(find.text('Connectez-vous pour voir vos duels'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('profil : une erreur de liste n affiche pas un spinner infini', (
    tester,
  ) async {
    await pomperProfil(tester, postsServices: PostsEnEchec());

    expect(find.text('Impossible de charger vos duels'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Déconnecter : feedback visible après la déconnexion', (
    tester,
  ) async {
    final FakeAuthRepository depot = await pomperProfil(tester);

    expect(find.byTooltip('Déconnecter'), findsOneWidget);
    await tester.tap(find.byTooltip('Déconnecter'));
    await tester.pumpAndSettle();

    expect(depot.signOutCalls, 1);
    expect(find.text('Déconnecté.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Déconnecter : un échec reste visible', (tester) async {
    final FakeAuthRepository depot = await pomperProfil(
      tester,
      repository: AuthRepositoryEnEchec(),
    );

    await tester.tap(find.byTooltip('Déconnecter'));
    await tester.pumpAndSettle();

    expect(depot.signOutCalls, 1);
    expect(find.text('Déconnexion impossible.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

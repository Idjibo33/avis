import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Screens/authentication_screen.dart';
import 'package:avis/Screens/feed_screen.dart';
import 'package:avis/State/auth_gate_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<FakePostsTableServices> pumpFeed(WidgetTester tester) async {
    final FakePostsTableServices posts = FakePostsTableServices();
    addTearDown(posts.close);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => PostTableProider(
              postsTableServices: posts,
              storageServices: FakeStorageServices(),
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => InteractionsServicesProvider(
              interactions: FakeInteractionsServices(),
            ),
          ),
        ],
        child: const MaterialApp(home: FeedScreen()),
      ),
    );
    await tester.pump();
    return posts;
  }

  testWidgets('affiche un indicateur pendant le chargement', (tester) async {
    await pumpFeed(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('affiche le message vide quand aucun duel', (tester) async {
    final FakePostsTableServices posts = await pumpFeed(tester);

    await posts.emit([]);
    await tester.pump();

    expect(find.text('Aucun duel à afficher'), findsOneWidget);
  });

  testWidgets('erreur de flux : message convivial et bouton réessayer', (
    tester,
  ) async {
    final FakePostsTableServices posts = await pumpFeed(tester);

    await posts.emitError(Exception('boom'));
    await tester.pump();

    expect(find.text('Impossible de charger le feed'), findsOneWidget);
    expect(find.text('Réessayer'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  Future<
    (FakeAuthRepository, FakeInteractionsServices, AuthElevationController)
  >
  pumpFeedAvecAuth(WidgetTester tester, {required bool authentifie}) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final FakePostsTableServices posts = FakePostsTableServices();
    final FakeInteractionsServices interactions = FakeInteractionsServices();
    final FakeAuthRepository repository = FakeAuthRepository();
    final AuthElevationController elevation = AuthElevationController();
    addTearDown(posts.close);
    addTearDown(repository.close);
    addTearDown(elevation.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => PostTableProider(
              postsTableServices: posts,
              storageServices: FakeStorageServices(),
            ),
          ),
          ChangeNotifierProvider(
            create: (_) =>
                InteractionsServicesProvider(interactions: interactions),
          ),
          ChangeNotifierProvider(
            create: (_) => AuthServicesProviders(repository: repository),
          ),
          ChangeNotifierProvider.value(value: elevation),
        ],
        child: const MaterialApp(home: FeedScreen()),
      ),
    );
    // Le provider est paresseux : on le force à s'abonner avant de publier la
    // session, comme le ferait l'adaptateur Serverpod.
    Provider.of<AuthServicesProviders>(
      tester.element(find.byType(FeedScreen)),
      listen: false,
    );
    if (authentifie) {
      repository.devenirAuthentifie();
    } else {
      repository.devenirInvite();
    }
    await posts.emit([buildPost()]);
    await tester.pumpAndSettle();
    return (repository, interactions, elevation);
  }

  testWidgets('authentifié : le vote est écrit avant que le duel disparaisse', (
    tester,
  ) async {
    final (_, FakeInteractionsServices interactions, _) =
        await pumpFeedAvecAuth(tester, authentifie: true);

    await tester.tap(find.byTooltip('Voter pour A'));
    await tester.pumpAndSettle();

    expect(interactions.ajouts, hasLength(1));
    expect(interactions.ajouts.single.choix, 'A');
    expect(find.byTooltip('Voter pour A'), findsNothing);
  });

  testWidgets('invité : un échec d élévation annule le vote et garde le duel', (
    tester,
  ) async {
    final (
      FakeAuthRepository repository,
      FakeInteractionsServices interactions,
      AuthElevationController elevation,
    ) = await pumpFeedAvecAuth(
      tester,
      authentifie: false,
    );
    repository.erreurElevation = Exception('refus serveur');

    await tester.tap(find.byTooltip('Voter pour B'));
    await tester.pumpAndSettle();

    expect(find.byType(AuthenticationScreen), findsOneWidget);
    expect(interactions.ajouts, isEmpty);
    await tester.enterText(find.byType(TextField).at(0), 'joueur_1');
    await tester.enterText(find.byType(TextField).at(1), 'motdepasse1');
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();

    expect(find.textContaining('refus serveur'), findsOneWidget);
    expect(elevation.aUneActionEnAttente, isTrue);
    expect(interactions.ajouts, isEmpty);
    expect(find.byTooltip('Voter pour B'), findsOneWidget);

    await tester.tap(find.byTooltip('Fermer'));
    await tester.pumpAndSettle();
    expect(interactions.ajouts, isEmpty);
  });

  testWidgets(
    'invité : le menu Faire un post ouvre la feuille puis le formulaire',
    (tester) async {
      final (FakeAuthRepository repository, _, _) = await pumpFeedAvecAuth(
        tester,
        authentifie: false,
      );

      await tester.tap(find.byTooltip('Menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Faire un post'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(AuthenticationScreen), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), 'joueur_1');
      await tester.enterText(find.byType(TextField).at(1), 'motdepasse1');
      await tester.tap(find.text('Créer mon compte'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(repository.elevateCalls, 1);
      expect(find.text('Nouveau duel'), findsOneWidget);
    },
  );

  testWidgets('invité : une élévation réussie rejoue le vote une seule fois', (
    tester,
  ) async {
    final (
      FakeAuthRepository repository,
      FakeInteractionsServices interactions,
      _,
    ) = await pumpFeedAvecAuth(
      tester,
      authentifie: false,
    );

    await tester.tap(find.byTooltip('Voter pour B'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'joueur_1');
    await tester.enterText(find.byType(TextField).at(1), 'motdepasse1');
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();

    expect(repository.elevateCalls, 1);
    expect(interactions.ajouts, hasLength(1));
    expect(interactions.ajouts.single.choix, 'B');
    expect(find.byTooltip('Voter pour B'), findsNothing);
  });
}

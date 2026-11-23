import 'dart:async';

import 'package:avis/Models/interaction.dart';
import 'package:avis/Models/post.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Providers/profile_table_provider.dart';
import 'package:avis/Screens/authentication_screen.dart';
import 'package:avis/Screens/feed_screen.dart';
import 'package:avis/Screens/resultat_duel_screen.dart';
import 'package:avis/Screens/user_profil_screen.dart';
import 'package:avis/State/auth_gate_state.dart';
import 'package:avis/State/feed_view_state.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/bottom_nav_bar_widget.dart';
import 'package:avis/widgets/main_navigation_shell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

/// Écriture maintenue en vol : sert à observer le feed pendant le vote, sans
/// modifier le fake partagé ni introduire de service externe.
class InteractionsBloquees extends FakeInteractionsServices {
  final Completer<void> porte = Completer<void>();
  int appels = 0;

  @override
  Future addData(Interaction item) async {
    appels++;
    await porte.future;
    await super.addData(item);
  }
}

/// Écriture refusée par le backend : le feed ne doit pas annoncer de succès.
class InteractionsEnEchec extends FakeInteractionsServices {
  @override
  Future addData(Interaction item) async {
    throw Exception('refus serveur');
  }
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<FakePostsTableServices> pumpFeed(WidgetTester tester) async {
    final FakePostsTableServices posts = FakePostsTableServices();
    final FakeAuthRepository repository = FakeAuthRepository();
    addTearDown(posts.close);
    addTearDown(repository.close);

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
          ChangeNotifierProvider(
            create: (_) => AuthServicesProviders(repository: repository),
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

  testWidgets('chargement : un seul spinner et un libellé discret', (
    tester,
  ) async {
    await pumpFeed(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Chargement du feed…'), findsOneWidget);
  });

  test('le mapper distingue feed vide et tous les duels votés', () {
    final AsyncSnapshot<List<Post>> vide = AsyncSnapshot<List<Post>>.withData(
      ConnectionState.done,
      <Post>[],
    );
    final AsyncSnapshot<List<Post>> unDuel = AsyncSnapshot<List<Post>>.withData(
      ConnectionState.done,
      <Post>[buildPost()],
    );

    expect(FeedViewState.from(vide, const <int>{}).status, FeedStatus.empty);
    expect(
      FeedViewState.from(unDuel, const <int>{1}).status,
      FeedStatus.allVoted,
    );
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
  pumpFeedAvecAuth(
    WidgetTester tester, {
    required bool authentifie,
    FakeInteractionsServices? interactionsServices,
    List<Post>? postsInitiaux,
    bool dansShell = false,
  }) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final FakePostsTableServices posts = FakePostsTableServices();
    final FakeInteractionsServices interactions =
        interactionsServices ?? FakeInteractionsServices();
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
          ChangeNotifierProvider(
            create: (_) => ProfileTableProvider(
              profileTableServices: FakeProfileTableServices(),
            ),
          ),
          ChangeNotifierProvider.value(value: elevation),
        ],
        child: MaterialApp(home: dansShell ? const MainNavigationShell() : const FeedScreen()),
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
    await posts.emit(postsInitiaux ?? [buildPost()]);
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
    'invité : le + ouvre la feuille puis le formulaire',
    (tester) async {
      final (FakeAuthRepository repository, _, _) = await pumpFeedAvecAuth(
        tester,
        authentifie: false,
        dansShell: true,
      );

      await tester.tap(find.byTooltip('Créer un duel'));
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

  testWidgets('échec d écriture : carte conservée, aucun faux succès', (
    tester,
  ) async {
    await pumpFeedAvecAuth(
      tester,
      authentifie: true,
      interactionsServices: InteractionsEnEchec(),
    );

    await tester.tap(find.byTooltip('Voter pour A'));
    await tester.pumpAndSettle();

    expect(find.text('Vote enregistré'), findsNothing);
    expect(find.text('Voir le résultat'), findsNothing);
    expect(find.text('Vote impossible pour le moment.'), findsOneWidget);
    expect(find.byTooltip('Voter pour A'), findsOneWidget);
    expect(find.byTooltip('Voter pour B'), findsOneWidget);
  });

  testWidgets('tous les duels votés : libellé dédié, plus de CTA redondant', (
    tester,
  ) async {
    await pumpFeedAvecAuth(tester, authentifie: true, dansShell: true);

    await tester.tap(find.byTooltip('Voter pour A'));
    await tester.pumpAndSettle();

    expect(find.text('Vous avez voté sur tous les duels'), findsOneWidget);
    expect(find.text('Aucun duel à afficher'), findsNothing);
    expect(find.text('Créer un duel'), findsNothing);
    expect(find.byTooltip('Créer un duel'), findsOneWidget);
  });

  testWidgets('plusieurs duels : le dernier vote mène à l état tous votés', (
    tester,
  ) async {
    await pumpFeedAvecAuth(
      tester,
      authentifie: true,
      postsInitiaux: [
        buildPost(id: 1, question: 'Premier duel'),
        buildPost(id: 2, question: 'Deuxième duel'),
        buildPost(id: 3, question: 'Troisième duel'),
      ],
    );

    for (int i = 0; i < 3; i++) {
      await tester.tap(find.byTooltip('Voter pour A').last);
      await tester.pumpAndSettle();
    }

    expect(find.text('Vous avez voté sur tous les duels'), findsOneWidget);
    expect(find.byTooltip('Voter pour A'), findsNothing);
  });

  testWidgets('vote confirmé : snackbar et accès au résultat', (tester) async {
    await pumpFeedAvecAuth(tester, authentifie: true);

    await tester.tap(find.byTooltip('Voter pour B'));
    await tester.pumpAndSettle();

    expect(find.text('Vote enregistré'), findsOneWidget);
    final SnackBarAction action = tester.widget<SnackBarAction>(
      find.byType(SnackBarAction),
    );
    expect(action.label, 'Voir le résultat');

    await tester.tap(find.byType(SnackBarAction));
    await tester.pumpAndSettle();

    expect(find.byType(ResultatDuelScreen), findsOneWidget);
  });

  testWidgets('vote en vol : cibles désactivées et double tap sans doublon', (
    tester,
  ) async {
    final InteractionsBloquees bloquees = InteractionsBloquees();
    await pumpFeedAvecAuth(
      tester,
      authentifie: true,
      interactionsServices: bloquees,
    );

    await tester.tap(find.byTooltip('Voter pour A'));
    await tester.tap(find.byTooltip('Voter pour B'));
    // CardSwiper appelle onSwipe à la fin de son animation (180 ms) : on avance
    // au-delà pour démarrer l'écriture, que le fake maintient en vol.
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump();

    // Un seul appel d'écriture, malgré deux taps rapides sur deux cibles.
    expect(bloquees.appels, 1);
    expect(bloquees.ajouts, isEmpty);
    expect(find.byTooltip('Voter pour A'), findsOneWidget);
    final FilledButton boutonA = tester.widget<FilledButton>(
      find.descendant(
        of: find.byTooltip('Voter pour A'),
        matching: find.byType(FilledButton),
      ),
    );
    expect(boutonA.onPressed, isNull);

    bloquees.porte.complete();
    await tester.pumpAndSettle();

    expect(bloquees.ajouts, hasLength(1));
  });

  testWidgets('le feed garde une gouttière de 24 dp autour de la carte', (
    tester,
  ) async {
    await pumpFeedAvecAuth(tester, authentifie: true);

    final CardSwiper swiper = tester.widget<CardSwiper>(
      find.byType(CardSwiper),
    );
    expect(
      swiper.padding,
      const EdgeInsets.symmetric(horizontal: espaceXl, vertical: espaceXl),
    );
  });

  testWidgets('barre basse à la place du drawer et du menu', (tester) async {
    await pumpFeedAvecAuth(tester, authentifie: true, dansShell: true);

    expect(find.byType(BottomNavBarWidget), findsOneWidget);
    expect(find.byTooltip('Créer un duel'), findsOneWidget);
    expect(find.byTooltip('Menu'), findsNothing);
    expect(find.byType(Drawer), findsNothing);
  });

  testWidgets('la barre reste sur le feed : absente du formulaire', (tester) async {
    await pumpFeedAvecAuth(tester, authentifie: true, dansShell: true);
    expect(find.byType(BottomNavBarWidget), findsOneWidget);

    await tester.tap(find.byTooltip('Créer un duel'));
    await tester.pumpAndSettle();

    expect(find.text('Nouveau duel'), findsOneWidget);
    expect(find.byType(BottomNavBarWidget), findsNothing);
    expect(find.byType(CupertinoTabBar), findsNothing);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('la barre reste sur le feed : absente du résultat', (tester) async {
    await pumpFeedAvecAuth(tester, authentifie: true, dansShell: true);

    await tester.tap(find.byTooltip('Voter pour B'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Voir le résultat'));
    await tester.pumpAndSettle();

    expect(find.byType(ResultatDuelScreen), findsOneWidget);
    expect(find.byType(BottomNavBarWidget), findsNothing);
    expect(find.byType(CupertinoTabBar), findsNothing);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('barre basse : Profil sélectionne l onglet profil', (tester) async {
    await pumpFeedAvecAuth(tester, authentifie: true, dansShell: true);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    expect(find.byType(UserProfilScreen), findsOneWidget);
    expect(
      tester.widget<CupertinoTabBar>(find.byType(CupertinoTabBar)).currentIndex,
      1,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('invité : passer n écrit rien, n élève pas et ne notifie pas', (
    tester,
  ) async {
    final (
      FakeAuthRepository repository,
      FakeInteractionsServices interactions,
      AuthElevationController elevation,
    ) = await pumpFeedAvecAuth(tester, authentifie: false);

    await tester.tap(find.text('Passer ce duel').last);
    await tester.pumpAndSettle();

    expect(interactions.ajouts, isEmpty);
    expect(repository.elevateCalls, 0);
    expect(elevation.aUneActionEnAttente, isFalse);
    expect(find.byType(AuthenticationScreen), findsNothing);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('passer : le duel sort du tour puis revient sans message', (
    tester,
  ) async {
    await pumpFeedAvecAuth(
      tester,
      authentifie: true,
      postsInitiaux: [
        buildPost(id: 1, question: 'Premier duel'),
        buildPost(id: 2, question: 'Deuxième duel'),
      ],
    );

    await tester.tap(find.text('Passer ce duel').last);
    await tester.pumpAndSettle();

    expect(find.text('Premier duel'), findsNothing);
    expect(find.text('Deuxième duel'), findsOneWidget);

    await tester.tap(find.byTooltip('Voter pour A').last);
    await tester.pumpAndSettle();

    expect(find.text('Premier duel'), findsOneWidget);
    expect(find.text('Vous avez voté sur tous les duels'), findsNothing);
  });

  testWidgets('duel ignoré seul : retour silencieux, sans compteur', (
    tester,
  ) async {
    await pumpFeedAvecAuth(
      tester,
      authentifie: true,
      postsInitiaux: [buildPost(id: 1, question: 'Premier duel')],
    );

    await tester.tap(find.text('Passer ce duel').last);
    await tester.pumpAndSettle();

    expect(find.text('Premier duel'), findsOneWidget);
    expect(find.text('Vous avez voté sur tous les duels'), findsNothing);
    expect(find.textContaining('ignoré'), findsNothing);
  });

  testWidgets('auteur : vote impossible sur son propre duel', (tester) async {
    final (
      FakeAuthRepository repository,
      FakeInteractionsServices interactions,
      AuthElevationController elevation,
    ) = await pumpFeedAvecAuth(
      tester,
      authentifie: true,
      postsInitiaux: [
        buildPost(id: 7, question: 'Mon duel', user: 'utilisateur-1'),
      ],
    );

    expect(
      find.text("C'est votre duel : vous ne pouvez pas voter."),
      findsOneWidget,
    );
    await tester.tap(find.byTooltip('Voter pour A'));
    await tester.pumpAndSettle();

    expect(interactions.ajouts, isEmpty);
    expect(repository.elevateCalls, 0);
    expect(elevation.aUneActionEnAttente, isFalse);
    expect(find.text('Vote enregistré'), findsNothing);
    expect(find.byTooltip('Voter pour A'), findsOneWidget);
    expect(find.byTooltip('Voter pour B'), findsOneWidget);
  });
}

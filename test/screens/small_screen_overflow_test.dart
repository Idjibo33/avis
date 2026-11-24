import 'package:avis/Models/interaction.dart';
import 'package:avis/Models/profile.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Providers/profile_table_provider.dart';
import 'package:avis/Screens/feed_screen.dart';
import 'package:avis/Screens/new_post_screen.dart';
import 'package:avis/Screens/resultat_duel_screen.dart';
import 'package:avis/Screens/user_profil_screen.dart';
import 'package:avis/State/auth_gate_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

const String texteLong =
    'Une question excessivement longue pour vérifier que le rendu ne déborde '
    'pas sur un écran étroit, même quand les options sont elles aussi longues '
    'et que les statistiques prennent toute la largeur disponible';

class ProfilAuPseudoLong extends FakeProfileTableServices {
  @override
  Future<Profile> readDataOnce(String id) async => Profile(
    nom: 'UnPseudoExtremementLongQuiDoitEtreTronqueDansLaBarre',
    prenom: '',
    email: '',
  );
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  AuthServicesProviders authConnecte() {
    final FakeAuthRepository repository = FakeAuthRepository();
    final AuthServicesProviders provider = AuthServicesProviders(
      repository: repository,
    );
    repository.devenirAuthentifie();
    return provider;
  }

  Future<void> setSmallScreen(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('résultat de duel : 320x640 sans débordement', (tester) async {
    await setSmallScreen(tester, const Size(320, 640));
    final FakeInteractionsServices interactions = FakeInteractionsServices()
      ..interactions = [
        Interaction(choix: 'A', postId: 1),
        Interaction(choix: 'B', postId: 1),
      ];
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => InteractionsServicesProvider(interactions: interactions),
        child: MaterialApp(
          home: ResultatDuelScreen(
            post: buildPost(
              question: texteLong * 2,
              optionAText: texteLong,
              optionBText: texteLong,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Nombre total de votes'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('profil : 360x740 avec pseudo long sans débordement', (
    tester,
  ) async {
    await setSmallScreen(tester, const Size(360, 740));
    final FakePostsTableServices posts = FakePostsTableServices();
    addTearDown(posts.close);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authConnecte()),
          ChangeNotifierProvider(
            create: (_) => PostTableProider(postsTableServices: posts),
          ),
          ChangeNotifierProvider(
            create: (_) => InteractionsServicesProvider(
              interactions: FakeInteractionsServices(),
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => ProfileTableProvider(
              profileTableServices: ProfilAuPseudoLong(),
            ),
          ),
        ],
        child: const MaterialApp(home: UserProfilScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    // Le nom vit désormais dans la carte d'en-tête (le titre de l'app bar
    // reste « Mon profil ») et peut occuper deux lignes avant d'être tronqué.
    final Text titre = tester.widget<Text>(
      find.text('UnPseudoExtremementLongQuiDoitEtreTronqueDansLaBarre').first,
    );
    expect(titre.maxLines, 2);
    expect(titre.overflow, TextOverflow.ellipsis);
  });

  testWidgets('feed : carte longue dans le swipe sur 320x640', (tester) async {
    await setSmallScreen(tester, const Size(320, 640));
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
          ChangeNotifierProvider.value(value: authConnecte()),
          ChangeNotifierProvider.value(value: AuthElevationController()),
        ],
        child: const MaterialApp(home: FeedScreen()),
      ),
    );
    await posts.emit([
      buildPost(
        question: texteLong,
        optionAText: texteLong,
        optionBText: texteLong,
      ),
    ]);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('feed : snackbar de vote sur 320x640 sans débordement', (
    tester,
  ) async {
    await setSmallScreen(tester, const Size(320, 640));
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
          ChangeNotifierProvider.value(value: authConnecte()),
          ChangeNotifierProvider.value(value: AuthElevationController()),
        ],
        child: const MaterialApp(home: FeedScreen()),
      ),
    );
    await posts.emit([buildPost()]);
    await tester.pumpAndSettle();

    // La carte défiled avec la barre basse : on amène la cible dans la zone
    // visible avant de voter, comme le ferait un utilisateur sur 320 px.
    await tester.scrollUntilVisible(
      find.byTooltip('Voter pour A'),
      120,
      scrollable: find.descendant(
        of: find.byType(SingleChildScrollView).first,
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Voter pour A'));
    await tester.pumpAndSettle();

    expect(find.text('Vote enregistré'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('nouveau duel : 320x640 sans débordement des onglets', (
    tester,
  ) async {
    await setSmallScreen(tester, const Size(320, 640));
    final FakePostsTableServices posts = FakePostsTableServices();
    addTearDown(posts.close);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => PostTableProider(postsTableServices: posts),
          ),
          ChangeNotifierProvider.value(value: authConnecte()),
          ChangeNotifierProvider.value(value: AuthElevationController()),
        ],
        child: const MaterialApp(home: NewPostScreen()),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Idées'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

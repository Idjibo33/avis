import 'package:avis/Helpers/snackbar.dart';
import 'package:avis/Models/post.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Screens/authentication_screen.dart';
import 'package:avis/State/auth_gate_state.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/button_principale_widget.dart';
import 'package:avis/widgets/texte_post_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

class PostsEnEchec extends FakePostsTableServices {
  @override
  Future addData(Post item) async {
    throw Exception('refus serveur');
  }
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<(FakePostsTableServices, FakeAuthRepository, AuthElevationController)>
  pumpForm(
    WidgetTester tester, {
    required bool authentifie,
    FakePostsTableServices? postsServices,
  }) async {
    final FakePostsTableServices posts =
        postsServices ?? FakePostsTableServices();
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
            create: (_) => AuthServicesProviders(repository: repository),
          ),
          ChangeNotifierProvider.value(value: elevation),
        ],
        child: const MaterialApp(home: Scaffold(body: TextePostFormWidget())),
      ),
    );
    Provider.of<AuthServicesProviders>(
      tester.element(find.byType(TextePostFormWidget)),
      listen: false,
    );
    if (authentifie) {
      repository.devenirAuthentifie();
    } else {
      repository.devenirInvite();
    }
    await tester.pumpAndSettle();
    return (posts, repository, elevation);
  }

  Future<void> saisirDuel(WidgetTester tester) async {
    await tester.enterText(
      find.byType(TextField).at(0),
      'Quelle est la meilleure option ?',
    );
    await tester.enterText(find.byType(TextField).at(1), 'Option A');
    await tester.enterText(find.byType(TextField).at(2), 'Option B');
  }

  testWidgets('Publier reste visible à 320x500 sans défilement', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 500);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await pumpForm(tester, authentifie: true);

    expect(find.byType(ButtonPrincipaleWidget), findsOneWidget);
    final Rect bouton = tester.getRect(find.byType(ButtonPrincipaleWidget));
    expect(bouton.bottom, lessThanOrEqualTo(500));
    expect(bouton.top, greaterThanOrEqualTo(0));
  });

  testWidgets('champs du duel : next, next, done qui publie', (tester) async {
    final (FakePostsTableServices posts, _, _) = await pumpForm(
      tester,
      authentifie: true,
    );

    final List<TextField> champs = tester
        .widgetList<TextField>(find.byType(TextField))
        .toList();
    expect(
      champs.map((TextField champ) => champ.textInputAction).toList(),
      <TextInputAction>[
        TextInputAction.next,
        TextInputAction.next,
        TextInputAction.done,
      ],
    );

    await saisirDuel(tester);
    await tester.tap(find.byType(TextField).at(2));
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(posts.added, hasLength(1));
  });

  testWidgets('la saisie survit à un rebuild du parent', (tester) async {
    final FakePostsTableServices posts = FakePostsTableServices();
    addTearDown(posts.close);
    final PostTableProider provider = PostTableProider(
      postsTableServices: posts,
      storageServices: FakeStorageServices(),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => provider,
        child: const MaterialApp(home: Scaffold(body: TextePostFormWidget())),
      ),
    );

    await tester.enterText(
      find.byType(TextField).at(0),
      'Quelle est la meilleure option ?',
    );
    provider.notifyListeners();
    await tester.pump();

    expect(find.text('Quelle est la meilleure option ?'), findsOneWidget);
  });

  testWidgets('champs vides : message explicite et aucune publication', (
    tester,
  ) async {
    final FakePostsTableServices posts = FakePostsTableServices();
    addTearDown(posts.close);
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PostTableProider(
          postsTableServices: posts,
          storageServices: FakeStorageServices(),
        ),
        child: MaterialApp(
          scaffoldMessengerKey: messengerKey,
          home: const Scaffold(body: TextePostFormWidget()),
        ),
      ),
    );

    await tester.tap(find.text('Publier'));
    await tester.pumpAndSettle();

    expect(find.text('Toutes les cases sont obligatoires'), findsOneWidget);
    expect(find.text('Ce champ est obligatoire.'), findsNWidgets(3));
    expect(posts.added, isEmpty);
  });

  testWidgets('authentifié : publication puis effacement des champs', (
    tester,
  ) async {
    final (FakePostsTableServices posts, _, _) = await pumpForm(
      tester,
      authentifie: true,
    );

    await saisirDuel(tester);
    await tester.tap(find.text('Publier'));
    await tester.pumpAndSettle();

    expect(posts.added, hasLength(1));
    expect(posts.added.single.question, 'Quelle est la meilleure option ?');
    expect(
      tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
      isEmpty,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).controller!.text,
      isEmpty,
    );
  });

  testWidgets('échec de publication : la saisie est conservée', (tester) async {
    final (FakePostsTableServices posts, _, _) = await pumpForm(
      tester,
      authentifie: true,
      postsServices: PostsEnEchec(),
    );

    await saisirDuel(tester);
    await tester.tap(find.text('Publier'));
    await tester.pumpAndSettle();

    expect(posts.added, isEmpty);
    expect(
      tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
      'Quelle est la meilleure option ?',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).controller!.text,
      'Option A',
    );
  });

  testWidgets(
    'invité : une fermeture de feuille garde la saisie et ne publie pas',
    (tester) async {
      final (
        FakePostsTableServices posts,
        _,
        AuthElevationController elevation,
      ) = await pumpForm(
        tester,
        authentifie: false,
      );

      await saisirDuel(tester);
      await tester.tap(find.text('Publier'));
      await tester.pumpAndSettle();

      expect(find.byType(AuthenticationScreen), findsOneWidget);
      expect(elevation.aUneActionEnAttente, isTrue);
      expect(posts.added, isEmpty);

      await tester.tap(find.byTooltip('Fermer'));
      await tester.pumpAndSettle();

      expect(posts.added, isEmpty);
      expect(elevation.aUneActionEnAttente, isFalse);
      expect(
        tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
        'Quelle est la meilleure option ?',
      );
    },
  );

  testWidgets(
    'invité sans AuthElevationController : la feuille s ouvre et publie',
    (tester) async {
      final FakePostsTableServices posts = FakePostsTableServices();
      final FakeAuthRepository repository = FakeAuthRepository();
      addTearDown(posts.close);
      addTearDown(repository.close);

      // Reproduction de la route poussée : les providers de données vivent
      // au-dessus du Navigator, mais AuthElevationController est porté par
      // AuthGate dans la route d'accueil et n'est donc pas visible ici.
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
              create: (_) => AuthServicesProviders(repository: repository),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: TextePostFormWidget())),
        ),
      );
      Provider.of<AuthServicesProviders>(
        tester.element(find.byType(TextePostFormWidget)),
        listen: false,
      );
      repository.devenirInvite();
      await tester.pumpAndSettle();

      await saisirDuel(tester);
      await tester.tap(find.text('Publier'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(AuthenticationScreen), findsOneWidget);
      expect(posts.added, isEmpty);

      await tester.enterText(find.byType(TextField).at(3), 'joueur_1');
      await tester.enterText(find.byType(TextField).at(4), 'motdepasse1');
      await tester.tap(find.text('Créer mon compte'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(posts.added, hasLength(1));
      expect(
        tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
        isEmpty,
      );
    },
  );

  testWidgets('invité : une élévation réussie publie puis vide la saisie', (
    tester,
  ) async {
    final (FakePostsTableServices posts, FakeAuthRepository repository, _) =
        await pumpForm(tester, authentifie: false);

    await saisirDuel(tester);
    await tester.tap(find.text('Publier'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(3), 'joueur_1');
    await tester.enterText(find.byType(TextField).at(4), 'motdepasse1');
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();

    expect(repository.dernierPseudo, 'joueur_1');
    expect(posts.added, hasLength(1));
    expect(
      tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
      isEmpty,
    );
  });

  testWidgets('le formulaire texte utilise la gouttière de l app', (tester) async {
    await pumpForm(tester, authentifie: true);

    final Padding marge = tester.widgetList<Padding>(
      find.descendant(
        of: find.byType(TextePostFormWidget),
        matching: find.byType(Padding),
      ),
    ).first;
    expect(marge.padding, const EdgeInsets.symmetric(horizontal: espaceXl));
  });
}

import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Screens/authentication_screen.dart';
import 'package:avis/State/auth_gate_state.dart';
import 'package:avis/widgets/texte_post_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<(FakePostsTableServices, FakeAuthRepository, AuthElevationController)>
  pumpForm(WidgetTester tester, {required bool authentifie}) async {
    final FakePostsTableServices posts = FakePostsTableServices();
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
}

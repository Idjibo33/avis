import 'dart:convert';
import 'dart:io';

import 'package:avis/Helpers/snackbar.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/button_principale_widget.dart';
import 'package:avis/widgets/photos_post_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  /// PNG 1x1 valide : la vignette [Image.file] doit pouvoir le décoder.
  Future<String> cheminImageTemporaire() async {
    final File fichier = File(
      '${Directory.systemTemp.path}/avis_ui_polish_${DateTime.now().microsecondsSinceEpoch}.png',
    );
    await fichier.writeAsBytes(
      base64.decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADElEQVR4nGNgYGAAAAAEAAH2FzhVAAAAAElFTkSuQmCC',
      ),
    );
    addTearDown(() async {
      if (await fichier.exists()) await fichier.delete();
    });
    return fichier.path;
  }

  /// Compteur mutable : le handler vit après le retour de cette fonction.
  List<int> simulerSelecteurImage(String chemin) {
    final List<int> selections = <int>[0];
    const MethodChannel canal = MethodChannel(
      'plugins.flutter.io/image_picker',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(canal, (MethodCall appel) async {
          if (appel.method == 'pickImage') {
            selections[0]++;
            return chemin;
          }
          return null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(canal, null),
    );
    return selections;
  }

  Future<FakePostsTableServices> pumpForm(
    WidgetTester tester, {
    double? hauteur,
    bool authentifie = false,
  }) async {
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
            create: (_) => AuthServicesProviders(repository: repository),
          ),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: messengerKey,
          home: Scaffold(
            body: hauteur == null
                ? const PhotosPostFormWidget()
                : SizedBox(
                    height: hauteur,
                    child: const PhotosPostFormWidget(),
                  ),
          ),
        ),
      ),
    );
    Provider.of<AuthServicesProviders>(
      tester.element(find.byType(PhotosPostFormWidget)),
      listen: false,
    );
    if (authentifie) {
      repository.devenirAuthentifie();
    } else {
      repository.devenirInvite();
    }
    await tester.pumpAndSettle();
    return posts;
  }

  testWidgets(
    'Publier reste visible sans défilement malgré les deux grandes images',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await pumpForm(tester, hauteur: 500);

      expect(find.byType(ButtonPrincipaleWidget), findsOneWidget);
      final Rect bouton = tester.getRect(find.byType(ButtonPrincipaleWidget));
      expect(bouton.bottom, lessThanOrEqualTo(500));
    },
  );

  testWidgets('sans images : message explicite et aucune publication', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final FakePostsTableServices posts = await pumpForm(tester);

    await tester.enterText(find.byType(TextField), 'Question ?');
    await tester.tap(find.text('Publier'));
    await tester.pumpAndSettle();

    expect(find.text('Toutes les cases sont obligatoires'), findsOneWidget);
    expect(posts.added, isEmpty);
  });

  testWidgets('images manquantes : indication inline sous les deux options', (
    tester,
  ) async {
    await pumpForm(tester);

    await tester.enterText(find.byType(TextField), 'Question ?');
    await tester.tap(find.text('Publier'));
    await tester.pumpAndSettle();

    expect(find.text('Toutes les cases sont obligatoires'), findsOneWidget);
    expect(find.text('Ajoutez une image.'), findsNWidgets(2));
  });

  testWidgets(
    'remplacer, retirer, puis publication : les deux sélecteurs reviennent',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      // Les E/S réelles doivent sortir de la zone fake_async des widget tests.
      final String chemin = (await tester.runAsync(cheminImageTemporaire))!;
      final List<int> selections = simulerSelecteurImage(chemin);
      final FakePostsTableServices posts = await pumpForm(
        tester,
        authentifie: true,
      );
      final semantics = tester.ensureSemantics();

      await tester.enterText(find.byType(TextField), 'Question ?');
      expect(
        tester.widget<TextField>(find.byType(TextField)).textInputAction,
        TextInputAction.done,
      );
      // Les libellés de vignettes sont fusionnés avec celui de l'option dans
      // l'arbre de sémantique : on cherche donc une correspondance partielle.
      final Finder ajouterImage = find.bySemanticsLabel(
        RegExp(r'Ajouter une image'),
      );
      expect(ajouterImage, findsNWidgets(2));

      await tester.tap(ajouterImage.first);
      await tester.pumpAndSettle();
      expect(selections[0], 1);
      expect(ajouterImage, findsOneWidget); // il ne reste que l'option B
      expect(
        find.bySemanticsLabel(RegExp(r"Remplacer l'image")),
        findsOneWidget,
      );
      expect(find.byTooltip("Retirer l'image"), findsOneWidget);

      await tester.tap(find.bySemanticsLabel(RegExp(r"Remplacer l'image")));
      await tester.pumpAndSettle();
      expect(selections[0], 2);

      await tester.tap(find.byTooltip("Retirer l'image"));
      await tester.pumpAndSettle();
      expect(ajouterImage, findsNWidgets(2));

      await tester.tap(ajouterImage.first);
      await tester.pumpAndSettle();
      await tester.tap(ajouterImage);
      await tester.pumpAndSettle();
      expect(ajouterImage, findsNothing);

      await tester.tap(find.byType(TextField));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(posts.added, hasLength(1));
      expect(ajouterImage, findsNWidgets(2));
      expect(find.text('Ajouter une image'), findsNWidgets(2));
      expect(find.text('Ajoutez une image.'), findsNothing);
      semantics.dispose();
    },
  );

  testWidgets('le formulaire photos utilise la gouttière de l app', (
    tester,
  ) async {
    await pumpForm(tester);

    final Padding marge = tester.widgetList<Padding>(
      find.descendant(
        of: find.byType(PhotosPostFormWidget),
        matching: find.byType(Padding),
      ),
    ).first;
    expect(marge.padding, const EdgeInsets.symmetric(horizontal: espaceXl));
  });
}

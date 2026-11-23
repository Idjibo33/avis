import 'package:avis/Models/interaction.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Screens/resultat_duel_screen.dart';
import 'package:avis/widgets/card_widget.dart';
import 'package:avis/widgets/duel_resultat_pourcentage_widget.dart';
import 'package:avis/widgets/duel_resultat_total.dart';
import 'package:avis/widgets/expanded_image.dart';
import 'package:avis/widgets/header_card_widget.dart';
import 'package:avis/widgets/image_post_content_widget.dart';
import 'package:avis/widgets/mini_card_widget.dart';
import 'package:avis/widgets/profile_header_widget.dart';
import 'package:avis/widgets/resultat_card_widget.dart';
import 'package:avis/widgets/tab_bar_buton_widget.dart';
import 'package:avis/widgets/text_post_content_widget.dart';
import 'package:avis/widgets/user_statistics_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

const String texteLong =
    'Une option avec un texte excessivement long qui doit occuper plusieurs '
    'lignes et déborder du cadre si aucune contrainte nest appliquée ici '
    'encore et encore et encore jusquà ce que la hauteur soit dépassée '
    'largement dans un écran très étroit de trois cent vingt pixels';

AuthServicesProviders authAuthentifie() {
  final FakeAuthRepository repository = FakeAuthRepository();
  final AuthServicesProviders provider = AuthServicesProviders(
    repository: repository,
  );
  repository.devenirAuthentifie();
  return provider;
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> pumpSmall(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('options longues : le texte reste dans son cadre', (
    tester,
  ) async {
    await pumpSmall(
      tester,
      TextPostContentWidget(
        heights: 250,
        optionA: texteLong * 2,
        optionB: texteLong * 2,
      ),
    );

    final Rect cadre = tester.getRect(find.byType(TextPostContentWidget));
    for (final int index in [0, 1]) {
      final Rect texte = tester.getRect(find.text(texteLong * 2).at(index));
      expect(texte.top, greaterThanOrEqualTo(cadre.top));
      expect(texte.bottom, lessThanOrEqualTo(cadre.bottom));
    }
    final Text premiere = tester.widget<Text>(find.text(texteLong * 2).first);
    expect(premiere.maxLines, isNotNull);
    expect(premiere.overflow, TextOverflow.ellipsis);
    expect(tester.takeException(), isNull);
  });

  testWidgets('carte du feed : contenu long défilable sans débordement', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => InteractionsServicesProvider(
          interactions: FakeInteractionsServices(),
        ),
        child: MaterialApp(
          home: Scaffold(
            body: CardWidget(
              post: buildPost(
                nom: 'UnPseudoExtremementLongPourTesterLeRendu',
                question: texteLong,
                optionAText: texteLong * 2,
                optionBText: texteLong * 2,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.descendant(
        of: find.byType(CardWidget),
        matching: find.byType(SingleChildScrollView),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('carte de résultat : textes longs sans débordement', (
    tester,
  ) async {
    await pumpSmall(
      tester,
      ResultatCardWidget(
        post: buildPost(optionAText: texteLong * 2, optionBText: texteLong * 2),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('mini-carte : textes longs sans débordement', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => InteractionsServicesProvider(
          interactions: FakeInteractionsServices(),
        ),
        child: MaterialApp(
          home: Scaffold(
            body: MiniCardWidget(
              post: buildPost(
                optionAText: texteLong * 2,
                optionBText: texteLong * 2,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('en-têtes : pseudo et date longs sans débordement', (
    tester,
  ) async {
    await pumpSmall(
      tester,
      const Column(
        children: [
          HeaderCardWidget(
            nom: 'UnPseudoExtremementLongPourTesterLeRenduSansEspaceABCDEF',
            date:
                'date-invalide-extremement-longue-qui-ne-peut-pas-etre-formatee',
          ),
          ProfileHeaderWidget(
            nom: 'UnNomExtremementLongPourTesterLeRendu',
            prenom: 'UnPrenomExtremementLongAussi',
          ),
        ],
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('pourcentages et total : largeur réduite sans débordement', (
    tester,
  ) async {
    final interactions = FakeInteractionsServices()
      ..interactions = List.generate(
        9,
        (i) => Interaction(choix: i.isEven ? 'A' : 'B', postId: 1),
      );
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => InteractionsServicesProvider(interactions: interactions),
        child: const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SizedBox(
                  width: 140,
                  child: DuelResultatPourcentageWidget(postId: 1),
                ),
                SizedBox(width: 140, child: DuelResultatTotal(postId: 1)),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('statistiques : deux colonnes tiennent sur 320 px', (
    tester,
  ) async {
    final posts = FakePostsTableServices();
    addTearDown(posts.close);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authAuthentifie()),
          ChangeNotifierProvider(
            create: (_) => PostTableProider(postsTableServices: posts),
          ),
          ChangeNotifierProvider(
            create: (_) => InteractionsServicesProvider(
              interactions: FakeInteractionsServices(),
            ),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: UserStatisticsWidget())),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final Row rangee = tester.widget<Row>(find.byType(Row).first);
    expect(
      rangee.children.whereType<Expanded>().length,
      2,
      reason: 'les deux statistes doivent se partager la largeur',
    );
  });

  testWidgets('onglet : libellé long tronqué sans débordement', (tester) async {
    await pumpSmall(
      tester,
      const TabBarButonWidget(
        icone: Icon(Icons.image),
        texte: 'Photos et autres textes vraiment longs',
      ),
    );

    final Text texte = tester.widget<Text>(find.textContaining('Photos'));
    expect(texte.maxLines, 1);
    expect(texte.overflow, TextOverflow.ellipsis);
    expect(tester.takeException(), isNull);
  });

  testWidgets('images de duel : cadres bornés en largeur et hauteur', (
    tester,
  ) async {
    // Le widget est construit sans être monté : évite une requête réseau tout
    // en vérifiant les contraintes appliquées aux deux images.
    await pumpSmall(tester, const SizedBox(key: ValueKey('contexte')));
    final BuildContext context = tester.element(
      find.byKey(const ValueKey('contexte')),
    );
    final Row rangee =
        ImagePostContentWidget(
              heights: 150,
              optionAUrl: 'https://img.test/a.jpg',
              optionBUrl: 'https://img.test/b.jpg',
            ).build(context)
            as Row;

    expect(rangee.children, hasLength(3));
    for (final Expanded enfant in rangee.children.whereType<Expanded>()) {
      final ClipRRect clip = enfant.child as ClipRRect;
      final SizedBox cadre = clip.child! as SizedBox;
      expect(cadre.width, double.infinity);
      expect(cadre.height, 150);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('image agrandie : contrainte de taille et BoxFit.contain', (
    tester,
  ) async {
    await pumpSmall(tester, const SizedBox(key: ValueKey('contexte')));
    final BuildContext context = tester.element(
      find.byKey(const ValueKey('contexte')),
    );
    final Stack pile =
        ExpandedImage(imageUrl: 'https://img.test/a.jpg').build(context)
            as Stack;

    final Image image = pile.children.first as Image;
    expect(image.width, double.infinity);
    expect(image.height, double.infinity);
    expect(image.fit, BoxFit.contain);
    expect(tester.takeException(), isNull);
  });

  testWidgets('image agrandie : fermeture ancrée en haut à droite', (
    tester,
  ) async {
    await pumpSmall(tester, const SizedBox(key: ValueKey('contexte')));
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox.expand(
            child: ExpandedImage(imageUrl: 'https://img.test/a.jpg'),
          ),
        ),
      ),
    );

    final Rect cadre = tester.getRect(find.byType(ExpandedImage));
    final Rect bouton = tester.getRect(find.byType(CloseButton));
    expect(bouton.center.dx, greaterThan(cadre.center.dx));
    expect(bouton.center.dy, lessThan(cadre.center.dy));
    expect(cadre.right - bouton.right, lessThan(32));
    expect(bouton.top - cadre.top, lessThan(32));
    // Image.network est montée ici : le 400 du banc de test est sans rapport
    // avec la géométrie vérifiée.
    tester.takeException();
  });

  testWidgets('écran de résultat : long textes et pourcentages sur 320 px', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => InteractionsServicesProvider(
          interactions: FakeInteractionsServices(),
        ),
        child: MaterialApp(
          home: ResultatDuelScreen(
            post: buildPost(
              question: texteLong * 2,
              optionAText: texteLong * 2,
              optionBText: texteLong * 2,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}

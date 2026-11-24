import 'package:avis/widgets/expanded_image.dart';
import 'package:avis/widgets/image_post_content_widget.dart';
import 'package:avis/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<BuildContext> contexte(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SizedBox(key: ValueKey('contexte'))),
      ),
    );
    return tester.element(find.byKey(const ValueKey('contexte')));
  }

  testWidgets('image de duel : étiquette sémantique explicite', (tester) async {
    final BuildContext context = await contexte(tester);

    final GestureDetector detecteur =
        ImageWidget(
              url: 'https://img.test/a.jpg',
              height: 100,
              semanticLabel: 'Image de l’option A',
            ).build(context)
            as GestureDetector;
    final Image image = detecteur.child! as Image;

    expect(image.semanticLabel, 'Image de l’option A');
    expect(image.fit, BoxFit.cover);
    expect(image.height, 100);
  });

  testWidgets('images du post : chaque option est nommée', (tester) async {
    final BuildContext context = await contexte(tester);

    final Row rangee =
        ImagePostContentWidget(
              heights: 150,
              optionAUrl: 'https://img.test/a.jpg',
              optionBUrl: 'https://img.test/b.jpg',
            ).build(context)
            as Row;

    final List<String?> etiquettes = rangee.children
        .whereType<Expanded>()
        .map(
          (Expanded enfant) =>
              (((enfant.child as ClipRRect).child! as SizedBox).child!
                      as ImageWidget)
                  .semanticLabel,
        )
        .toList();

    expect(etiquettes, ['Image de l’option A', 'Image de l’option B']);
  });

  testWidgets('image agrandie : étiquette sémantique dédiée', (tester) async {
    final BuildContext context = await contexte(tester);

    final Stack pile =
        ExpandedImage(imageUrl: 'https://img.test/a.jpg').build(context)
            as Stack;
    final Image image = pile.children.first as Image;

    expect(image.semanticLabel, contains('agrandie'));
  });

  testWidgets('image agrandie : le bouton ferme la boîte de dialogue', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showGeneralDialog(
                context: context,
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ExpandedImage(imageUrl: 'https://img.test/a.jpg'),
              ),
              child: const Text('agrandir'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('agrandir'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(ExpandedImage), findsOneWidget);

    await tester.tap(find.byType(CloseButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.byType(ExpandedImage), findsNothing);
    // Le banc de test répond 400 aux images réseau : ce bruit est attendu.
    tester.takeException();
  });
}

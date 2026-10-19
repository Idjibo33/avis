import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Screens/feed_screen.dart';
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

  testWidgets('erreur de flux : message convivial et bouton réessayer',
      (tester) async {
    final FakePostsTableServices posts = await pumpFeed(tester);

    await posts.emitError(Exception('boom'));
    await tester.pump();

    expect(find.text('Impossible de charger le feed'), findsOneWidget);
    expect(find.text('Réessayer'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}

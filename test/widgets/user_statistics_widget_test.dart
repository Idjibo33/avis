import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/user_statistics_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> pumpStatistiques(WidgetTester tester) async {
    final FakeAuthRepository repository = FakeAuthRepository();
    final AuthServicesProviders auth = AuthServicesProviders(
      repository: repository,
    );
    repository.devenirAuthentifie();
    final FakePostsTableServices posts = FakePostsTableServices();
    addTearDown(posts.close);
    addTearDown(auth.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: auth),
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
  }

  testWidgets('statistiques : les compteurs à zéro restent affichés', (
    tester,
  ) async {
    await pumpStatistiques(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Publications'), findsOneWidget);
    expect(find.text('Votes'), findsOneWidget);
    expect(find.text('0'), findsNWidgets(2));
  });

  testWidgets('statistiques : les deux compteurs ont des chiffres tabulaires', (
    tester,
  ) async {
    await pumpStatistiques(tester);

    for (final Text compteur
        in tester.widgetList<Text>(find.text('0')).toList()) {
      expect(
        compteur.style?.fontFeatures?.map((feature) => feature.feature),
        contains('tnum'),
      );
      expect(compteur.style?.fontSize, 25);
      expect(compteur.style?.color, noir);
    }
  });
}

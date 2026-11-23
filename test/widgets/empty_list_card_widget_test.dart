import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Screens/authentication_screen.dart';
import 'package:avis/Screens/new_post_screen.dart';
import 'package:avis/widgets/empty_list_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('le CTA du vide passe par la feuille d élévation', (
    tester,
  ) async {
    final FakePostsTableServices posts = FakePostsTableServices();
    final FakeAuthRepository depot = FakeAuthRepository();
    final AuthServicesProviders auth = AuthServicesProviders(repository: depot);
    addTearDown(posts.close);
    addTearDown(depot.close);
    addTearDown(auth.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => PostTableProider(postsTableServices: posts),
          ),
          ChangeNotifierProvider.value(value: auth),
        ],
        child: const MaterialApp(home: Scaffold(body: EmptyListCardWidget())),
      ),
    );
    depot.devenirInvite();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Créer un duel'));
    await tester.pumpAndSettle();

    expect(find.byType(AuthenticationScreen), findsOneWidget);
    expect(find.byType(NewPostScreen), findsNothing);

    await tester.enterText(find.byType(TextField).at(0), 'joueur_1');
    await tester.enterText(find.byType(TextField).at(1), 'motdepasse1');
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();

    expect(find.byType(NewPostScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

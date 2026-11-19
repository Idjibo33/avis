import 'package:avis/Helpers/snackbar.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/widgets/button_principale_widget.dart';
import 'package:avis/widgets/photos_post_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<FakePostsTableServices> pumpForm(
    WidgetTester tester, {
    double? hauteur,
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
    repository.devenirInvite();
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
}

import 'package:avis/Providers/post_table_proider.dart';
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
        child: const MaterialApp(
          home: Scaffold(body: TextePostFormWidget()),
        ),
      ),
    );

    await tester.enterText(
      find.byType(TextField).at(0),
      'Quelle est la meilleure option ?',
    );
    provider.notifyListeners();
    await tester.pump();

    expect(
      find.text('Quelle est la meilleure option ?'),
      findsOneWidget,
    );
  });
}

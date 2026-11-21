import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Services/auth_repository.dart';
import 'package:avis/State/auth_gate_state.dart';
import 'package:avis/auth_gate.dart';
import 'package:avis/Screens/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

class InviteAuDemarrage extends FakeAuthRepository {
  @override
  Future<void> initialize() async {
    await super.initialize();
    devenirInvite();
  }
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> pumpGate(
    WidgetTester tester, {
    required FakeAuthRepository repository,
  }) async {
    final FakePostsTableServices posts = FakePostsTableServices();
    addTearDown(posts.close);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthServicesProviders(repository: repository),
          ),
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
        child: const MaterialApp(home: AuthGate()),
      ),
    );
    // Les indicateurs de chargement sont animés en continu : pump() suffit à
    // laisser tourner le callback de frame et le flux de session.
    await tester.pump();
    await tester.pump();
    await tester.pump();
  }

  testWidgets('invité : le feed s affiche sans écran de connexion', (
    tester,
  ) async {
    final FakeAuthRepository repository = InviteAuDemarrage();
    addTearDown(repository.close);
    await pumpGate(tester, repository: repository);

    expect(tester.takeException(), isNull);
    expect(find.byType(FeedScreen), findsOneWidget);
    expect(find.text('Créez votre compte'), findsNothing);
    expect(repository.initializeCalls, 1);
  });

  testWidgets('session inconnue : chargement sans feed', (tester) async {
    final FakeAuthRepository repository = FakeAuthRepository();
    addTearDown(repository.close);
    await pumpGate(tester, repository: repository);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(FeedScreen), findsNothing);
  });

  testWidgets('échec de session : message explicite et retry sans ValueKey', (
    tester,
  ) async {
    final FakeAuthRepository repository = FakeAuthRepository();
    addTearDown(repository.close);
    await pumpGate(tester, repository: repository);

    repository.emit(
      const AuthSessionState(status: AuthSessionStatus.failed, error: 'boom'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Impossible de vérifier la session'), findsOneWidget);
    expect(find.textContaining('boom'), findsOneWidget);
    expect(find.byType(FeedScreen), findsNothing);

    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();
    expect(repository.initializeCalls, 2);
  });

  testWidgets('le contrôleur d élévation est disponible sous le gate', (
    tester,
  ) async {
    final FakeAuthRepository repository = InviteAuDemarrage();
    addTearDown(repository.close);
    await pumpGate(tester, repository: repository);

    final BuildContext context = tester.element(find.byType(FeedScreen));
    final AuthElevationController controller =
        Provider.of<AuthElevationController>(context, listen: false);

    expect(controller.aUneActionEnAttente, isFalse);
    expect(tester.takeException(), isNull);
  });
}
